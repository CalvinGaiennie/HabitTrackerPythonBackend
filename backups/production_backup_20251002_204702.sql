--
-- PostgreSQL database dump
--

\restrict LUW4tUwD0wqOGN7ochfU3ZhiawBEf5cLHlapXGIJEJmjS687zLvQQ6dGhp0JTZK

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.6 (Homebrew)

-- Started on 2025-10-02 20:47:03 CDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.workout DROP CONSTRAINT workout_user_id_fkey;
ALTER TABLE ONLY public.set_entry DROP CONSTRAINT set_entry_workout_id_fkey;
ALTER TABLE ONLY public.set_entry DROP CONSTRAINT set_entry_exercise_id_fkey;
ALTER TABLE ONLY public.metrics DROP CONSTRAINT metrics_user_id_fkey;
ALTER TABLE ONLY public.metrics DROP CONSTRAINT metrics_parent_id_fkey;
ALTER TABLE ONLY public.metric_history DROP CONSTRAINT metric_history_user_id_fkey;
ALTER TABLE ONLY public.metric_history DROP CONSTRAINT metric_history_metric_id_fkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_user_id_fkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_metric_id_fkey;
ALTER TABLE ONLY public.goal_history DROP CONSTRAINT goal_history_goal_id_fkey;
ALTER TABLE ONLY public.goal_history DROP CONSTRAINT goal_history_changed_by_fkey;
ALTER TABLE ONLY public.food DROP CONSTRAINT food_user_id_fkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_user_id_fkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_food_id_fkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_user_id_fkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_user_id_fkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_metric_id_fkey;
ALTER TABLE ONLY public.workout DROP CONSTRAINT workout_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
ALTER TABLE ONLY public.set_entry DROP CONSTRAINT set_entry_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_filename_key;
ALTER TABLE ONLY public.metrics DROP CONSTRAINT metrics_pkey;
ALTER TABLE ONLY public.metric_history DROP CONSTRAINT metric_history_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.goal_history DROP CONSTRAINT goal_history_pkey;
ALTER TABLE ONLY public.food DROP CONSTRAINT food_pkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_user_id_food_id_log_date_created_at_key;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_pkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_pkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_name_key;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_pkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_metric_id_log_date_key;
ALTER TABLE public.workout ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.set_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.schema_migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.metrics ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.metric_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.goal_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.food_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.food ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.exercise ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.daily_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.workout_id_seq;
DROP TABLE public.workout;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.superset_seq;
DROP SEQUENCE public.set_entry_id_seq;
DROP TABLE public.set_entry;
DROP SEQUENCE public.schema_migrations_id_seq;
DROP TABLE public.schema_migrations;
DROP SEQUENCE public.metrics_id_seq;
DROP TABLE public.metrics;
DROP SEQUENCE public.metric_history_id_seq;
DROP TABLE public.metric_history;
DROP SEQUENCE public.goals_id_seq;
DROP TABLE public.goals;
DROP SEQUENCE public.goal_history_id_seq;
DROP TABLE public.goal_history;
DROP SEQUENCE public.food_id_seq;
DROP SEQUENCE public.food_entry_id_seq;
DROP TABLE public.food_entry;
DROP TABLE public.food;
DROP SEQUENCE public.exercise_id_seq;
DROP TABLE public.exercise;
DROP SEQUENCE public.daily_logs_id_seq;
DROP TABLE public.daily_logs;
-- *not* dropping schema, since initdb creates it
--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16511)
-- Name: daily_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_logs (
    id integer NOT NULL,
    user_id integer,
    metric_id integer NOT NULL,
    log_date date NOT NULL,
    value_int integer,
    value_boolean boolean,
    value_text text,
    value_decimal numeric(10,2),
    note text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16510)
-- Name: daily_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 229
-- Name: daily_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_logs_id_seq OWNED BY public.daily_logs.id;


--
-- TOC entry 222 (class 1259 OID 16433)
-- Name: exercise; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercise (
    id integer NOT NULL,
    user_id integer,
    name character varying(255) NOT NULL,
    description text,
    exercise_type character varying(255),
    exercise_subtype character varying(255),
    primary_muscles text[] NOT NULL,
    secondary_muscles text[],
    equipment character varying(255),
    equipment_modifiers text[],
    tags text[],
    injury_pain text
);


