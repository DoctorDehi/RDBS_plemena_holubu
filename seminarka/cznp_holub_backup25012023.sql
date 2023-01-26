--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Ubuntu 14.6-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.6 (Ubuntu 14.6-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: barevne_razy; Type: TABLE; Schema: public; Owner: doctordehi
--

CREATE TABLE public.barevne_razy (
    id_raz integer NOT NULL,
    bar integer NOT NULL,
    kre integer NOT NULL
);


ALTER TABLE public.barevne_razy OWNER TO doctordehi;

--
-- Name: barevne_razy_id_raz_seq; Type: SEQUENCE; Schema: public; Owner: doctordehi
--

CREATE SEQUENCE public.barevne_razy_id_raz_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.barevne_razy_id_raz_seq OWNER TO doctordehi;

--
-- Name: barevne_razy_id_raz_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doctordehi
--

ALTER SEQUENCE public.barevne_razy_id_raz_seq OWNED BY public.barevne_razy.id_raz;


--
-- Name: barvy; Type: TABLE; Schema: public; Owner: doctordehi
--

CREATE TABLE public.barvy (
    id_bar integer NOT NULL,
    nazev character varying(50) NOT NULL
);


ALTER TABLE public.barvy OWNER TO doctordehi;

--
-- Name: barvy_id_bar_seq; Type: SEQUENCE; Schema: public; Owner: doctordehi
--

CREATE SEQUENCE public.barvy_id_bar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.barvy_id_bar_seq OWNER TO doctordehi;

--
-- Name: barvy_id_bar_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doctordehi
--

ALTER SEQUENCE public.barvy_id_bar_seq OWNED BY public.barvy.id_bar;


--
-- Name: kresby; Type: TABLE; Schema: public; Owner: doctordehi
--

CREATE TABLE public.kresby (
    id_kre integer NOT NULL,
    nazev character varying(50) NOT NULL
);


ALTER TABLE public.kresby OWNER TO doctordehi;

--
-- Name: kresby_id_kre_seq; Type: SEQUENCE; Schema: public; Owner: doctordehi
--

CREATE SEQUENCE public.kresby_id_kre_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kresby_id_kre_seq OWNER TO doctordehi;

--
-- Name: kresby_id_kre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doctordehi
--

ALTER SEQUENCE public.kresby_id_kre_seq OWNED BY public.kresby.id_kre;


--
-- Name: mista_puvodu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mista_puvodu (
    id_mis integer NOT NULL,
    nazev character varying(50) NOT NULL
);


ALTER TABLE public.mista_puvodu OWNER TO postgres;

--
-- Name: mista_puvodu_id_mis_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mista_puvodu_id_mis_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mista_puvodu_id_mis_seq OWNER TO postgres;

--
-- Name: mista_puvodu_id_mis_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mista_puvodu_id_mis_seq OWNED BY public.mista_puvodu.id_mis;


--
-- Name: plemena; Type: TABLE; Schema: public; Owner: doctordehi
--

CREATE TABLE public.plemena (
    id_ple integer NOT NULL,
    nazev character varying(50) NOT NULL,
    sk_nazev character varying(50),
    de_nazev character varying(50),
    uk_nazev character varying(50),
    skupina integer NOT NULL,
    velikost integer NOT NULL,
    misto_puvodu integer,
    krouzek integer NOT NULL,
    strucny_popis text
);


ALTER TABLE public.plemena OWNER TO doctordehi;

--
-- Name: plemena_razy; Type: TABLE; Schema: public; Owner: doctordehi
--

CREATE TABLE public.plemena_razy (
    ple integer NOT NULL,
    raz integer NOT NULL
);


ALTER TABLE public.plemena_razy OWNER TO doctordehi;

--
-- Name: plemena_barevne_razy_cele; Type: VIEW; Schema: public; Owner: doctordehi
--

CREATE VIEW public.plemena_barevne_razy_cele AS
 SELECT plemena.nazev AS plemeno,
    (((barvy.nazev)::text || ' '::text) || (kresby.nazev)::text) AS barevny_raz
   FROM ((((public.plemena
     LEFT JOIN public.plemena_razy ON ((plemena.id_ple = plemena_razy.ple)))
     JOIN public.barevne_razy ON ((plemena_razy.raz = barevne_razy.id_raz)))
     JOIN public.barvy ON ((barevne_razy.bar = barvy.id_bar)))
     JOIN public.kresby ON ((barevne_razy.kre = kresby.id_kre)));


ALTER TABLE public.plemena_barevne_razy_cele OWNER TO doctordehi;

--
-- Name: plemena_id_ple_seq; Type: SEQUENCE; Schema: public; Owner: doctordehi
--

CREATE SEQUENCE public.plemena_id_ple_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plemena_id_ple_seq OWNER TO doctordehi;

--
-- Name: plemena_id_ple_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doctordehi
--

ALTER SEQUENCE public.plemena_id_ple_seq OWNED BY public.plemena.id_ple;


--
-- Name: plemena_vsechny_razy; Type: VIEW; Schema: public; Owner: doctordehi
--

CREATE VIEW public.plemena_vsechny_razy AS
 SELECT plemena.nazev AS plemeno,
    barvy.nazev AS barva,
    kresby.nazev AS kresba
   FROM ((((public.plemena
     LEFT JOIN public.plemena_razy ON ((plemena.id_ple = plemena_razy.ple)))
     JOIN public.barevne_razy ON ((plemena_razy.raz = barevne_razy.id_raz)))
     JOIN public.barvy ON ((barevne_razy.bar = barvy.id_bar)))
     JOIN public.kresby ON ((barevne_razy.kre = kresby.id_kre)));


ALTER TABLE public.plemena_vsechny_razy OWNER TO doctordehi;

--
-- Name: skupiny; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skupiny (
    id_sku integer NOT NULL,
    nazev character varying(50) NOT NULL
);


ALTER TABLE public.skupiny OWNER TO postgres;

--
-- Name: skupiny_id_sku_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skupiny_id_sku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.skupiny_id_sku_seq OWNER TO postgres;

--
-- Name: skupiny_id_sku_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skupiny_id_sku_seq OWNED BY public.skupiny.id_sku;


--
-- Name: velikosti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.velikosti (
    id_vel integer NOT NULL,
    nazev character varying(50) NOT NULL
);


ALTER TABLE public.velikosti OWNER TO postgres;

--
-- Name: velikosti_id_vel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.velikosti_id_vel_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.velikosti_id_vel_seq OWNER TO postgres;

--
-- Name: velikosti_id_vel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.velikosti_id_vel_seq OWNED BY public.velikosti.id_vel;


--
-- Name: barevne_razy id_raz; Type: DEFAULT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barevne_razy ALTER COLUMN id_raz SET DEFAULT nextval('public.barevne_razy_id_raz_seq'::regclass);


--
-- Name: barvy id_bar; Type: DEFAULT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barvy ALTER COLUMN id_bar SET DEFAULT nextval('public.barvy_id_bar_seq'::regclass);


--
-- Name: kresby id_kre; Type: DEFAULT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.kresby ALTER COLUMN id_kre SET DEFAULT nextval('public.kresby_id_kre_seq'::regclass);


--
-- Name: mista_puvodu id_mis; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mista_puvodu ALTER COLUMN id_mis SET DEFAULT nextval('public.mista_puvodu_id_mis_seq'::regclass);


--
-- Name: plemena id_ple; Type: DEFAULT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena ALTER COLUMN id_ple SET DEFAULT nextval('public.plemena_id_ple_seq'::regclass);


--
-- Name: skupiny id_sku; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skupiny ALTER COLUMN id_sku SET DEFAULT nextval('public.skupiny_id_sku_seq'::regclass);


--
-- Name: velikosti id_vel; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.velikosti ALTER COLUMN id_vel SET DEFAULT nextval('public.velikosti_id_vel_seq'::regclass);


--
-- Data for Name: barevne_razy; Type: TABLE DATA; Schema: public; Owner: doctordehi
--

COPY public.barevne_razy (id_raz, bar, kre) FROM stdin;
1	6	58
2	8	58
3	10	58
4	31	58
5	27	58
6	9	58
7	30	58
8	13	58
9	17	58
10	21	34
11	21	41
12	27	41
13	10	41
14	31	41
15	14	41
16	6	44
17	8	44
18	10	44
19	31	44
20	27	44
21	9	44
22	30	44
23	13	44
24	17	44
25	21	87
26	21	47
27	27	47
28	10	47
29	31	47
30	14	47
31	6	6
32	8	6
33	10	6
34	31	6
35	27	6
36	9	6
37	30	6
38	13	6
39	17	6
40	21	7
41	21	8
42	27	8
43	10	8
44	31	8
45	14	8
46	8	23
47	21	23
48	10	23
49	31	23
50	17	23
51	8	45
52	10	45
53	31	45
54	21	45
55	8	56
56	10	56
57	31	56
58	21	56
59	28	56
60	14	56
61	6	1
62	6	2
63	6	3
64	6	4
65	6	5
66	6	88
67	21	70
68	8	70
69	10	70
70	31	70
71	28	70
72	21	71
73	21	89
74	9	89
75	30	89
76	8	84
77	21	84
78	10	84
79	31	84
80	8	24
81	21	24
82	10	24
83	31	24
84	21	77
85	10	77
86	8	77
87	31	77
88	6	35
89	6	86
90	6	40
91	8	40
92	21	40
93	10	40
94	31	40
95	27	40
96	26	40
97	6	84
98	27	84
99	26	84
100	28	40
101	14	40
102	16	40
103	1	40
104	9	41
105	30	41
106	27	82
107	32	35
108	28	23
109	12	23
110	27	23
111	32	86
112	21	6
113	32	6
114	27	70
115	8	59
116	21	59
117	10	59
118	31	59
119	21	62
120	21	64
121	32	63
122	32	68
123	8	61
124	21	61
125	10	61
126	31	61
127	8	66
128	21	66
129	10	66
130	31	66
131	8	29
132	21	29
133	10	29
134	31	29
135	8	69
136	21	69
137	10	69
138	31	69
139	14	69
140	32	91
141	32	90
142	10	89
143	31	89
144	27	76
145	24	40
146	15	40
147	8	30
148	14	30
149	21	30
150	10	30
151	31	30
152	21	32
153	8	31
154	10	31
155	21	31
156	31	31
157	14	31
158	8	76
159	14	76
160	24	76
161	21	76
162	10	76
163	31	76
164	14	23
165	24	23
166	27	73
167	27	92
168	8	78
169	10	78
170	21	78
171	31	78
172	27	78
173	8	27
174	8	53
175	21	58
176	14	58
177	27	39
178	8	74
179	14	74
180	21	74
181	10	74
182	31	74
183	29	23
184	29	25
185	30	40
186	9	40
187	13	40
188	13	41
189	6	89
190	6	34
191	21	28
192	6	33
193	27	26
194	21	53
195	25	80
196	25	81
197	25	8
198	25	9
199	21	26
200	8	26
201	10	26
202	31	26
203	32	26
204	21	79
205	8	75
206	21	75
207	10	75
208	31	75
209	23	53
210	32	39
211	27	38
212	8	13
213	21	13
214	10	13
215	31	13
216	27	13
217	8	12
218	21	12
219	10	12
220	31	12
221	27	12
222	8	20
223	21	20
224	10	20
225	31	20
226	27	20
227	21	15
228	21	14
229	21	18
230	27	18
231	9	18
232	30	18
233	2	41
234	2	92
235	2	84
236	2	74
237	2	6
238	13	92
239	9	92
240	30	92
241	13	26
242	9	26
243	30	26
244	14	13
245	13	18
246	9	93
247	30	93
248	13	93
249	9	13
250	30	13
251	13	13
252	18	40
253	24	6
254	18	6
255	21	39
256	32	36
257	32	83
258	32	85
259	18	70
260	24	70
261	21	95
262	30	70
263	9	70
264	8	94
265	18	94
266	24	94
267	10	94
268	31	94
269	8	22
270	24	22
271	21	22
272	21	54
273	10	22
274	31	22
275	32	89
276	11	70
277	18	53
278	24	53
279	10	53
280	31	53
281	27	96
282	8	89
283	18	89
284	24	89
285	18	84
286	18	59
287	24	59
288	27	59
289	21	65
290	21	60
291	8	60
292	18	60
293	24	60
294	10	60
295	31	60
296	27	60
297	3	92
298	3	23
299	4	92
300	4	23
301	5	40
302	21	97
303	9	47
304	30	47
305	8	48
306	10	48
307	31	48
308	9	48
309	30	48
310	21	98
311	21	49
312	27	98
313	27	51
314	21	50
315	27	50
316	9	50
317	30	50
318	27	10
319	9	8
320	30	8
\.


--
-- Data for Name: barvy; Type: TABLE DATA; Schema: public; Owner: doctordehi
--

COPY public.barvy (id_bar, nazev) FROM stdin;
1	andalužští
2	barvy poštovní řady
3	červeně popelaví
4	žlutě popelaví
5	skřivánčí
6	bílí
7	bílí bělouši
8	černí
9	červeně plaví
10	červení
11	stříbřitě červeně popelaví
12	hermelíni
13	hnědě plaví
14	hnědí
15	hnědožlutí
16	indigo
17	izabeloví
18	kaštanově hnědí
19	mandloví
20	modře plaví
21	modří
22	modří bělouši
23	popelavě šedí
24	šedohnědí
25	siví
26	stříbřitě plaví
27	stříbřití
28	stříbrní
29	světle modří
30	žlutě plaví
31	žlutí
32	plaví
\.


--
-- Data for Name: kresby; Type: TABLE DATA; Schema: public; Owner: doctordehi
--

COPY public.kresby (id_kre, nazev) FROM stdin;
1	černoocasí
2	červenoocasí
3	hnědoocasí
4	stříbrnoocasí
5	žlutoocasí
6	bělohrotí
7	bělohrotí černopruzí
8	bělohrotí kapratí
9	bělohrotí pruhoví
10	bělohrotí tmavopruzí
11	běloocasí
12	běloocasí bělopruzí
13	běloocasí bezpruzí
14	běloocasí bronzovopruzí
15	běloocasí černopruzí
16	běloocasí červenopruzí
17	běloocasí hnědě kapratí
18	běloocasí kapratí
19	běloocasí modře kapratí
20	běloocasí šupinatí
21	běloocasí žlutopruzí
22	běloprsí vlaštováci
23	bělopruzí
24	běloštítní
25	bělošupkatí
26	bezpruzí
27	bronzoví
28	bronzovopruzí
29	čapíci
30	čápkové
31	čápkové bělopruzí
32	čápkové černopruzí
33	černohrotí
34	černopruzí
35	červenopruzí
36	bělouši černopruzí
37	hermelínoví
38	hnědě kapratí
39	bělohrotí
40	jednobarevní
41	kapratí
42	kapratí bělopruzí
43	kapratí černopruzí
44	lysí
45	lysí bělopruzí
46	lysí červenopruzí
47	lysí kapratí
48	mniši
49	mniši černopruzí
50	mniši kapratí
51	mniši tmavopruzí
52	modře kapratí
53	mramorovaní
54	mramorovaní běloprsí vlaštováci
55	pigři
56	plamínci
57	plaví
58	plnobarevní
59	pštrosíci
60	pštrosíci běloocasí
61	pštrosíci bělopruzí
62	pštrosíci černopruzí
63	pštrosíci červenopruzí
64	pštrosíci kapratí
65	pštrosíci mramorovaní
66	pštrosíci šupinatí
67	pštrosíci šupkatí
68	pštrosíci žlutopruzí
69	s anglickou kresbou
70	sedlatí
71	sedlatí kapratí
72	s anglickou kresbou
73	šedohnědopruzí
74	straky
75	stříkaní
76	šupinatí
77	šupinatí štítníci
78	šupkatí
79	černě kapratí
80	tmavohrotí kapratí
81	tmavohrotí pruhoví
82	tmavopruzí
83	bělouši červenopruzí
84	tygři
85	bělouši žlutopruzí
86	žlutopruzí
87	lysí černopruzí
88	modroocasí
89	bělouši
90	žlutopruzí s anglickou kresbou
91	červenopruzí s anglickou kresbou
92	pruhoví
93	běloocasí pruhoví
94	tygříci
95	šupinatí sedlatí
96	hnědopruzí mramorovaní
97	lysí bezpruzí
98	mniši bezpruzí
\.


--
-- Data for Name: mista_puvodu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mista_puvodu (id_mis, nazev) FROM stdin;
1	Benešov a okolí
2	Morava
3	Jižní Čechy
4	Slezsko
5	Východní Čechy
6	Jižní Morava
7	Ostrava a okolí
8	Čechy a Morava
9	Čechy
10	Česká Republika
11	Haná, Morava
12	Praha a okolí
13	Rakovník a okolí
\.


--
-- Data for Name: plemena; Type: TABLE DATA; Schema: public; Owner: doctordehi
--

COPY public.plemena (id_ple, nazev, sk_nazev, de_nazev, uk_nazev, skupina, velikost, misto_puvodu, krouzek, strucny_popis) FROM stdin;
1	Benešovský holub	Benešovský holub	Beneschauer Taube	Benesov Pigeon	1	2	1	10	Holub polního typu, silné tělesné stavby. Tělo je neseno v mírném sklonu nazad. Vyniká užitkovostí, dobrámi letovými schopnostmi, včetně polaření. Původně s vyskytoval jen v rázu modrém bezpruhém. Cílem je rozšíření počtu barevných a kresebných rázů při zachování původního typu a užitkových vlastností.
2	Brněnský voláč	Brnenský hrvoliak	Brünner Kröpfer	Bruenner Cropper	4	1	8	7	Zakrslý, vysokonohý voláč, vynikajících jemných tělesných tvarů s velmi vzpřímenou a štíhlou postavou. Ušlechtilý dojem dotváří kulaté podvázené vole a znatelná hrudní kost. Typickým plemenným znakem jsou vysoko nesená a křížící se křídla. K původním znakům patří i jeho typické životní projevy: temperament, žabí skoky samců, našlapování na přední část prstů a úklony při vrkání, tleskání křídly a zvláštní způsob vrkání, jako by ze sevřeného hrdla. Oblíben je i pro krotkost, důvěřivost a přítulnost k chovateli. Patří k plemenům s vysokou výstavní hodnotou.
3	Česká bagdeta	Česká bagdeta	Tschechische Bagdette	Czech Bagdad	2	2	5	9	Poměrně silný holub, střední velikosti, s dobrými letovými schopnostmi, původně polařící, s cennými znaky hlavy, zobáku a obočnic, které jej přiřazují mezi plemena bradavičnatá. Vyniká i řadou barevných a kresebných rázů.
4	Česká čejka	Český cíbik	Böhmische Flügeltaube	Bohemian Wing Pigeon	5	2	3	11	Typ středně silného polního holuba, kratšího tvaru, s nízkým a širokým postojem v mírném sklonu nazad, dobře vyvinutých pernatých ozdob (hladkonozí, rousní, hladkohlaví, chocholatí), přesné kresby a syté barvy.
5	Česká lyska běloocasá	Česká lyska bielochvostá	Böhmische Schnippe weisschwanzig	Czech spot Whitetail	5	2	9	11	Velikostí a celkovým dojmem připomíná středné silného polního holuba s bílou čelní lysinkou a bílým ocasem a charakteristickými barevnými a kresebnými kombinacemi.
6	Český bublák	Český bublák	Tschechische Trommeltaube	Czech Trumpeter	6	2	10	12	Holub patřící do skupiny bubláků, vyznačuje se zvláštním hlasovým projevem – bubláním, které je nejcennějším plemenným znakem. Bublání nesmí být monotónní, musí se střídat vyšší tóny s hlubšími, musí být výrazné a dobře slyšitelné a čím déle trvá, tím je holub cennější. Holubice bublají v kratších intervalech a ve vyšším tónu. Typickým dokonalým znakem je dokonalost postavy, je kompaktní, nízká, široká a krátka, v průhledu ze předu musí být prostor mezi břichem, nohama a rousem zcela zaplněn. Dalším znakem je jakoby slité a přilehlé opeření a husté, velmi vyvinuté rousy, supí pera a vrkoče.
7	Český holub	Český holub	Böhmentaube	Bohemian Pigeon	5	2	9	8	Silnější polní holub s vodorovným tělem, středně vysokého postoje, hladkonohý a hladkohlavý, dobře létající.
8	Český rejdič	Český letún	Tschechischer Tümmler	Czech Tumbler	9	1	12	8	Je cenným plemenem rejdiče pro dobré letové schopnosti v hejnu po dobu 1-2 hodin a pro hodnotný okrasný exteriér. Charakterizuje jej jemná střední postava, lasturovitá chocholka a opeřené nohy s krátkými rousky.
9	Český stavák	Český stavák	Tschechischer Stellerkröpfer	Czech Steller Cropper	4	2	9	8	Temperamentní, menší střední voláč, méně vzpřímeného držení těla (pod úhlem menším než 45°). Vole hruškovité. Výjimečně lesklé barvy opeření. Jedním z hlavních plemenných znaků je typický let, při němž holub tleská křídly a, postaví-li je při letu vysoko nad sebe, padá.
10	Český voláč sivý	Český sivý hrvoliak	Tschechischer Eiskröpfer	Czech Ice Cropper	4	2	10	8	Voláč střední velikosti se silnější, mírně vztyčenou postavou a dobrou volatostí. Vyniká typickým sivým zbarvením s černými pruhy nebo kaprováním štítů křídel.
11	Hanácký voláč	Hanácký hrvoliak	Hana Kröpfer	Hana Pouter	4	3	11	11	Statný, dobře volatý, vysokonohý a rousný voláč s pštrosí kresbou. Požadavky na dokonalost tělesných tvarů jsou vysoké. Barva, lesk a svit nejsou podstatné.
12	Moravská bagdeta	Moravská bagdeta	Mährische Bagdette	Morovia Bagdad	2	2	6	10	Holub silné tělesné stavby a většího rámce. Vyniká užitkovostí, postavou, tvarem hlavy, špičatou chocholkou a výraznými obočnicemi.
13	Moravský bělohlávek	Moravský bielohlávok	Mährischer Weißkopfkröpfer	Bohemian Cropper	4	2	2	9	Holub ze skupiny středních voláčů, vyšší a vzpřímené postavy, se silnější stavbou těla a dobrou volatostí. Hlava je zdobena špičatou chocholkou.
14	Moravský morák	Moravský morák	Mährischer Morak	Moravian Morak Cropper	4	2	2	9	Voláč ze skupiny středních voláčů. Velikostí se řadí mezi největší plemena ve skupině. Vyniká silnou postavou většího tělesného rámce a velmi dobrým voletem hruškovitého tvaru, vitalitou a plodností. Je zvláštní tím, že se vyskytuje jen v jedinem barevném a kresebném rázu.
15	Moravský pštros	Moravský pštros	Mährischer Strasser	Moravian Strasser	1	2	2	9	Původně užitkové plemeno střední velikosti polního typu s typickou pštrosí kresbou. Vysoce prošlechtěných barev a lesků. V současnosti má též znaky holuba vynikajícich tvarů s přiměřenou hmotností.
16	Moravský voláč sedlatý	Moravský hrvoliak sedlatý 	Mährischer Elsterkröpfer	Moravian Magpie Cropper	4	2	2	9	Holub ze skupiny středních voláčů, vysoké a vzpřímené postavy, vyskytující se jen v sedlatém rázu. Hlava je zdobena špičatou chocholkou. Vyniká vitalitou a plodností.
17	Ostravská bagdeta	Ostravská bagdeta	Ostrauer Bagdette	Ostrava Bagdad	2	2	7	9	Holub silné tělesné stavby, vzpřímený, na vyšších nohách. Typickým znakem plemena je křivka krku ve tvaru písmene S, kterou tvoří profil hlavy se zobákem, dozadu prohnutý týl a vpředu vystupující krční obratle a nasazení krku ke hrudi. Dále je charakteristický dobře znatelný lalůček na spodní straně krku, a na horní části hrudi na obě strany kolmo rozčísnutá náprsenka.
18	Prácheňský káník	Prachenský kaník	Prachener Kanik	Prachen Kanik	1	2	3	8	Temperamentní, velmi plodný holub s výbornými letovými schopnostmi, včetně polaření. Původně užitkové plemeno lehčího polního typu, v současnosti plemeno s vysokou výstavní a chovatelskou hodnotou. Má kompaktní jemnou tělesnou stavbu, vyniká pěknou bělohrotou gazzi kresbou a jemnými a čistými barvami.
19	Pražský rejdič krátkozobý	Pražský krátkozobý letún	Prager Tümmler	Prague Short Faced Tumbler	9	1	12	7	Původní plemenné znaky byly hlavně výborné letové schopnosti v hejnech, včetně letu výškového a vytrvalostního, doprovázeného prudkými obraty (překládáním). V současnosti vyniká především tvarovými znaky hlavy, krátkozobostí, malou a jemnou postavou a množstvím barevných a kresebných rázů.
20	Pražský rejdič středozobý	Pražský stredozobý letún	Prager mittelschnabliger Tümmler	Prague Tumbler	9	1	12	7	Rejdič se schopností středně vysokého letu po dobu až 2 hodin do vzdálenosti až 10 km, který je doprovázen prudkými obraty (překládáním). Má jemnou postavu připomínající dobrého letouna. Požadavky na tvar hlavy jsou méně náročné. Je podobný pražskému rejdiči krátkozobému, od něhož má i svůj původ a shoduje s s ním v barevných a kresebných rázech. Je poměrně plodný a dobře odchovává mladé.
21	Rakovnický kotrlák	Rakovnícky kotrmeliak	Rakovnik Roller	Rakovnik Roller	9	1	13	7	Drobný a jemný holub, který vyniká temperamentem a přeevším zvláštním způsobem letu – válením, které probíhá za letu tak, že se holub v přemetech otáčí nazad. Čím více přemetů udělá, tím je chovná hodnota větší. Nejcennější holubi válejí i nízko nad zemí nebo nad hřebenem střechy. Vynika rozmanitými barevnými a kresebnými rázy.
22	Slezský barevnohlávek	Sliezsky farebnohlávok	Schlesischer Farbenkopf	Silesian Colourhead	1	2	4	9	Holub středního užitkového typu, vynikajících letových vlastností včetně polaření. Jeho užitkovost vyplývá z nenáročnosti a značné otužilosti. Mimoto je i ceněným plemenem okrasným a výstavním.
23	Slezský voláč	Sliezsky hrvoliak	Schlesischer Kröpfer	Silesian Cropper	4	2	4	8	Štíhlý, harmonický, elegantní, ale přesto silný voláč s velmi dobrou volatostí hruškovitého tvaru, zadní partie kratší (2/5) vztyčeného postoje, mírně duté linie zad, živého temperamentu.
\.


--
-- Data for Name: plemena_razy; Type: TABLE DATA; Schema: public; Owner: doctordehi
--

COPY public.plemena_razy (ple, raz) FROM stdin;
9	1
9	2
9	3
9	4
9	5
9	6
9	7
9	8
9	9
9	10
9	11
9	12
9	13
9	14
9	15
9	16
9	17
9	18
9	19
9	20
9	21
9	22
9	23
9	24
9	25
9	26
9	27
9	28
9	29
9	30
9	31
9	32
9	33
9	34
9	35
9	36
9	37
9	38
9	39
9	40
9	41
9	42
9	43
9	44
9	45
9	46
9	47
9	48
9	49
9	50
9	51
9	52
9	53
9	54
9	55
9	56
9	57
9	58
9	59
9	60
9	61
9	62
9	63
9	64
9	65
9	66
9	67
9	68
9	69
9	70
9	71
9	72
9	73
9	74
9	75
9	76
9	77
9	78
9	79
9	80
9	81
9	82
9	83
9	84
9	85
9	86
9	87
9	88
9	89
1	90
1	91
1	92
1	93
1	94
1	95
1	96
1	97
1	98
1	99
1	76
1	77
1	78
1	79
2	90
2	91
2	92
2	93
2	94
2	100
2	101
2	102
2	103
2	11
2	104
2	105
2	10
2	106
2	107
2	46
2	47
2	48
2	49
2	50
2	108
2	109
2	110
2	111
2	112
2	113
2	32
2	33
2	34
2	114
2	67
2	68
2	69
2	70
2	115
2	116
2	117
2	118
2	119
2	120
2	121
2	122
2	123
2	124
2	125
2	126
2	127
2	128
2	129
2	130
2	131
2	132
2	133
2	134
2	135
2	136
2	137
2	138
2	139
2	140
2	141
2	76
2	77
2	78
2	79
2	73
2	142
2	143
3	90
3	91
3	92
3	93
3	94
3	101
3	145
3	146
3	10
3	11
3	147
3	148
3	149
3	150
3	151
3	152
3	153
3	154
3	155
3	156
3	157
3	158
3	159
3	160
3	161
3	162
3	163
3	164
3	165
3	46
3	47
3	48
3	49
4	10
4	166
4	11
4	12
4	47
4	110
4	46
4	48
4	49
4	168
4	169
4	170
4	171
4	172
5	11
5	12
5	10
5	166
5	32
5	33
5	34
5	35
5	112
5	168
5	169
5	170
5	171
5	172
5	173
5	174
6	1
6	2
6	3
6	4
6	5
6	6
6	7
6	175
6	176
6	11
6	104
6	105
6	12
6	10
6	177
6	107
6	111
6	46
6	47
6	48
6	49
6	168
6	169
6	170
6	171
6	172
6	76
6	77
6	78
6	79
6	178
6	179
6	180
6	181
6	182
6	80
6	81
6	82
6	83
7	91
7	92
7	93
7	94
7	95
7	101
7	183
7	184
7	185
7	186
7	187
7	10
7	11
7	12
7	104
7	105
7	188
8	10
8	11
8	95
8	185
8	186
8	189
8	190
8	89
8	192
8	88
8	194
10	195
10	196
10	197
10	198
11	199
11	200
11	201
11	202
11	203
11	204
11	104
11	105
11	12
11	10
11	106
11	88
11	89
11	167
11	46
11	47
11	48
11	49
11	158
11	161
11	162
11	163
12	90
12	91
12	93
12	94
12	11
12	104
12	105
12	10
12	107
12	111
12	205
12	206
12	207
12	208
12	178
12	180
12	181
12	182
12	76
12	77
12	78
12	79
13	91
13	92
13	93
13	94
13	95
13	104
13	105
13	11
13	12
13	10
13	106
13	107
13	111
13	110
13	46
13	47
13	48
13	49
13	76
13	78
13	79
14	209
15	199
15	200
15	201
15	202
15	193
15	46
15	47
15	48
15	110
15	158
15	161
15	162
15	163
15	144
15	10
15	167
15	191
15	204
15	211
15	104
15	105
15	212
15	213
15	214
15	215
15	216
15	217
15	218
15	219
15	220
15	221
15	222
15	223
15	224
15	225
15	226
15	227
15	228
15	229
15	230
15	231
15	232
16	67
16	68
16	69
16	70
16	71
17	233
17	234
17	235
17	236
17	237
18	2
18	3
18	4
18	176
18	199
18	10
18	11
18	170
18	188
18	104
18	105
18	238
18	239
18	240
18	241
18	242
18	243
18	46
18	47
18	48
18	49
18	164
18	212
18	213
18	214
18	215
18	244
18	218
18	231
18	232
18	245
18	246
18	247
18	248
18	249
18	250
18	251
19	90
19	91
19	92
19	93
19	94
19	145
19	252
19	32
19	33
19	34
19	112
19	253
19	254
19	46
19	47
19	48
19	49
19	50
19	110
19	165
19	10
19	177
19	255
19	111
19	107
19	256
19	257
19	258
19	67
19	68
19	69
19	70
19	71
19	259
19	260
19	261
19	262
19	263
19	264
19	265
19	266
19	267
19	268
19	269
19	270
19	271
19	272
19	273
19	274
19	275
20	90
20	91
20	92
20	93
20	94
20	145
20	252
20	32
20	33
20	34
20	112
20	253
20	254
20	46
20	47
20	48
20	49
20	50
20	110
20	165
20	10
20	177
20	255
20	111
20	107
20	256
20	257
20	258
20	67
20	68
20	69
20	70
20	71
20	259
20	260
20	261
20	262
20	263
20	264
20	265
20	266
20	267
20	268
20	269
20	270
20	271
20	272
20	273
20	274
20	275
21	90
21	91
21	92
21	93
21	94
21	95
21	145
21	252
21	55
21	56
21	57
21	58
21	59
21	60
21	253
21	254
21	112
21	32
21	33
21	34
21	35
21	10
21	177
21	239
21	240
21	276
21	67
21	68
21	69
21	70
21	71
21	72
21	259
21	260
21	11
21	12
21	13
21	14
21	174
21	194
21	277
21	278
21	279
21	280
21	281
21	73
21	142
21	143
21	282
21	283
21	284
21	76
21	77
21	78
21	79
21	98
21	285
21	115
21	116
21	117
21	118
21	286
21	287
21	288
21	127
21	128
21	129
21	130
21	119
21	120
21	289
21	290
21	291
21	292
21	293
21	294
21	295
21	296
22	91
22	92
22	93
22	94
23	142
23	143
23	73
23	90
23	91
23	93
23	94
23	10
23	199
23	106
23	193
23	185
23	186
23	297
23	298
23	299
23	300
23	301
23	11
23	12
23	104
23	105
23	88
23	89
23	178
23	180
23	181
23	182
23	17
23	18
23	19
23	53
23	302
23	21
23	22
23	27
23	303
23	304
23	46
23	47
23	48
23	49
23	305
23	306
23	307
23	308
23	309
23	310
23	311
23	312
23	313
23	314
23	315
23	316
23	317
23	32
23	33
23	34
23	40
23	112
23	35
23	36
23	37
23	41
23	42
23	318
23	319
23	320
\.


--
-- Data for Name: skupiny; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skupiny (id_sku, nazev) FROM stdin;
1	Holubi tvaru
2	Holubi bradavičnatí
3	Holubi slepičky
4	Holubi voláči
5	Holubi barevní
6	Holubi bubláci
7	Holubi strukturoví
8	Holubi rackové
9	Holubi rejdiči
10	Holubi hraví letem
\.


--
-- Data for Name: velikosti; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.velikosti (id_vel, nazev) FROM stdin;
1	malí
2	střední
3	velcí
\.


--
-- Name: barevne_razy_id_raz_seq; Type: SEQUENCE SET; Schema: public; Owner: doctordehi
--

SELECT pg_catalog.setval('public.barevne_razy_id_raz_seq', 1, false);


--
-- Name: barvy_id_bar_seq; Type: SEQUENCE SET; Schema: public; Owner: doctordehi
--

SELECT pg_catalog.setval('public.barvy_id_bar_seq', 1, false);


--
-- Name: kresby_id_kre_seq; Type: SEQUENCE SET; Schema: public; Owner: doctordehi
--

SELECT pg_catalog.setval('public.kresby_id_kre_seq', 1, false);


--
-- Name: mista_puvodu_id_mis_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mista_puvodu_id_mis_seq', 1, false);


--
-- Name: plemena_id_ple_seq; Type: SEQUENCE SET; Schema: public; Owner: doctordehi
--

SELECT pg_catalog.setval('public.plemena_id_ple_seq', 1, false);


--
-- Name: skupiny_id_sku_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skupiny_id_sku_seq', 1, false);


--
-- Name: velikosti_id_vel_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.velikosti_id_vel_seq', 1, false);


--
-- Name: barevne_razy barevne_razy_pkey; Type: CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barevne_razy
    ADD CONSTRAINT barevne_razy_pkey PRIMARY KEY (id_raz);


--
-- Name: barvy barvy_pkey; Type: CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barvy
    ADD CONSTRAINT barvy_pkey PRIMARY KEY (id_bar);


--
-- Name: kresby kresby_pkey; Type: CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.kresby
    ADD CONSTRAINT kresby_pkey PRIMARY KEY (id_kre);


--
-- Name: mista_puvodu mista_puvodu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mista_puvodu
    ADD CONSTRAINT mista_puvodu_pkey PRIMARY KEY (id_mis);


--
-- Name: plemena plemena_pkey; Type: CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena
    ADD CONSTRAINT plemena_pkey PRIMARY KEY (id_ple);


--
-- Name: skupiny skupiny_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skupiny
    ADD CONSTRAINT skupiny_pkey PRIMARY KEY (id_sku);


--
-- Name: velikosti velikosti_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.velikosti
    ADD CONSTRAINT velikosti_pkey PRIMARY KEY (id_vel);


--
-- Name: barevne_razy barva_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barevne_razy
    ADD CONSTRAINT barva_fk FOREIGN KEY (bar) REFERENCES public.barvy(id_bar) ON DELETE CASCADE;


--
-- Name: barevne_razy kresba_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.barevne_razy
    ADD CONSTRAINT kresba_fk FOREIGN KEY (kre) REFERENCES public.kresby(id_kre) ON DELETE CASCADE;


--
-- Name: plemena misto_puvodu_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena
    ADD CONSTRAINT misto_puvodu_fk FOREIGN KEY (misto_puvodu) REFERENCES public.mista_puvodu(id_mis) ON DELETE CASCADE;


--
-- Name: plemena_razy plemeno_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena_razy
    ADD CONSTRAINT plemeno_fk FOREIGN KEY (ple) REFERENCES public.plemena(id_ple) ON DELETE CASCADE;


--
-- Name: plemena_razy raz_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena_razy
    ADD CONSTRAINT raz_fk FOREIGN KEY (raz) REFERENCES public.barevne_razy(id_raz) ON DELETE CASCADE;


--
-- Name: plemena skupina_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena
    ADD CONSTRAINT skupina_fk FOREIGN KEY (skupina) REFERENCES public.skupiny(id_sku) ON DELETE CASCADE;


--
-- Name: plemena velikost_fk; Type: FK CONSTRAINT; Schema: public; Owner: doctordehi
--

ALTER TABLE ONLY public.plemena
    ADD CONSTRAINT velikost_fk FOREIGN KEY (velikost) REFERENCES public.velikosti(id_vel) ON DELETE CASCADE;


--
-- Name: TABLE mista_puvodu; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.mista_puvodu TO doctordehi;


--
-- Name: TABLE skupiny; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.skupiny TO doctordehi;


--
-- Name: TABLE velikosti; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.velikosti TO doctordehi;


--
-- PostgreSQL database dump complete
--

