CREATE EXTENSION IF NOT EXISTS unaccent;


SELECT 'color--' || replace(unaccent(barvy.nazev), ' ', '-') from barvy;


CREATE  OR REPLACE  FUNCTION colorToCssClass(nazev varchar)
RETURNS varchar AS $$
SELECT 'color--' || replace(unaccent(nazev), ' ', '-');
$$ LANGUAGE SQL STABLE;


SELECT  colorToCssClass(nazev) FROM barvy;