--
-- TOC entry 221 (class 1259 OID 16432)
-- Name: exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 221
-- Name: exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercise_id_seq OWNED BY public.exercise.id;


--
-- TOC entry 236 (class 1259 OID 16578)
-- Name: food; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.food (
    id integer NOT NULL,
    user_id integer,
    name character varying(255) NOT NULL,
    category character varying(255),
    brand character varying(255),
    serving_size_amount numeric(8,2) DEFAULT 100 NOT NULL,
    serving_size_unit character varying(255),
    serving_unit character varying(255),
    calories numeric(8,2),
    protein_g numeric(8,2),
    carbs_g numeric(8,2),
    fat_g numeric(8,2),
    fiber_g numeric(8,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT food_serving_size_unit_check CHECK (((serving_size_unit)::text = ANY ((ARRAY['g'::character varying, 'ml'::character varying, 'piece'::character varying, 'cup'::character varying, 'tbsp'::character varying, 'tsp'::character varying])::text[])))
);


--
-- TOC entry 238 (class 1259 OID 16595)
-- Name: food_entry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.food_entry (
    id integer NOT NULL,
    user_id integer,
    food_id integer,
    log_date date NOT NULL,
    quantity numeric(6,2) DEFAULT 1 NOT NULL,
    calories numeric(8,2),
    protein_g numeric(8,2),
    carbs_g numeric(8,2),
    fat_g numeric(8,2),
    meal_type character varying(255),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT food_entry_meal_type_check CHECK (((meal_type)::text = ANY ((ARRAY['breakfast'::character varying, 'lunch'::character varying, 'dinner'::character varying, 'snack'::character varying])::text[])))
);


--
-- TOC entry 237 (class 1259 OID 16594)
-- Name: food_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.food_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 237
-- Name: food_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.food_entry_id_seq OWNED BY public.food_entry.id;


--
-- TOC entry 235 (class 1259 OID 16577)
-- Name: food_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.food_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 235
-- Name: food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.food_id_seq OWNED BY public.food.id;


--
-- TOC entry 234 (class 1259 OID 16557)
-- Name: goal_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goal_history (
    id integer NOT NULL,
    goal_id integer NOT NULL,
    change_type text,
    old_value text,
    new_value text,
    changed_at timestamp with time zone DEFAULT now(),
    changed_by integer,
    reason text,
    notes text,
    CONSTRAINT goal_history_change_type_check CHECK ((change_type = ANY (ARRAY['status'::text, 'progress'::text, 'note'::text])))
);


--
-- TOC entry 233 (class 1259 OID 16556)
-- Name: goal_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goal_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 233
-- Name: goal_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goal_history_id_seq OWNED BY public.goal_history.id;


--
-- TOC entry 232 (class 1259 OID 16533)
-- Name: goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goals (
    id integer NOT NULL,
    user_id integer,
    metric_id integer,
    category character varying(255),
    goal_text text NOT NULL,
    target_value character varying(255),
    progress character varying(255),
    status text DEFAULT 'active'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    goal_date date,
    anchor_date date,
    frequency character varying(255) DEFAULT 'once'::character varying,
    completed_at date,
    notes text,
    CONSTRAINT goals_status_check CHECK ((status = ANY (ARRAY['active'::text, 'paused'::text, 'completed'::text, 'abandoned'::text])))
);


--
-- TOC entry 231 (class 1259 OID 16532)
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 231
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goals_id_seq OWNED BY public.goals.id;


--
-- TOC entry 228 (class 1259 OID 16493)
-- Name: metric_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metric_history (
    id integer NOT NULL,
    metric_id integer NOT NULL,
    user_id integer,
    status character varying(20) NOT NULL,
    old_data_type character varying(20),
    new_data_type character varying(20),
    changed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: metric_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metric_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 227
-- Name: metric_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metric_history_id_seq OWNED BY public.metric_history.id;


--
-- TOC entry 226 (class 1259 OID 16468)
-- Name: metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics (
    id integer NOT NULL,
    user_id integer,
    category character varying(255),
    subcategory character varying(255),
    name character varying(255) NOT NULL,
    description text,
    parent_id integer,
    is_required boolean DEFAULT false,
    data_type character varying(255) NOT NULL,
    unit character varying(255),
    scale_min integer,
    scale_max integer,
    modifier_label character varying(255),
    modifier_value character varying(255),
    notes_on boolean DEFAULT false,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT metrics_data_type_check CHECK (((data_type)::text = ANY ((ARRAY['int'::character varying, 'boolean'::character varying, 'text'::character varying, 'scale'::character varying, 'decimal'::character varying, 'clock'::character varying])::text[])))
);


--
-- TOC entry 225 (class 1259 OID 16467)
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 225
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- TOC entry 241 (class 1259 OID 16676)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    executed_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 240 (class 1259 OID 16675)
-- Name: schema_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schema_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 240
-- Name: schema_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schema_migrations_id_seq OWNED BY public.schema_migrations.id;


--
-- TOC entry 224 (class 1259 OID 16449)
-- Name: set_entry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.set_entry (
    id integer NOT NULL,
    workout_id integer NOT NULL,
    exercise_id integer NOT NULL,
    set_number integer NOT NULL,
    set_type character varying(255),
    superset_id bigint,
    reps integer,
    weight_kg numeric(6,2),
    duration_s integer,
    rpe numeric(3,1),
    rest_s integer,
    notes text,
    injury_pain text
);


--
-- TOC entry 223 (class 1259 OID 16448)
-- Name: set_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.set_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 223
-- Name: set_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.set_entry_id_seq OWNED BY public.set_entry.id;


--
-- TOC entry 239 (class 1259 OID 16619)
-- Name: superset_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.superset_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 218 (class 1259 OID 16400)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone,
    is_verified boolean DEFAULT false,
    settings jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT users_email_check CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


--
-- TOC entry 217 (class 1259 OID 16399)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 220 (class 1259 OID 16418)
-- Name: workout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workout (
    id integer NOT NULL,
    user_id integer,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    title character varying(255),
    workout_type character varying(255),
    notes text
);


--
-- TOC entry 219 (class 1259 OID 16417)
-- Name: workout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 219
-- Name: workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workout_id_seq OWNED BY public.workout.id;


--
-- TOC entry 3287 (class 2604 OID 16514)
-- Name: daily_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs ALTER COLUMN id SET DEFAULT nextval('public.daily_logs_id_seq'::regclass);


--
-- TOC entry 3277 (class 2604 OID 16436)
-- Name: exercise id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise ALTER COLUMN id SET DEFAULT nextval('public.exercise_id_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 16581)
-- Name: food id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 16598)
-- Name: food_entry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry ALTER COLUMN id SET DEFAULT nextval('public.food_entry_id_seq'::regclass);


--
-- TOC entry 3294 (class 2604 OID 16560)
-- Name: goal_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history ALTER COLUMN id SET DEFAULT nextval('public.goal_history_id_seq'::regclass);


--
-- TOC entry 3289 (class 2604 OID 16536)
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals ALTER COLUMN id SET DEFAULT nextval('public.goals_id_seq'::regclass);


--
-- TOC entry 3285 (class 2604 OID 16496)
-- Name: metric_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history ALTER COLUMN id SET DEFAULT nextval('public.metric_history_id_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 16471)
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 16679)
-- Name: schema_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations ALTER COLUMN id SET DEFAULT nextval('public.schema_migrations_id_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 16452)
-- Name: set_entry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry ALTER COLUMN id SET DEFAULT nextval('public.set_entry_id_seq'::regclass);


--
-- TOC entry 3270 (class 2604 OID 16403)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 16421)
-- Name: workout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout ALTER COLUMN id SET DEFAULT nextval('public.workout_id_seq'::regclass);


--
-- TOC entry 3522 (class 0 OID 16511)
-- Dependencies: 230
-- Data for Name: daily_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_logs (id, user_id, metric_id, log_date, value_int, value_boolean, value_text, value_decimal, note, created_at) FROM stdin;
3	1	8	2025-09-22	\N	f	\N	\N	\N	2025-09-22 04:42:39.559554+00
4	1	5	2025-09-22	\N	f	\N	\N	\N	2025-09-22 04:42:40.292502+00
71	1	2	2025-10-01	\N	\N	\N	7.00	\N	2025-10-01 13:55:29.116417+00
70	1	9	2025-10-01	\N	\N	\N	6.48	\N	2025-10-01 12:54:02.950435+00
72	1	17	2025-10-01	\N	t	\N	\N	\N	2025-10-02 00:23:45.005637+00
73	1	15	2025-10-01	\N	t	\N	\N	\N	2025-10-02 00:23:47.382802+00
7	1	2	2025-09-22	\N	\N	\N	7.75	\N	2025-09-22 13:45:34.792698+00
74	1	6	2025-09-30	\N	t	\N	\N		2025-10-02 04:11:00.096812+00
75	1	7	2025-09-30	\N	t	\N	\N		2025-10-02 04:11:08.869332+00
6	1	4	2025-09-22	\N	\N	\N	-871.00	\N	2025-09-22 05:11:22.695314+00
76	1	7	2025-10-01	\N	t	\N	\N	\N	2025-10-02 04:11:23.979316+00
77	1	1	2025-10-02	\N	\N	\N	150.40	\N	2025-10-02 12:42:49.342775+00
5	1	1	2025-09-22	\N	\N	\N	151.60	\N	2025-09-22 04:43:09.251298+00
8	1	9	2025-09-22	\N	\N	\N	6.08	\N	2025-09-22 17:22:56.885077+00
2	1	7	2025-09-22	\N	t	\N	\N	\N	2025-09-22 04:42:39.313822+00
78	1	4	2025-10-02	\N	\N	\N	-60.00	\N	2025-10-02 13:33:48.985711+00
79	1	14	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:04:42.621781+00
80	1	15	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:05:00.907627+00
1	1	6	2025-09-22	\N	t	\N	\N	\N	2025-09-22 04:42:39.109268+00
11	1	11	2025-09-22	\N	t	\N	\N	\N	2025-09-23 01:58:22.774052+00
12	1	1	2025-09-23	\N	\N	\N	149.40	\N	2025-09-23 13:15:43.597976+00
13	1	3	2025-09-22	\N	\N	\N	141.00	\N	2025-09-23 13:27:05.704507+00
16	1	2	2025-09-23	\N	\N	\N	6.50	\N	2025-09-23 13:37:42.925503+00
17	1	6	2025-09-23	\N	t	\N	\N	\N	2025-09-23 22:25:15.615289+00
18	1	9	2025-09-23	\N	\N	\N	7.27	\N	2025-09-23 23:52:47.540605+00
15	1	4	2025-09-23	\N	\N	\N	838.00	\N	2025-09-23 13:33:51.988241+00
19	1	5	2025-09-23	\N	t	\N	\N	\N	2025-09-24 02:01:34.715393+00
20	1	8	2025-09-23	\N	f	\N	\N	\N	2025-09-24 02:01:37.783767+00
81	1	17	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:05:03.124835+00
21	1	3	2025-09-23	\N	\N	\N	130.00	\N	2025-09-24 03:15:43.802617+00
23	1	1	2025-09-24	\N	\N	\N	150.60	\N	2025-09-24 13:24:55.518443+00
24	1	13	2025-09-23	\N	t	\N	\N	\N	2025-09-24 13:51:33.561558+00
26	1	14	2025-09-24	\N	t	\N	\N	\N	2025-09-24 22:32:34.564732+00
27	1	9	2025-09-24	\N	\N	\N	5.84	\N	2025-09-24 22:34:23.879792+00
25	1	4	2025-09-24	\N	\N	\N	236.00	\N	2025-09-24 13:52:38.920719+00
22	1	2	2025-09-24	\N	\N	\N	9.25	\N	2025-09-24 13:20:52.229872+00
28	1	1	2025-09-25	\N	\N	\N	151.00	\N	2025-09-26 01:26:27.992379+00
29	1	9	2025-09-25	\N	\N	\N	5.60	\N	2025-09-26 01:28:17.909104+00
30	1	2	2025-09-25	\N	\N	\N	7.50	\N	2025-09-26 01:28:32.950268+00
31	1	4	2025-09-25	\N	\N	\N	38.00	\N	2025-09-26 01:32:14.145791+00
32	1	5	2025-09-25	\N	t	\N	\N	\N	2025-09-26 01:32:15.312208+00
36	1	5	2025-09-24	\N	t	\N	\N		2025-09-26 03:06:12.01593+00
82	1	23	2025-10-02	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-02T20:08:01.734678", "clock_out": "2025-10-02T20:09:23.359022", "duration_minutes": 1}, {"clock_in": "2025-10-02T20:09:25.165267", "clock_out": "2025-10-02T20:09:38.975842", "duration_minutes": 0}, {"clock_in": "2025-10-02T20:09:43.787083", "clock_out": "2025-10-02T20:17:48.411392", "duration_minutes": 8}], "total_duration_minutes": 9, "last_updated": "2025-10-02T20:17:48.411392"}	\N	\N	2025-10-03 01:08:01.818039+00
38	1	12	2025-09-24	\N	f	\N	\N		2025-09-26 03:18:51.149147+00
39	1	14	2025-09-25	\N	t	\N	\N	\N	2025-09-26 03:44:16.656282+00
40	1	3	2025-09-25	\N	\N	\N	60.00	\N	2025-09-26 04:01:58.172568+00
35	1	5	2025-09-26	\N	f	\N	\N		2025-09-26 03:05:43.117044+00
41	1	1	2025-09-26	\N	\N	\N	150.20	\N	2025-09-26 13:09:47.428957+00
42	1	7	2025-09-25	\N	t	\N	\N		2025-09-26 13:11:31.122425+00
43	1	14	2025-09-26	\N	t	\N	\N	\N	2025-09-26 13:21:17.915703+00
44	1	13	2025-09-27	\N	f	\N	\N	\N	2025-09-27 19:10:43.578153+00
45	1	11	2025-09-27	\N	f	\N	\N	\N	2025-09-27 19:10:51.4011+00
46	1	8	2025-09-27	\N	t	\N	\N	\N	2025-09-27 19:10:53.292065+00
47	1	14	2025-09-27	\N	t	\N	\N	\N	2025-09-27 19:57:24.902657+00
48	1	5	2025-09-27	\N	t	\N	\N	\N	2025-09-27 21:39:47.209956+00
49	1	1	2025-09-27	\N	\N	\N	147.40	\N	2025-09-27 22:29:55.76659+00
50	1	4	2025-09-27	\N	\N	\N	-37.00	\N	2025-09-27 22:36:29.449045+00
51	1	14	2025-09-28	\N	t	\N	\N	\N	2025-09-28 17:00:40.021958+00
52	1	9	2025-09-28	\N	\N	\N	0.00		2025-09-28 17:48:50.319994+00
53	1	9	2025-09-26	\N	\N	\N	6.94		2025-09-28 17:49:21.65313+00
54	1	4	2025-09-29	\N	\N	\N	-230.00	\N	2025-09-29 12:51:46.832533+00
55	1	1	2025-09-29	\N	\N	\N	150.40	\N	2025-09-29 13:34:07.794766+00
56	1	14	2025-09-29	\N	t	\N	\N	\N	2025-09-29 13:34:13.527039+00
57	1	17	2025-09-29	\N	t	\N	\N	\N	2025-09-30 00:56:27.584832+00
58	1	15	2025-09-29	\N	t	\N	\N	\N	2025-09-30 00:56:31.025075+00
59	1	9	2025-09-29	\N	\N	\N	7.00	\N	2025-09-30 04:08:37.644259+00
60	1	4	2025-09-30	\N	\N	\N	233.00	\N	2025-09-30 13:37:22.367895+00
61	1	2	2025-09-30	\N	\N	\N	8.00	\N	2025-09-30 13:37:38.203705+00
62	1	12	2025-09-29	\N	t	\N	\N		2025-09-30 13:38:13.51953+00
63	1	1	2025-09-30	\N	\N	\N	150.60	\N	2025-09-30 13:40:38.832263+00
64	1	17	2025-09-30	\N	t	\N	\N	\N	2025-09-30 20:47:22.723534+00
66	1	14	2025-09-30	\N	t	\N	\N	\N	2025-09-30 21:12:53.078017+00
67	1	15	2025-09-30	\N	t	\N	\N	\N	2025-09-30 21:12:53.425745+00
65	1	16	2025-09-30	\N	f	\N	\N	\N	2025-09-30 21:12:50.629601+00
68	1	9	2025-09-30	\N	\N	\N	6.00	\N	2025-10-01 03:06:04.570905+00
69	1	1	2025-10-01	\N	\N	\N	150.60	\N	2025-10-01 03:51:22.063603+00
\.


--
-- TOC entry 3514 (class 0 OID 16433)
-- Dependencies: 222
-- Data for Name: exercise; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exercise (id, user_id, name, description, exercise_type, exercise_subtype, primary_muscles, secondary_muscles, equipment, equipment_modifiers, tags, injury_pain) FROM stdin;
\.


--
-- TOC entry 3528 (class 0 OID 16578)
-- Dependencies: 236
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.food (id, user_id, name, category, brand, serving_size_amount, serving_size_unit, serving_unit, calories, protein_g, carbs_g, fat_g, fiber_g, notes, created_at) FROM stdin;
\.


--
-- TOC entry 3530 (class 0 OID 16595)
-- Dependencies: 238
-- Data for Name: food_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.food_entry (id, user_id, food_id, log_date, quantity, calories, protein_g, carbs_g, fat_g, meal_type, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3526 (class 0 OID 16557)
-- Dependencies: 234
-- Data for Name: goal_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.goal_history (id, goal_id, change_type, old_value, new_value, changed_at, changed_by, reason, notes) FROM stdin;
\.


--
-- TOC entry 3524 (class 0 OID 16533)
-- Dependencies: 232
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.goals (id, user_id, metric_id, category, goal_text, target_value, progress, status, created_at, updated_at, goal_date, anchor_date, frequency, completed_at, notes) FROM stdin;
\.


--
-- TOC entry 3520 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: metric_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metric_history (id, metric_id, user_id, status, old_data_type, new_data_type, changed_at) FROM stdin;
\.


--
-- TOC entry 3518 (class 0 OID 16468)
-- Dependencies: 226
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metrics (id, user_id, category, subcategory, name, description, parent_id, is_required, data_type, unit, scale_min, scale_max, modifier_label, modifier_value, notes_on, active, created_at, updated_at) FROM stdin;
1	1	\N	\N	BW		\N	f	decimal	lbs	\N	\N	\N	\N	f	t	2025-09-22 04:27:14.194714+00	2025-09-22 04:27:14.194714+00
2	1	\N	\N	Sleep	Hours in bed last night	\N	f	decimal	Hours	\N	\N	\N	\N	f	t	2025-09-22 04:28:02.511276+00	2025-09-22 04:28:02.511276+00
3	1	\N	\N	Protein Intake		\N	f	decimal	Grams	\N	\N	\N	\N	f	t	2025-09-22 04:28:49.323002+00	2025-09-22 04:28:49.323002+00
4	1	\N	\N	Net Liquid Assets	Checking Account + Savings Account(s) + Cash - Credit Card Balance(s)	\N	f	decimal	Dollars	\N	\N	\N	\N	f	t	2025-09-22 04:30:30.882221+00	2025-09-22 04:30:30.882221+00
5	1	\N	\N	15 min workout	15 mins of physical training that will maintain or improve overall physical readiness: strength, endurance, flexibility, ect.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:33:28.325271+00	2025-09-22 04:33:28.325271+00
7	1	\N	\N	10 mins reading 	At least 10 mins of focused reading of a physical book, not an audiobook, not an article, and not about 10 minutes of total time throughout the day of sneaking a minute in. At least 10 mins in a row of focused reading.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:36:14.943501+00	2025-09-22 04:36:14.943501+00
8	1	\N	\N	30 min Lifting Session 	At least 30 mins lifting.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:38:15.208471+00	2025-09-22 04:38:15.208471+00
9	1	\N	\N	Hours Worked	Billable hours worked today.	\N	f	decimal	Hours	\N	\N	\N	\N	f	t	2025-09-22 04:38:58.818402+00	2025-09-22 04:38:58.818402+00
10	1	\N	\N	Protein Goal (BW+10 gs)	>= BW + 10 grams of protein consumed today 	\N	f	decimal	Grams	\N	\N	\N	\N	f	t	2025-09-22 04:39:46.090656+00	2025-09-22 04:39:46.090656+00
11	1	\N	\N	10 mins stretching		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 13:45:52.904118+00	2025-09-22 13:45:52.904118+00
12	1	\N	\N	Floss	Did I floss 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-23 15:10:43.249457+00	2025-09-23 15:10:43.249457+00
13	1	\N	\N	5 mins Mindlessness	>= 5 mins sitting or laying comfortably acknowledging thoughts but not indulging them. Notice a thought and push it away. Aiming for a slow empty calm mind. 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-23 15:12:56.293269+00	2025-09-23 15:12:56.293269+00
6	1	\N	\N	10 mins cleaning	15 mins cleaning house or truck. If not at home and don't have access to truck then cleaning out email, photos, notes, home screen or something similar will count. 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:34:35.433746+00	2025-09-22 04:34:35.433746+00
14	1	\N	\N	5 mins+ violin learning songs		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-24 22:32:12.512463+00	2025-09-24 22:32:12.512463+00
15	1	\N	\N	5 mins violin practicing scales/arpeggios		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-29 19:28:18.167268+00	2025-09-29 19:28:18.167268+00
17	1	\N	\N	5 mins rhythm guitar practice	Intentionally learning and practicing specific rythym guitar techniques	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-30 00:45:22.589016+00	2025-09-30 00:45:22.589016+00
16	1	\N	\N	5 mins learning lead songs	Spend time learning the lead parts for a song.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-30 00:44:04.208524+00	2025-09-30 00:44:04.208524+00
19	1	\N	\N	Work Clock		\N	f	text	Time	\N	\N	\N	\N	f	t	2025-10-03 00:26:52.677238+00	2025-10-03 00:26:52.677238+00
22	1	\N	\N	Test Clock	Test clock metric	\N	f	clock		\N	\N	\N	\N	f	t	2025-10-03 00:39:23.219964+00	2025-10-03 00:39:23.219964+00
23	1	\N	\N	Work Work Work		\N	f	clock		\N	\N	\N	\N	f	t	2025-10-03 00:58:14.657091+00	2025-10-03 00:58:14.657091+00
\.


--
-- TOC entry 3533 (class 0 OID 16676)
-- Dependencies: 241
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (id, filename, executed_at) FROM stdin;
1	001_add_clock_data_type.sql	2025-10-03 00:28:41.72681
\.


--
-- TOC entry 3516 (class 0 OID 16449)
-- Dependencies: 224
-- Data for Name: set_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.set_entry (id, workout_id, exercise_id, set_number, set_type, superset_id, reps, weight_kg, duration_s, rpe, rest_s, notes, injury_pain) FROM stdin;
\.


--
-- TOC entry 3510 (class 0 OID 16400)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password_hash, first_name, last_name, created_at, updated_at, last_login, is_verified, settings) FROM stdin;
1	Calvin	Calvingaiennie@gmail.com	Password1	Calvin	Gaiennie	2025-09-21 04:15:40.210767+00	2025-09-27 21:37:49.810728+00	\N	f	{"enabledPages": ["homePage", "dietPage", "workoutPage", "analyticsPage"], "homePageLayout": [{"section": "To Log", "metricIds": [1, 2, 3, 4, 9, 23]}, {"section": "To Do", "metricIds": [5, 6, 7, 8, 11, 12, 13, 14, 15]}]}
\.


--
-- TOC entry 3512 (class 0 OID 16418)
-- Dependencies: 220
-- Data for Name: workout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workout (id, user_id, started_at, ended_at, title, workout_type, notes) FROM stdin;
\.


--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 229
-- Name: daily_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.daily_logs_id_seq', 82, true);


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 221
-- Name: exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exercise_id_seq', 1, false);


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 237
-- Name: food_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_entry_id_seq', 1, false);


--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 235
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_id_seq', 1, false);


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 233
-- Name: goal_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.goal_history_id_seq', 1, false);


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 231
-- Name: goals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.goals_id_seq', 1, false);


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 227
-- Name: metric_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metric_history_id_seq', 1, false);


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 225
-- Name: metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metrics_id_seq', 23, true);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 240
-- Name: schema_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schema_migrations_id_seq', 1, true);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 223
-- Name: set_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.set_entry_id_seq', 1, false);


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 239
-- Name: superset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.superset_seq', 1, false);


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 219
-- Name: workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workout_id_seq', 1, false);


--
-- TOC entry 3330 (class 2606 OID 16521)
-- Name: daily_logs daily_logs_metric_id_log_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_metric_id_log_date_key UNIQUE (metric_id, log_date);


--
-- TOC entry 3332 (class 2606 OID 16519)
-- Name: daily_logs daily_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 16442)
-- Name: exercise exercise_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_name_key UNIQUE (name);


--
-- TOC entry 3322 (class 2606 OID 16440)
-- Name: exercise exercise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 16606)
-- Name: food_entry food_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 16608)
-- Name: food_entry food_entry_user_id_food_id_log_date_created_at_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_user_id_food_id_log_date_created_at_key UNIQUE (user_id, food_id, log_date, created_at);


