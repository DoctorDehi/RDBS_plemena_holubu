-- --------------------
-- 4x SELECT 
---------------------
-- průměrný počet záznamů na tabulku
WITH tbl AS
  (SELECT table_schema,
          TABLE_NAME
   FROM information_schema.tables
   WHERE table_schema in ('public')
     AND TABLE_TYPE = 'BASE TABLE')
SELECT 
	'Průměrný počet záznamů: ',
	AVG((xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %I.%I', table_schema, TABLE_NAME), FALSE, TRUE, '')))[1]::text::int) AS rows_n
FROM tbl
ORDER BY rows_n DESC;


-- vnořený select
-- průměrný počet barevných rázů skupiny
SELECT s.nazev, AVG(pocet_razu) 
FROM skupiny s 
LEFT JOIN (
	SELECT p.nazev AS nazev_plemene, COUNT(pr) AS pocet_razu, p.skupina AS skupina
	FROM plemena p
	INNER JOIN plemena_razy pr ON pr.ple = p.id_ple 
	GROUP BY p.nazev, p.skupina
) p2 ON p2.skupina = s.id_sku 
GROUP BY s.nazev;



--select s analytickou funkcí
-- počet barevných rázů plemene
SELECT p.nazev, COUNT(pr)
FROM skupiny s 
LEFT JOIN plemena p ON p.skupina  = s.id_sku 
INNER JOIN plemena_razy pr ON pr.ple = p.id_ple 
GROUP BY p.nazev, p.id_ple;




--hierarchie
SELECT DISTINCT s.nazev 
FROM  skupiny s 
RIGHT JOIN plemena p ON p.skupina = s.id_sku 
LEFT JOIN plemena_razy pr ON pr.ple = p.id_ple  
INNER JOIN barevne_razy br ON br.id_raz = pr.raz 
INNER JOIN barvy b ON b.id_bar = br.bar 
WHERE b.nazev = 'modří';



-------------
-- VIEW
-------------
CREATE OR REPLACE VIEW plemena_shrnuti AS 
	SELECT 
		p.nazev AS "plemeno", 
		s.nazev AS "skupina", 
		mp.nazev AS "místo původu", 
		zp.zkratka AS "země původu",
		count(DISTINCT b.id_bar) AS "počet barev", 
		count(DISTINCT  k.id_kre) AS "počet kreseb"
	FROM  skupiny s 
	RIGHT JOIN plemena p ON p.skupina = s.id_sku 
	LEFT JOIN mista_puvodu mp ON mp.id_mis = p.misto_puvodu 
	LEFT JOIN zeme_puvodu zp ON zp.id_zem = mp.zeme
	LEFT JOIN plemena_razy pr ON pr.ple = p.id_ple  
	INNER JOIN barevne_razy br ON br.id_raz = pr.raz 
	INNER JOIN barvy b ON b.id_bar = br.bar 
	INNER JOIN kresby k ON k.id_kre = br.kre
	GROUP BY s.nazev, p.nazev, mp.nazev, zp.zkratka; 


SELECT * FROM plemena_shrnuti;



---------------
-- INDEX
---------------
-- fulltext GIN index
CREATE EXTENSION pg_trgm;
CREATE EXTENSION btree_gin;
CREATE INDEX idx_strucny_popis_plemene ON plemena USING gin(to_tsvector('simple', strucny_popis));

SELECT nazev,strucny_popis 
FROM plemena p 
WHERE to_tsvector('simple', strucny_popis) @@ to_tsquery('simple', 'letu & hlavních');

SELECT nazev, strucny_popis 
FROM plemena p 
WHERE to_tsvector('simple', strucny_popis) @@ to_tsquery('simple', 'temperamentní & (let | letovými)');

-- český fulltext GIN index
CREATE INDEX idx_strucny_popis_plemene_cs ON plemena USING gin(to_tsvector('cs', strucny_popis));

SELECT nazev,strucny_popis 
FROM plemena p 
WHERE to_tsvector('cs', strucny_popis) @@ to_tsquery('simple', 'let & hlavní');

SELECT nazev, strucny_popis 
FROM plemena p 
WHERE to_tsvector('cs', strucny_popis) @@ to_tsquery('simple', 'temperamentní & (let | letový)');


SELECT nazev, strucny_popis 
FROM plemena p 
WHERE to_tsvector('cs', strucny_popis) @@ to_tsquery('temperamentní & let:*');


SELECT
 ts_rank(to_tsvector('cs', strucny_popis), query) AS RANK, nazev, strucny_popis 
FROM plemena p, to_tsquery('holub:*') AS query
WHERE to_tsvector('cs', strucny_popis) @@ query
ORDER BY rank DESC
LIMIT 4;




---------------
-- FUNCTION
---------------
CREATE OR REPLACE FUNCTION pocet_plemen_v_barve(barva CHARACTER) RETURNS
CHARACTER AS $$
	SELECT COUNT(DISTINCT p.id_ple)
	FROM plemena p
	LEFT JOIN plemena_razy pr ON pr.ple = p.id_ple  
	INNER JOIN barevne_razy br ON br.id_raz = pr.raz 
	INNER JOIN barvy b ON b.id_bar = br.bar 
	WHERE b.nazev = barva;
$$ LANGUAGE SQL STABLE;


SELECT  pocet_plemen_v_barve('modří');

SELECT  pocet_plemen_v_barve('siví');

SELECT  pocet_plemen_v_barve('barvy poštovní řady');

SELECT  pocet_plemen_v_barve('červení');




--------------------------------
-- PROCEDURE AND TRANSACTION 
--------------------------------
-- vygeneruje tabulku plemena měsíce
-- naplní ji náhodně vybranými plemeny
-- pokud se plemeno nevyskytuje v minimálním počtu barevných rázů, je z tabulky smazáno (rollback)
-- k plemeni vybere náhodně barevný ráz

CREATE OR REPLACE PROCEDURE choose_breeds(n integer, min_razu integer)
AS $$
DECLARE 
	plemeno_row plemena%ROWTYPE;
    cur_plemena CURSOR FOR 
				SELECT * 
				FROM plemena
				ORDER BY RANDOM();
	counter integer := 0; 
	razy_count integer;

BEGIN
	BEGIN
	DROP TABLE IF EXISTS plemena_mesice;
	CREATE TABLE plemena_mesice(
		id_plem serial PRIMARY KEY,
		nazev varchar(50),
		barevny_raz varchar(100)
	);
	END;

	OPEN cur_plemena;
	LOOP
		EXIT WHEN counter = n; 
		razy_count = 0;
		BEGIN
			FETCH NEXT FROM cur_plemena INTO plemeno_row;
			INSERT INTO plemena_mesice(nazev) VALUES (plemeno_row.nazev);
			
		-- kontrola splnění podmínky počtu baravných rázů
			SELECT count(raz) INTO razy_count
				FROM plemena_razy pr 
				JOIN plemena p ON p.id_ple = pr.ple 
				WHERE p.id_ple = plemeno_row.id_ple;
		
			IF (razy_count > (min_razu - 1)) THEN 
				counter := counter + 1; 
				UPDATE plemena_mesice SET barevny_raz = (
					SELECT barevny_raz 
					FROM plemena_barevne_razy_cele pbrc 
					WHERE plemeno = plemeno_row.nazev 
					ORDER BY RANDOM() 
					LIMIT 1)
				WHERE nazev = plemeno_row.nazev;
			ELSE
				RAISE EXCEPTION 'nedostatek_razu' USING ERRCODE='50001';
			END IF;
		
		EXCEPTION 
			WHEN SQLSTATE '50001' THEN 
				CONTINUE;
		END;	
	END LOOP;

EXCEPTION
    WHEN no_data_found THEN
       RAISE EXCEPTION 'nenalezena žádná data';
END;
$$
LANGUAGE PLPGSQL;


CALL choose_breeds(3, 40);






---------------
-- TRIGGER
---------------

CREATE TABLE plemena_inserted_log(
	id_ins serial PRIMARY KEY,
	plemeno int NOT NULL,
	datum timestamp NOT NULL, 
	uzivatel varchar NOT NULL
);


ALTER TABLE plemena_inserted_log
  ADD CONSTRAINT plemeno_fk
  FOREIGN KEY (plemeno)
  REFERENCES plemena(id_ple)
  ON DELETE CASCADE;
 
 
  select user

CREATE OR REPLACE FUNCTION log_plemeno_inserted()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL 
	AS $$
	BEGIN 
		INSERT INTO plemena_inserted_log(plemeno, datum, uzivatel) VALUES (
		NEW.id_ple, NOW(), user);
		RETURN NEW;
	END;
	$$
	
	
	

CREATE OR REPLACE TRIGGER plemeno_inserted
	AFTER INSERT	
	ON plemena
	FOR EACH ROW
		EXECUTE PROCEDURE log_plemeno_inserted();

	
SELECT * FROM plemena p  ;	
INSERT INTO zeme_puvodu(nazev, zkratka) VALUES ('Rakousko', 'AT');
INSERT INTO mista_puvodu VALUES	(14, 'Horní Rakousko', 2);

		
INSERT INTO plemena(id_ple, nazev, de_nazev, uk_nazev, skupina, velikost, misto_puvodu, krouzek, strucny_popis, narodni_plemeno)
	VALUES(
		24,
		'Vídeňský slepičák',
		'Huhnschecke',
		'Hungarian',
		3,
		3,
		14,
		10,
		'Silným, hrdým dojmem působící slepičák. Nápadná kresba je vlastní tomuto plemeni.',
		false
		
	);

SELECT * FROM plemena_inserted_log; 



SELECT br.id_raz, b.nazev , k.nazev  FROM barevne_razy br 
INNER JOIN barvy b ON b.id_bar = br.bar 
INNER JOIN kresby k ON k.id_kre = br.kre ;


INSERT INTO plemena_razy(ple, raz) VALUES
	(24, 91),
	(24, 10),
	(24, 93),
	(24, 94),
	(24, 11),
	(24, 183),
	(24, 101),
	(24, 186),
	(24, 185),
	(24, 238)
	
SELECT b.nazev, k.nazev 
FROM plemena p 
LEFT JOIN plemena_razy pr ON pr.ple  = p.id_ple 
LEFT JOIN barevne_razy br ON br.id_raz = pr.raz 
INNER JOIN barvy b ON b.id_bar = br.bar 
INNER JOIN kresby k ON k.id_kre = br.kre 
WHERE p.id_ple = 24;
	
	
SELECT * FROM barvy


----------------
-- USER
---------------
CREATE ROLE RDBS_guest;
GRANT CONNECT ON DATABASE cznp_holub TO RDBS_guest;
ALTER ROLE RDBS_guest LOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO RDBS_guest;


CREATE USER RDBS_user1 WITH ENCRYPTED PASSWORD 'Heslo4321';
GRANT RDBS_guest TO RDBS_user1;


REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM RDBS_user1;
REVOKE RDBS_guest FROM RDBS_user1;
DROP USER RDBS_user1;


CREATE ROLE testovaci_role;
ALTER ROLE testovaci_role LOGIN;
DROP ROLE testovaci_role;




---------------------
-- LOCK
---------------------
-- uzamknutí tabulky mista_puvodu vcetne selectu
BEGIN;
LOCK TABLE mista_puvodu IN ACCESS EXCLUSIVE MODE;
SELECT * FROM mista_puvodu mp;
END;

-- another session
BEGIN;
SELECT * FROM plemena p; 

-- SELECT z locknuté tabulky 
SELECT * FROM mista_puvodu mp;
END;



----------
-- uzamknuti modifikace tabulky mista_puvodu
BEGIN;
LOCK TABLE mista_puvodu IN SHARE MODE;
SELECT * FROM mista_puvodu mp;
END;

-- another session
BEGIN;
INSERT INTO mista_puvodu(id_mis, nazev, zeme) VALUES (15, 'Ústí nad Labem', 1);
ROLLBACK;



-----------
-- uzamknuti nekterych radku tabulky mista_puvodu proti modifikaci
BEGIN;
SELECT * FROM mista_puvodu mp WHERE zeme = 2 FOR SHARE;
END;


-- another session
BEGIN;
UPDATE mista_puvodu SET zeme = 1 WHERE zeme = 2;
ROLLBACK;



















