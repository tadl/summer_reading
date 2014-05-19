--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    provider character varying(255),
    uid character varying(255),
    name character varying(255),
    oauth_token character varying(255),
    oauth_expires_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar character varying(255),
    email character varying(255),
    role character varying(255) DEFAULT 'unapproved'::character varying
);


ALTER TABLE public.admins OWNER TO uogqdzgirimytp;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: uogqdzgirimytp
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO uogqdzgirimytp;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uogqdzgirimytp
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: awards; Type: TABLE; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE TABLE awards (
    id integer NOT NULL,
    notes text,
    participant_id integer,
    experience_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.awards OWNER TO uogqdzgirimytp;

--
-- Name: awards_id_seq; Type: SEQUENCE; Schema: public; Owner: uogqdzgirimytp
--

CREATE SEQUENCE awards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.awards_id_seq OWNER TO uogqdzgirimytp;

--
-- Name: awards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uogqdzgirimytp
--

ALTER SEQUENCE awards_id_seq OWNED BY awards.id;


--
-- Name: experiences; Type: TABLE; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE TABLE experiences (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image_url character varying(255)
);


ALTER TABLE public.experiences OWNER TO uogqdzgirimytp;

--
-- Name: experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: uogqdzgirimytp
--

CREATE SEQUENCE experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.experiences_id_seq OWNER TO uogqdzgirimytp;

--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uogqdzgirimytp
--

ALTER SEQUENCE experiences_id_seq OWNED BY experiences.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE TABLE participants (
    id integer NOT NULL,
    first_name character varying(255),
    middle_name character varying(255),
    last_name character varying(255),
    library_card character varying(255),
    email character varying(255),
    zip_code integer,
    home_library character varying(255),
    school character varying(255),
    grade character varying(255),
    club character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    birth_date date DEFAULT '2011-01-01'::date,
    got_reading_kit boolean DEFAULT false,
    got_final_prize boolean DEFAULT false
);


ALTER TABLE public.participants OWNER TO uogqdzgirimytp;

--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: uogqdzgirimytp
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participants_id_seq OWNER TO uogqdzgirimytp;

--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: uogqdzgirimytp
--

ALTER SEQUENCE participants_id_seq OWNED BY participants.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO uogqdzgirimytp;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: uogqdzgirimytp
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: uogqdzgirimytp
--

ALTER TABLE ONLY awards ALTER COLUMN id SET DEFAULT nextval('awards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: uogqdzgirimytp
--

ALTER TABLE ONLY experiences ALTER COLUMN id SET DEFAULT nextval('experiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: uogqdzgirimytp
--

ALTER TABLE ONLY participants ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: uogqdzgirimytp
--

COPY admins (id, provider, uid, name, oauth_token, oauth_expires_at, created_at, updated_at, avatar, email, role) FROM stdin;
4	google_oauth2	100200591497740771890	Kristen Talaga	ya29.1.AADtN_VrA37nYFqG66VJbUJlg6fECA2iztdj45EO1yhPmdhSkOjBKHBy62XKfQ	2014-04-22 16:22:22	2014-04-22 15:22:22.384536	2014-04-23 02:48:24.092195	https://lh6.googleusercontent.com/-hWrFesEsw2U/AAAAAAAAAAI/AAAAAAAAAEA/NKskTgF16t0/photo.jpg	ktalaga@tadl.org	approved
3	google_oauth2	102562383111025221504	Cathy Lancaster	ya29.1.AADtN_XeVnKZqH0J2SqVnIlRS1EumMVSMutxQnq0GPNZ0J_BUzeszTQNdZ1kAbzghm24Gw	2014-04-22 16:17:49	2014-04-22 15:17:49.60697	2014-04-22 18:49:10.96345	https://lh4.googleusercontent.com/-5QoSN3ddqbw/AAAAAAAAAAI/AAAAAAAAAAw/hsUNuDh8XRU/photo.jpg	clancaster@tadl.org	approved
5	google_oauth2	101891594540430926207	Jeff Godin	ya29.1.AADtN_XDrngICeywHFdfdOT-NWLRKN7DXDE_OC-M8boReBoiKDkoLbnNqxA9Y_U	2014-04-22 16:37:09	2014-04-22 15:36:54.339198	2014-04-29 15:53:32.447669	https://lh4.googleusercontent.com/-QI9ozaXWBAg/AAAAAAAAAAI/AAAAAAAAAKA/mubozbSX2y4/photo.jpg	jgodin@tadl.org	approved
2	google_oauth2	113992574853262146342	William Rockwood	ya29.1.AADtN_U3Jq3D6zXhGNys_SCSIWx3c5mzJ4M_j9geMvHdqAMIptG3L_23aRj9LBs	2014-04-22 16:16:14	2014-04-22 15:16:14.306401	2014-04-29 15:53:34.434975	https://lh3.googleusercontent.com/-LLOfwtu0jb0/AAAAAAAAAAI/AAAAAAAAALM/JSDRIcwblWo/photo.jpg	wrockwood@tadl.org	approved
8	google_oauth2	118029813601507560474	Scott Morey	ya29.1.AADtN_W5udeljcM7u23VgndqKS472tYKjmLdwZbQjz7CU9dra_nZSiNBvGnVSnVeO3AGzQ	2014-05-02 17:34:46	2014-05-02 16:34:47.299029	2014-05-02 16:42:50.335219	https://lh5.googleusercontent.com/-yzo4QGYPt4I/AAAAAAAAAAI/AAAAAAAAAG0/fkYKSqYxpMI/photo.jpg?sz=50	smorey@tadl.org	approved
9	google_oauth2	103787809212643398582	Ed Barrett	ya29.GwCkqMLG6aJ5Vx4AAAC9Ox3sDCKtyW4o5fDXtfmeDyvfo1G8wXQqECZsi9yk7A	2014-05-19 18:47:27	2014-05-19 17:47:28.167378	2014-05-19 17:47:59.926943	https://lh6.googleusercontent.com/-p_kUCMu67Lk/AAAAAAAAAAI/AAAAAAAAACY/xF6rWWQ2uuM/photo.jpg?sz=50	ebarrett@tadl.org	approved
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: uogqdzgirimytp
--

SELECT pg_catalog.setval('admins_id_seq', 9, true);


--
-- Data for Name: awards; Type: TABLE DATA; Schema: public; Owner: uogqdzgirimytp
--

COPY awards (id, notes, participant_id, experience_id, created_at, updated_at) FROM stdin;
6	\N	4	6	2014-04-24 19:57:01.215773	2014-04-24 19:57:01.215773
7	\N	\N	\N	2014-04-28 18:34:15.766529	2014-04-28 18:34:15.766529
8	\N	\N	\N	2014-04-28 18:34:18.908984	2014-04-28 18:34:18.908984
9	\N	3	5	2014-04-28 18:36:23.689595	2014-04-28 18:36:23.689595
10	\N	3	7	2014-04-28 18:36:27.943174	2014-04-28 18:36:27.943174
11	\N	3	12	2014-04-28 18:36:32.623498	2014-04-28 18:36:32.623498
12	\N	5	8	2014-04-28 18:36:37.689777	2014-04-28 18:36:37.689777
13	\N	4	7	2014-04-28 19:01:48.343136	2014-04-28 19:01:48.343136
14	\N	6	3	2014-04-28 20:14:37.469446	2014-04-28 20:14:37.469446
15	\N	7	8	2014-04-28 21:01:22.970483	2014-04-28 21:01:22.970483
16	\N	3	3	2014-04-28 21:05:40.980957	2014-04-28 21:05:40.980957
17	\N	3	4	2014-04-28 21:05:50.402361	2014-04-28 21:05:50.402361
18	\N	8	8	2014-04-29 17:21:31.801919	2014-04-29 17:21:31.801919
19	\N	3	10	2014-04-29 17:44:39.870203	2014-04-29 17:44:39.870203
20	\N	3	8	2014-04-29 17:44:43.939416	2014-04-29 17:44:43.939416
21	\N	4	5	2014-04-29 22:51:42.783166	2014-04-29 22:51:42.783166
22	\N	8	12	2014-04-29 22:57:01.788627	2014-04-29 22:57:01.788627
23	\N	4	8	2014-04-29 23:45:32.94038	2014-04-29 23:45:32.94038
24	\N	7	12	2014-04-30 15:47:18.864207	2014-04-30 15:47:18.864207
25	\N	8	5	2014-04-30 15:47:28.382551	2014-04-30 15:47:28.382551
26	\N	3	1	2014-04-30 17:28:34.760123	2014-04-30 17:28:34.760123
27	\N	8	9	2014-04-30 19:56:11.796878	2014-04-30 19:56:11.796878
28	\N	7	9	2014-05-01 06:01:57.80663	2014-05-01 06:01:57.80663
29	\N	6	8	2014-05-01 06:02:08.413056	2014-05-01 06:02:08.413056
30	\N	5	9	2014-05-01 06:04:04.55668	2014-05-01 06:04:04.55668
31	\N	6	5	2014-05-01 06:15:44.659354	2014-05-01 06:15:44.659354
32	\N	4	1	2014-05-02 16:55:26.255129	2014-05-02 16:55:26.255129
33	\N	9	5	2014-05-02 19:44:36.22079	2014-05-02 19:44:36.22079
34	\N	3	6	2014-05-02 19:50:01.108202	2014-05-02 19:50:01.108202
35	\N	10	5	2014-05-02 19:55:12.41028	2014-05-02 19:55:12.41028
36	\N	10	10	2014-05-02 19:55:16.712011	2014-05-02 19:55:16.712011
37	\N	9	8	2014-05-04 16:30:20.077343	2014-05-04 16:30:20.077343
38	\N	14	4	2014-05-08 21:55:11.953837	2014-05-08 21:55:11.953837
39	\N	14	12	2014-05-08 21:57:39.120682	2014-05-08 21:57:39.120682
40	\N	28	8	2014-05-13 15:43:44.374469	2014-05-13 15:43:44.374469
41	\N	14	8	2014-05-13 19:52:11.066335	2014-05-13 19:52:11.066335
42	\N	24	4	2014-05-13 19:52:22.894982	2014-05-13 19:52:22.894982
43	\N	28	5	2014-05-13 22:21:02.662899	2014-05-13 22:21:02.662899
44	\N	30	7	2014-05-13 22:27:30.286242	2014-05-13 22:27:30.286242
45	\N	30	12	2014-05-13 22:38:33.3085	2014-05-13 22:38:33.3085
46	\N	30	6	2014-05-13 22:38:37.124998	2014-05-13 22:38:37.124998
47	\N	30	8	2014-05-13 22:38:41.422416	2014-05-13 22:38:41.422416
48	\N	31	5	2014-05-14 05:55:35.311198	2014-05-14 05:55:35.311198
49	\N	30	10	2014-05-15 18:49:41.008846	2014-05-15 18:49:41.008846
50	\N	30	9	2014-05-15 18:51:25.357137	2014-05-15 18:51:25.357137
51	\N	31	9	2014-05-15 18:51:30.86233	2014-05-15 18:51:30.86233
52	\N	30	1	2014-05-15 19:11:26.261021	2014-05-15 19:11:26.261021
53	\N	30	5	2014-05-15 20:12:32.173094	2014-05-15 20:12:32.173094
54	\N	31	4	2014-05-15 20:12:37.191754	2014-05-15 20:12:37.191754
55	\N	31	1	2014-05-16 01:54:55.239546	2014-05-16 01:54:55.239546
56	\N	31	7	2014-05-16 11:33:47.059264	2014-05-16 11:33:47.059264
57	\N	31	11	2014-05-16 12:26:58.771434	2014-05-16 12:26:58.771434
58	\N	30	3	2014-05-16 16:36:28.415084	2014-05-16 16:36:28.415084
59	\N	32	7	2014-05-16 18:12:20.999776	2014-05-16 18:12:20.999776
60	\N	32	6	2014-05-16 18:12:30.875326	2014-05-16 18:12:30.875326
61	\N	32	3	2014-05-16 18:12:39.774121	2014-05-16 18:12:39.774121
62	\N	32	10	2014-05-17 13:55:59.910102	2014-05-17 13:55:59.910102
63	\N	32	5	2014-05-17 13:56:11.463638	2014-05-17 13:56:11.463638
64	\N	32	8	2014-05-17 13:56:17.245104	2014-05-17 13:56:17.245104
65	\N	35	8	2014-05-19 17:44:43.87276	2014-05-19 17:44:43.87276
66	\N	36	6	2014-05-19 17:44:47.732915	2014-05-19 17:44:47.732915
\.


--
-- Name: awards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: uogqdzgirimytp
--

SELECT pg_catalog.setval('awards_id_seq', 66, true);


--
-- Data for Name: experiences; Type: TABLE DATA; Schema: public; Owner: uogqdzgirimytp
--

COPY experiences (id, name, description, created_at, updated_at, image_url) FROM stdin;
1	TADL Expedition	Visit each location in the TADL system	2014-04-24 14:43:41.875316	2014-05-15 18:38:29.841541	https://s3.amazonaws.com/tadl-src-assets/badges/expedition.png
2	Adventurer	Read an adventure book and then do something dangerous	2014-04-24 14:44:11.461676	2014-05-15 18:39:41.526679	https://s3.amazonaws.com/tadl-src-assets/badges/adventurer.png
3	Animal Lover	Read a book about animals and then go live them in the woods.	2014-04-24 14:44:34.815886	2014-05-15 18:40:03.451662	https://s3.amazonaws.com/tadl-src-assets/badges/animal_lover.png
4	Artist	Read a book about painting and then paint something.	2014-04-24 14:45:26.738858	2014-05-15 18:40:21.631243	https://s3.amazonaws.com/tadl-src-assets/badges/artist.png
5	Dreamer	Read a fantasy book and then come to the sad realization that this world is not made for dreamers.	2014-04-24 14:46:07.226398	2014-05-15 18:40:40.336322	https://s3.amazonaws.com/tadl-src-assets/badges/dreamer.png
6	Star	Read a book about a celebrity and then become one.	2014-04-24 14:50:06.894976	2014-05-15 18:40:59.249149	https://s3.amazonaws.com/tadl-src-assets/badges/star.png
7	Fitness Guru	Read a book about exercise and then run a mile in 6 minutes or less.	2014-04-24 14:50:33.918563	2014-05-15 18:41:14.75999	https://s3.amazonaws.com/tadl-src-assets/badges/fit.png
8	Multicultural Explorer	Read a book about a different culture and then find a bunch of people that look different than you, circle them around a campfire, and sing Kumbaya.	2014-04-24 14:52:28.004283	2014-05-15 18:41:32.361551	https://s3.amazonaws.com/tadl-src-assets/badges/multicultural.png
9	Book Lover	Read all the book. Seriously.	2014-04-24 14:52:49.816479	2014-05-15 18:41:53.572191	https://s3.amazonaws.com/tadl-src-assets/badges/book_lover.png
10	Sports Fan	Read a book about a sport. If the sport you picked isn't basketball or football, you aren't very smart.	2014-04-24 14:53:27.988511	2014-05-15 18:42:11.03167	https://s3.amazonaws.com/tadl-src-assets/badges/sport_fan.png
11	Traveler	Read a book about travel and then hop on the first freight train you can find. Adventure awaits you!	2014-04-24 14:54:09.733106	2014-05-15 18:42:28.302033	https://s3.amazonaws.com/tadl-src-assets/badges/traveler.png
12	Music Lover	Check out a CD and then twerk all over the place.	2014-04-24 14:54:44.935623	2014-05-15 18:42:44.650225	https://s3.amazonaws.com/tadl-src-assets/badges/music_lover.png
\.


--
-- Name: experiences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: uogqdzgirimytp
--

SELECT pg_catalog.setval('experiences_id_seq', 12, true);


--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: uogqdzgirimytp
--

COPY participants (id, first_name, middle_name, last_name, library_card, email, zip_code, home_library, school, grade, club, created_at, updated_at, birth_date, got_reading_kit, got_final_prize) FROM stdin;
35	Penny	\N	May			49684	East Bay	undefined	undefined	baby	2014-05-19 17:11:20.988098	2014-05-19 17:11:20.988098	2012-05-22	f	f
36	Arlo	\N	Sans			49686	Kingsley	Kingsley Area Elementary	3	youth	2014-05-19 17:44:22.961528	2014-05-19 17:44:22.961528	2006-05-19	f	f
\.


--
-- Name: participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: uogqdzgirimytp
--

SELECT pg_catalog.setval('participants_id_seq', 36, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: uogqdzgirimytp
--

COPY schema_migrations (version) FROM stdin;
20140421170702
20140421181431
20140421202054
20140421210052
20140422152925
20140424183653
20140508212311
20140508214725
20140515163631
\.


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: awards_pkey; Type: CONSTRAINT; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

ALTER TABLE ONLY awards
    ADD CONSTRAINT awards_pkey PRIMARY KEY (id);


--
-- Name: experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

ALTER TABLE ONLY experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: participants_pkey; Type: CONSTRAINT; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: uogqdzgirimytp; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