--
-- TOC entry 3338 (class 2606 OID 16588)
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 16566)
-- Name: goal_history goal_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 16545)
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 16499)
-- Name: metric_history metric_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 16481)
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 16684)
-- Name: schema_migrations schema_migrations_filename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_filename_key UNIQUE (filename);


--
-- TOC entry 3346 (class 2606 OID 16682)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 16456)
-- Name: set_entry set_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_pkey PRIMARY KEY (id);


--
-- TOC entry 3312 (class 2606 OID 16416)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3314 (class 2606 OID 16412)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3316 (class 2606 OID 16414)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3318 (class 2606 OID 16426)
-- Name: workout workout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_pkey PRIMARY KEY (id);


--
-- TOC entry 3355 (class 2606 OID 16527)
-- Name: daily_logs daily_logs_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE CASCADE;


--
-- TOC entry 3356 (class 2606 OID 16522)
-- Name: daily_logs daily_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3348 (class 2606 OID 16443)
-- Name: exercise exercise_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3362 (class 2606 OID 16614)
-- Name: food_entry food_entry_food_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_food_id_fkey FOREIGN KEY (food_id) REFERENCES public.food(id) ON DELETE SET NULL;


--
-- TOC entry 3363 (class 2606 OID 16609)
-- Name: food_entry food_entry_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3361 (class 2606 OID 16589)
-- Name: food food_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3359 (class 2606 OID 16572)
-- Name: goal_history goal_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3360 (class 2606 OID 16567)
-- Name: goal_history goal_history_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.goals(id) ON DELETE CASCADE;


--
-- TOC entry 3357 (class 2606 OID 16551)
-- Name: goals goals_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE SET NULL;


--
-- TOC entry 3358 (class 2606 OID 16546)
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3353 (class 2606 OID 16500)
-- Name: metric_history metric_history_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE CASCADE;


--
-- TOC entry 3354 (class 2606 OID 16505)
-- Name: metric_history metric_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3351 (class 2606 OID 16487)
-- Name: metrics metrics_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.metrics(id) ON DELETE SET NULL;


--
-- TOC entry 3352 (class 2606 OID 16482)
-- Name: metrics metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3349 (class 2606 OID 16462)
-- Name: set_entry set_entry_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercise(id);


--
-- TOC entry 3350 (class 2606 OID 16457)
-- Name: set_entry set_entry_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workout(id) ON DELETE CASCADE;


--
-- TOC entry 3347 (class 2606 OID 16427)
-- Name: workout workout_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2025-10-02 20:47:09 CDT

--
-- PostgreSQL database dump complete
--

\unrestrict LUW4tUwD0wqOGN7ochfU3ZhiawBEf5cLHlapXGIJEJmjS687zLvQQ6dGhp0JTZK

