--
-- PostgreSQL database dump
--

\restrict cz3u3yx4hfiMuTeYMUq1VcY2igsBzWfdyJTrZMG5zjMjp4bn94e9fC1cOiia3NM

-- Dumped from database version 17.6 (Debian 17.6-2.pgdg12+1)
-- Dumped by pg_dump version 17.6 (Homebrew)

-- Started on 2026-01-09 14:56:24 CST

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

ALTER TABLE ONLY public.workouts DROP CONSTRAINT workouts_user_id_fkey;
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
ALTER TABLE ONLY public.foods DROP CONSTRAINT food_user_id_fkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_user_id_fkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_food_id_fkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_user_id_fkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_user_id_fkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_metric_id_fkey;
ALTER TABLE ONLY public.workouts DROP CONSTRAINT workouts_pkey;
ALTER TABLE ONLY public.workout DROP CONSTRAINT workout_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_stripe_customer_id_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
ALTER TABLE ONLY public.stripe_customers DROP CONSTRAINT stripe_customers_stripe_customer_id_key;
ALTER TABLE ONLY public.stripe_customers DROP CONSTRAINT stripe_customers_pkey;
ALTER TABLE ONLY public.set_entry DROP CONSTRAINT set_entry_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_filename_key;
ALTER TABLE ONLY public.metrics DROP CONSTRAINT metrics_pkey;
ALTER TABLE ONLY public.metric_history DROP CONSTRAINT metric_history_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.goal_history DROP CONSTRAINT goal_history_pkey;
ALTER TABLE ONLY public.foods DROP CONSTRAINT food_pkey;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_user_id_food_id_log_date_created_at_key;
ALTER TABLE ONLY public.food_entry DROP CONSTRAINT food_entry_pkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_pkey;
ALTER TABLE ONLY public.exercise DROP CONSTRAINT exercise_name_key;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_pkey;
ALTER TABLE ONLY public.daily_logs DROP CONSTRAINT daily_logs_metric_id_log_date_key;
ALTER TABLE public.workouts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.workout ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.stripe_customers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.set_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.schema_migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.metrics ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.metric_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.goal_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.foods ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.food_entry ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.exercise ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.daily_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.workouts_id_seq;
DROP TABLE public.workouts;
DROP SEQUENCE public.workout_id_seq;
DROP TABLE public.workout;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.superset_seq;
DROP SEQUENCE public.stripe_customers_id_seq;
DROP TABLE public.stripe_customers;
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
DROP TABLE public.foods;
DROP SEQUENCE public.food_entry_id_seq;
DROP TABLE public.food_entry;
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
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
-- TOC entry 3568 (class 0 OID 0)
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
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 221
-- Name: exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercise_id_seq OWNED BY public.exercise.id;


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
    food_name text NOT NULL,
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
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 237
-- Name: food_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.food_entry_id_seq OWNED BY public.food_entry.id;


--
-- TOC entry 236 (class 1259 OID 16578)
-- Name: foods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.foods (
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
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 235
-- Name: food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.food_id_seq OWNED BY public.foods.id;


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
-- TOC entry 3572 (class 0 OID 0)
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
-- TOC entry 3573 (class 0 OID 0)
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
-- TOC entry 3574 (class 0 OID 0)
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
    initials character varying(5),
    time_type character varying(50),
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
-- TOC entry 3575 (class 0 OID 0)
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
-- TOC entry 3576 (class 0 OID 0)
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
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 223
-- Name: set_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.set_entry_id_seq OWNED BY public.set_entry.id;


--
-- TOC entry 245 (class 1259 OID 16705)
-- Name: stripe_customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_customers (
    id integer NOT NULL,
    stripe_customer_id character varying(255) NOT NULL,
    tier character varying(20),
    active boolean DEFAULT false,
    subscription_id character varying(255),
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 244 (class 1259 OID 16704)
-- Name: stripe_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stripe_customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 244
-- Name: stripe_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stripe_customers_id_seq OWNED BY public.stripe_customers.id;


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
    stripe_customer_id character varying(255),
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
-- TOC entry 3579 (class 0 OID 0)
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
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 219
-- Name: workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workout_id_seq OWNED BY public.workout.id;


--
-- TOC entry 243 (class 1259 OID 16687)
-- Name: workouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workouts (
    id integer NOT NULL,
    user_id integer,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    title character varying(255),
    workout_types text[],
    notes text,
    exercises jsonb,
    is_draft boolean DEFAULT false,
    deleted_at timestamp with time zone
);


--
-- TOC entry 242 (class 1259 OID 16686)
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 242
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workouts_id_seq OWNED BY public.workouts.id;


--
-- TOC entry 3297 (class 2604 OID 16514)
-- Name: daily_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs ALTER COLUMN id SET DEFAULT nextval('public.daily_logs_id_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 16436)
-- Name: exercise id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise ALTER COLUMN id SET DEFAULT nextval('public.exercise_id_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 16598)
-- Name: food_entry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry ALTER COLUMN id SET DEFAULT nextval('public.food_entry_id_seq'::regclass);


--
-- TOC entry 3306 (class 2604 OID 16581)
-- Name: foods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foods ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 16560)
-- Name: goal_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history ALTER COLUMN id SET DEFAULT nextval('public.goal_history_id_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 16536)
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals ALTER COLUMN id SET DEFAULT nextval('public.goals_id_seq'::regclass);


--
-- TOC entry 3295 (class 2604 OID 16496)
-- Name: metric_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history ALTER COLUMN id SET DEFAULT nextval('public.metric_history_id_seq'::regclass);


--
-- TOC entry 3289 (class 2604 OID 16471)
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- TOC entry 3313 (class 2604 OID 16679)
-- Name: schema_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations ALTER COLUMN id SET DEFAULT nextval('public.schema_migrations_id_seq'::regclass);


--
-- TOC entry 3288 (class 2604 OID 16452)
-- Name: set_entry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry ALTER COLUMN id SET DEFAULT nextval('public.set_entry_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 16708)
-- Name: stripe_customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_customers ALTER COLUMN id SET DEFAULT nextval('public.stripe_customers_id_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 16403)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3285 (class 2604 OID 16421)
-- Name: workout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout ALTER COLUMN id SET DEFAULT nextval('public.workout_id_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 16690)
-- Name: workouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts ALTER COLUMN id SET DEFAULT nextval('public.workouts_id_seq'::regclass);


--
-- TOC entry 3547 (class 0 OID 16511)
-- Dependencies: 230
-- Data for Name: daily_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_logs (id, user_id, metric_id, log_date, value_int, value_boolean, value_text, value_decimal, note, created_at, deleted_at) FROM stdin;
3	1	8	2025-09-22	\N	f	\N	\N	\N	2025-09-22 04:42:39.559554+00	\N
4	1	5	2025-09-22	\N	f	\N	\N	\N	2025-09-22 04:42:40.292502+00	\N
83	1	16	2025-10-02	\N	f	\N	\N	\N	2025-10-03 01:54:03.680234+00	\N
71	1	2	2025-10-01	\N	\N	\N	7.00	\N	2025-10-01 13:55:29.116417+00	\N
70	1	9	2025-10-01	\N	\N	\N	6.48	\N	2025-10-01 12:54:02.950435+00	\N
72	1	17	2025-10-01	\N	t	\N	\N	\N	2025-10-02 00:23:45.005637+00	\N
73	1	15	2025-10-01	\N	t	\N	\N	\N	2025-10-02 00:23:47.382802+00	\N
7	1	2	2025-09-22	\N	\N	\N	7.75	\N	2025-09-22 13:45:34.792698+00	\N
74	1	6	2025-09-30	\N	t	\N	\N		2025-10-02 04:11:00.096812+00	\N
75	1	7	2025-09-30	\N	t	\N	\N		2025-10-02 04:11:08.869332+00	\N
6	1	4	2025-09-22	\N	\N	\N	-871.00	\N	2025-09-22 05:11:22.695314+00	\N
76	1	7	2025-10-01	\N	t	\N	\N	\N	2025-10-02 04:11:23.979316+00	\N
77	1	1	2025-10-02	\N	\N	\N	150.40	\N	2025-10-02 12:42:49.342775+00	\N
5	1	1	2025-09-22	\N	\N	\N	151.60	\N	2025-09-22 04:43:09.251298+00	\N
8	1	9	2025-09-22	\N	\N	\N	6.08	\N	2025-09-22 17:22:56.885077+00	\N
2	1	7	2025-09-22	\N	t	\N	\N	\N	2025-09-22 04:42:39.313822+00	\N
78	1	4	2025-10-02	\N	\N	\N	-60.00	\N	2025-10-02 13:33:48.985711+00	\N
79	1	14	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:04:42.621781+00	\N
80	1	15	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:05:00.907627+00	\N
1	1	6	2025-09-22	\N	t	\N	\N	\N	2025-09-22 04:42:39.109268+00	\N
11	1	11	2025-09-22	\N	t	\N	\N	\N	2025-09-23 01:58:22.774052+00	\N
12	1	1	2025-09-23	\N	\N	\N	149.40	\N	2025-09-23 13:15:43.597976+00	\N
13	1	3	2025-09-22	\N	\N	\N	141.00	\N	2025-09-23 13:27:05.704507+00	\N
16	1	2	2025-09-23	\N	\N	\N	6.50	\N	2025-09-23 13:37:42.925503+00	\N
17	1	6	2025-09-23	\N	t	\N	\N	\N	2025-09-23 22:25:15.615289+00	\N
18	1	9	2025-09-23	\N	\N	\N	7.27	\N	2025-09-23 23:52:47.540605+00	\N
15	1	4	2025-09-23	\N	\N	\N	838.00	\N	2025-09-23 13:33:51.988241+00	\N
19	1	5	2025-09-23	\N	t	\N	\N	\N	2025-09-24 02:01:34.715393+00	\N
20	1	8	2025-09-23	\N	f	\N	\N	\N	2025-09-24 02:01:37.783767+00	\N
81	1	17	2025-10-02	\N	t	\N	\N	\N	2025-10-02 19:05:03.124835+00	\N
21	1	3	2025-09-23	\N	\N	\N	130.00	\N	2025-09-24 03:15:43.802617+00	\N
23	1	1	2025-09-24	\N	\N	\N	150.60	\N	2025-09-24 13:24:55.518443+00	\N
24	1	13	2025-09-23	\N	t	\N	\N	\N	2025-09-24 13:51:33.561558+00	\N
26	1	14	2025-09-24	\N	t	\N	\N	\N	2025-09-24 22:32:34.564732+00	\N
27	1	9	2025-09-24	\N	\N	\N	5.84	\N	2025-09-24 22:34:23.879792+00	\N
25	1	4	2025-09-24	\N	\N	\N	236.00	\N	2025-09-24 13:52:38.920719+00	\N
84	1	12	2025-10-02	\N	t	\N	\N		2025-10-03 01:57:00.643502+00	\N
22	1	2	2025-09-24	\N	\N	\N	9.25	\N	2025-09-24 13:20:52.229872+00	\N
28	1	1	2025-09-25	\N	\N	\N	151.00	\N	2025-09-26 01:26:27.992379+00	\N
29	1	9	2025-09-25	\N	\N	\N	5.60	\N	2025-09-26 01:28:17.909104+00	\N
30	1	2	2025-09-25	\N	\N	\N	7.50	\N	2025-09-26 01:28:32.950268+00	\N
31	1	4	2025-09-25	\N	\N	\N	38.00	\N	2025-09-26 01:32:14.145791+00	\N
32	1	5	2025-09-25	\N	t	\N	\N	\N	2025-09-26 01:32:15.312208+00	\N
36	1	5	2025-09-24	\N	t	\N	\N		2025-09-26 03:06:12.01593+00	\N
90	1	2	2025-10-04	0	f		8.00		2025-10-04 20:09:00.594245+00	\N
91	1	16	2025-10-04	0	t		\N		2025-10-04 20:55:15.682872+00	\N
82	1	23	2025-10-02	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-02T20:08:01.734678", "clock_out": "2025-10-02T20:09:23.359022", "duration_minutes": 1}, {"clock_in": "2025-10-02T20:09:25.165267", "clock_out": "2025-10-02T20:09:38.975842", "duration_minutes": 0}, {"clock_in": "2025-10-02T20:09:43.787083", "clock_out": "2025-10-02T20:17:48.411392", "duration_minutes": 8}], "total_duration_minutes": 9, "last_updated": "2025-10-02T20:17:48.411392"}	\N	\N	2025-10-03 01:08:01.818039+00	\N
38	1	12	2025-09-24	\N	f	\N	\N		2025-09-26 03:18:51.149147+00	\N
39	1	14	2025-09-25	\N	t	\N	\N	\N	2025-09-26 03:44:16.656282+00	\N
40	1	3	2025-09-25	\N	\N	\N	60.00	\N	2025-09-26 04:01:58.172568+00	\N
35	1	5	2025-09-26	\N	f	\N	\N		2025-09-26 03:05:43.117044+00	\N
41	1	1	2025-09-26	\N	\N	\N	150.20	\N	2025-09-26 13:09:47.428957+00	\N
42	1	7	2025-09-25	\N	t	\N	\N		2025-09-26 13:11:31.122425+00	\N
43	1	14	2025-09-26	\N	t	\N	\N	\N	2025-09-26 13:21:17.915703+00	\N
44	1	13	2025-09-27	\N	f	\N	\N	\N	2025-09-27 19:10:43.578153+00	\N
45	1	11	2025-09-27	\N	f	\N	\N	\N	2025-09-27 19:10:51.4011+00	\N
46	1	8	2025-09-27	\N	t	\N	\N	\N	2025-09-27 19:10:53.292065+00	\N
47	1	14	2025-09-27	\N	t	\N	\N	\N	2025-09-27 19:57:24.902657+00	\N
48	1	5	2025-09-27	\N	t	\N	\N	\N	2025-09-27 21:39:47.209956+00	\N
49	1	1	2025-09-27	\N	\N	\N	147.40	\N	2025-09-27 22:29:55.76659+00	\N
50	1	4	2025-09-27	\N	\N	\N	-37.00	\N	2025-09-27 22:36:29.449045+00	\N
92	1	24	2025-10-04	0	t		\N		2025-10-04 20:55:18.674812+00	\N
51	1	14	2025-09-28	\N	t	\N	\N	\N	2025-09-28 17:00:40.021958+00	\N
52	1	9	2025-09-28	\N	\N	\N	0.00		2025-09-28 17:48:50.319994+00	\N
53	1	9	2025-09-26	\N	\N	\N	6.94		2025-09-28 17:49:21.65313+00	\N
54	1	4	2025-09-29	\N	\N	\N	-230.00	\N	2025-09-29 12:51:46.832533+00	\N
55	1	1	2025-09-29	\N	\N	\N	150.40	\N	2025-09-29 13:34:07.794766+00	\N
56	1	14	2025-09-29	\N	t	\N	\N	\N	2025-09-29 13:34:13.527039+00	\N
57	1	17	2025-09-29	\N	t	\N	\N	\N	2025-09-30 00:56:27.584832+00	\N
58	1	15	2025-09-29	\N	t	\N	\N	\N	2025-09-30 00:56:31.025075+00	\N
59	1	9	2025-09-29	\N	\N	\N	7.00	\N	2025-09-30 04:08:37.644259+00	\N
60	1	4	2025-09-30	\N	\N	\N	233.00	\N	2025-09-30 13:37:22.367895+00	\N
61	1	2	2025-09-30	\N	\N	\N	8.00	\N	2025-09-30 13:37:38.203705+00	\N
62	1	12	2025-09-29	\N	t	\N	\N		2025-09-30 13:38:13.51953+00	\N
63	1	1	2025-09-30	\N	\N	\N	150.60	\N	2025-09-30 13:40:38.832263+00	\N
64	1	17	2025-09-30	\N	t	\N	\N	\N	2025-09-30 20:47:22.723534+00	\N
66	1	14	2025-09-30	\N	t	\N	\N	\N	2025-09-30 21:12:53.078017+00	\N
67	1	15	2025-09-30	\N	t	\N	\N	\N	2025-09-30 21:12:53.425745+00	\N
65	1	16	2025-09-30	\N	f	\N	\N	\N	2025-09-30 21:12:50.629601+00	\N
68	1	9	2025-09-30	\N	\N	\N	6.00	\N	2025-10-01 03:06:04.570905+00	\N
93	1	4	2025-10-04	0	f		-297.00		2025-10-04 21:12:53.436028+00	\N
94	1	15	2025-10-04	0	t		\N		2025-10-04 21:55:25.820381+00	\N
69	1	1	2025-10-01	\N	\N	\N	150.60	\N	2025-10-01 03:51:22.063603+00	\N
98	1	15	2025-10-05	0	t		\N		2025-10-06 00:26:52.911258+00	\N
99	1	23	2025-10-06	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-06T14:03:08.649079", "clock_out": "2025-10-06T15:56:00.543170", "duration_minutes": 112}, {"clock_in": "2025-10-06T17:39:35.600373", "clock_out": "2025-10-06T20:52:39.226039", "duration_minutes": 193}], "total_duration_minutes": 305, "last_updated": "2025-10-06T20:52:39.226039"}	\N	\N	2025-10-06 14:03:08.663411+00	\N
100	1	9	2025-10-06	0	f		5.08		2025-10-07 02:12:01.899848+00	\N
95	1	4	2025-10-05	0	f		-274.00		2025-10-05 15:35:31.373722+00	\N
85	1	1	2025-10-03	0	f		149.60		2025-10-03 13:55:15.617947+00	\N
86	1	23	2025-10-03	0	f	{"current_state": "clocked_in", "last_updated": "2025-10-03T14:37:21.009068"}	\N		2025-10-03 14:28:51.787107+00	\N
87	1	4	2025-10-03	0	f		-256.00		2025-10-03 14:43:43.973725+00	\N
88	1	17	2025-10-04	0	t		\N		2025-10-04 20:08:41.092354+00	\N
89	1	9	2025-10-04	0	f		2.75		2025-10-04 20:08:52.733575+00	\N
96	1	9	2025-10-05	0	f		0.01		2025-10-05 15:56:34.484005+00	\N
97	1	6	2025-10-05	0	t		\N		2025-10-05 23:35:51.374178+00	\N
101	1	25	2025-10-07	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-07T02:13:36.555879", "clock_out": "2025-10-07T02:13:37.378065", "duration_minutes": 0}], "total_duration_minutes": 0, "last_updated": "2025-10-07T02:13:37.378065"}	\N	\N	2025-10-07 02:13:36.556609+00	\N
102	1	13	2025-10-06	0	t		\N		2025-10-07 02:18:56.605749+00	\N
103	1	1	2025-10-06	0	f		150.00		2025-10-07 02:45:17.091983+00	\N
105	1	4	2025-10-07	0	f		-97.00		2025-10-07 16:13:42.809445+00	\N
106	1	15	2025-10-07	0	t		\N		2025-10-07 17:31:15.383857+00	\N
109	1	17	2025-10-10	0	f		\N		2025-10-10 22:54:55.56631+00	\N
110	1	15	2025-10-10	0	t		\N		2025-10-10 22:54:58.830764+00	\N
104	1	23	2025-10-07	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-07T14:09:13.145590", "clock_out": "2025-10-07T17:27:12.562783", "duration_minutes": 197}], "total_duration_minutes": 197, "last_updated": "2025-10-07T17:27:12.562783"}	\N	\N	2025-10-07 14:09:13.14769+00	\N
107	1	4	2025-10-08	0	f		-223.00		2025-10-08 16:53:55.229815+00	\N
108	1	16	2025-10-10	0	t		\N		2025-10-10 22:54:54.186927+00	\N
111	1	14	2025-10-10	0	t		\N		2025-10-10 22:55:05.182816+00	\N
114	1	15	2025-10-09	0	t		\N		2025-10-10 22:55:38.607633+00	\N
112	1	24	2025-10-10	0	t		\N		2025-10-10 22:55:11.358528+00	\N
115	1	14	2025-10-09	0	t		\N		2025-10-10 22:55:50.71704+00	\N
113	1	26	2025-10-09	0	t		\N		2025-10-10 22:55:18.19399+00	\N
116	1	4	2025-10-11	0	f		402.00		2025-10-11 19:28:21.055426+00	\N
117	1	4	2025-10-12	0	f		401.57		2025-10-12 20:46:47.77825+00	\N
118	1	15	2025-10-12	0	t		\N		2025-10-12 21:05:54.369444+00	\N
119	1	14	2025-10-12	0	t		\N		2025-10-12 21:05:55.139734+00	\N
120	1	26	2025-10-12	0	t		\N		2025-10-12 21:05:57.172381+00	\N
121	1	8	2025-10-12	0	t		\N		2025-10-12 21:06:00.432005+00	\N
122	1	5	2025-10-12	0	t		\N		2025-10-12 21:06:03.885333+00	\N
123	1	14	2025-10-13	0	t		\N		2025-10-13 15:24:31.322341+00	\N
124	1	15	2025-10-14	0	t		\N		2025-10-15 13:07:37.073637+00	\N
125	1	14	2025-10-14	0	t		\N		2025-10-15 13:07:46.997635+00	\N
126	1	24	2025-10-14	0	t		\N		2025-10-15 13:07:56.91044+00	\N
127	1	15	2025-10-15	0	f		\N		2025-10-16 14:33:31.116991+00	\N
128	1	14	2025-10-15	0	t		\N		2025-10-16 14:33:38.45698+00	\N
129	1	4	2025-10-16	0	f		387.00		2025-10-16 14:44:12.468506+00	\N
130	1	4	2025-10-18	0	f		250.00		2025-10-18 23:40:56.643278+00	\N
131	1	4	2025-10-21	0	f		163.00		2025-10-21 13:38:02.907566+00	\N
132	1	14	2025-10-21	0	t		\N		2025-10-21 13:38:42.533723+00	\N
133	1	14	2025-10-20	0	t		\N		2025-10-21 13:38:56.532931+00	\N
134	1	4	2025-10-22	0	f		-79.00		2025-10-23 01:20:55.259606+00	\N
135	1	14	2025-10-23	0	t		\N		2025-10-24 14:05:06.607914+00	\N
136	1	4	2025-10-24	0	f		257.00		2025-10-25 02:54:06.207691+00	\N
137	1	4	2025-10-25	0	f		256.00		2025-10-25 15:28:29.189806+00	\N
138	1	28	2025-10-25	0	t		\N		2025-10-25 15:29:40.570401+00	\N
139	1	5	2025-10-25	0	t		\N		2025-10-25 23:06:45.459431+00	\N
140	1	27	2025-10-25	0	t		\N		2025-10-25 23:06:45.883384+00	\N
141	1	26	2025-10-25	0	t		\N		2025-10-25 23:06:48.87358+00	\N
142	1	7	2025-10-25	0	t		\N		2025-10-26 01:13:27.950251+00	\N
143	1	28	2025-10-26	0	t		\N		2025-10-26 17:16:11.012095+00	\N
144	1	7	2025-10-26	0	t		\N		2025-10-26 18:44:09.864709+00	\N
145	1	4	2025-10-26	0	f		98.00		2025-10-26 18:49:12.902526+00	\N
146	1	5	2025-10-26	0	t		\N		2025-10-26 19:56:23.836287+00	\N
147	1	5	2025-10-27	0	t		\N		2025-10-27 18:53:02.192693+00	\N
148	1	4	2025-10-27	0	f		53.00		2025-10-27 21:59:09.023631+00	\N
149	1	27	2025-10-27	0	t		\N		2025-10-27 23:31:20.259116+00	\N
150	1	28	2025-10-27	0	t		\N		2025-10-28 04:11:49.926314+00	\N
151	1	7	2025-10-27	0	t		\N		2025-10-28 04:13:40.162823+00	\N
152	1	4	2025-10-28	0	f		290.00		2025-10-28 13:06:47.560525+00	\N
153	1	27	2025-10-28	0	t		\N		2025-10-28 20:05:26.87653+00	\N
154	1	4	2025-10-29	0	f		265.00		2025-10-29 21:09:31.89038+00	\N
155	1	28	2025-10-29	0	t		\N		2025-10-30 14:58:31.877913+00	\N
174	1	4	2025-11-03	0	f		1320.00		2025-11-03 18:51:15.505747+00	\N
179	1	28	2025-11-04	0	t		\N		2025-11-05 00:26:30.864414+00	\N
156	1	23	2025-10-30	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-30T15:14:45.282732", "clock_out": "2025-10-30T17:42:40.106821", "duration_minutes": 147}, {"clock_in": "2025-10-30T19:42:09.209693", "clock_out": "2025-10-30T20:56:23.376132", "duration_minutes": 74}], "total_duration_minutes": 221, "last_updated": "2025-10-30T20:56:23.376132"}	\N	\N	2025-10-30 15:14:45.284321+00	\N
158	1	7	2025-10-31	0	t		\N		2025-10-31 13:51:42.020018+00	\N
159	1	4	2025-10-31	0	f		1610.00		2025-10-31 13:53:48.881664+00	\N
171	1	23	2025-11-03	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-03T14:38:31.957559", "clock_out": "2025-11-03T18:02:38.535078", "duration_minutes": 204}, {"clock_in": "2025-11-03T20:00:20.969655", "clock_out": "2025-11-03T22:26:29.469259", "duration_minutes": 146}], "total_duration_minutes": 350, "last_updated": "2025-11-03T22:26:29.469259"}	\N	\N	2025-11-03 14:38:31.957323+00	\N
175	1	7	2025-11-03	0	t		\N		2025-11-04 13:50:32.500639+00	\N
157	1	23	2025-10-31	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-10-31T13:51:33.608263", "clock_out": "2025-10-31T17:24:53.088575", "duration_minutes": 213}, {"clock_in": "2025-10-31T19:21:01.730261", "clock_out": "2025-10-31T21:33:18.537923", "duration_minutes": 132}], "total_duration_minutes": 345, "last_updated": "2025-10-31T21:33:18.537923"}	\N	\N	2025-10-31 13:51:33.611889+00	\N
160	1	27	2025-10-31	0	t		\N		2025-10-31 23:38:34.679765+00	\N
161	1	4	2025-11-01	0	f		1390.00		2025-11-01 15:57:39.12225+00	\N
162	1	27	2025-11-01	0	t		\N		2025-11-01 16:58:16.369917+00	\N
163	1	26	2025-10-31	0	t		\N		2025-11-01 16:59:09.824266+00	\N
164	1	27	2025-11-02	0	t		\N		2025-11-03 00:14:17.042367+00	\N
165	1	4	2025-11-02	0	f		1335.00		2025-11-03 00:14:47.56034+00	\N
166	1	26	2025-11-02	0	t		\N		2025-11-03 00:17:12.352889+00	\N
167	1	28	2025-11-02	0	t		\N		2025-11-03 01:32:58.338758+00	\N
168	1	7	2025-11-02	0	t		\N		2025-11-03 02:55:58.539167+00	\N
169	1	27	2025-11-03	0	t		\N		2025-11-03 14:11:59.055094+00	\N
170	1	31	2025-11-03	0	f		\N		2025-11-03 14:12:02.857391+00	\N
172	1	26	2025-11-03	0	t		\N		2025-11-03 14:38:42.374541+00	\N
185	1	27	2025-11-06	0	t		\N		2025-11-06 23:15:26.307699+00	\N
173	1	5	2025-11-03	0	t		\N		2025-11-03 18:50:43.524632+00	\N
177	1	4	2025-11-04	0	f		1358.00		2025-11-04 18:34:29.214594+00	\N
178	1	5	2025-11-04	0	t		\N		2025-11-04 19:32:09.158213+00	\N
180	1	23	2025-11-05	\N	\N	{"current_state": "clocked_in", "sessions": [{"clock_in": "2025-11-05T14:51:19.067599", "clock_out": "2025-11-05T18:37:45.113632", "duration_minutes": 226}], "total_duration_minutes": 226, "last_updated": "2025-11-05T20:25:35.606281"}	\N	\N	2025-11-05 14:51:19.053018+00	\N
176	1	23	2025-11-04	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-04T14:46:01.269882", "clock_out": "2025-11-04T18:32:34.398017", "duration_minutes": 226}, {"clock_in": "2025-11-04T20:24:04.697538", "clock_out": "2025-11-04T22:51:03.356571", "duration_minutes": 146}], "total_duration_minutes": 372, "last_updated": "2025-11-04T22:51:03.356571"}	\N	\N	2025-11-04 14:46:01.265059+00	\N
181	1	27	2025-11-05	0	t		\N		2025-11-06 13:22:41.691377+00	\N
186	1	26	2025-11-06	0	t		\N		2025-11-06 23:15:30.117067+00	\N
183	1	4	2025-11-06	0	f		1232.00		2025-11-06 19:01:07.862158+00	\N
184	1	5	2025-11-06	0	t		\N		2025-11-06 19:29:44.859614+00	\N
187	1	28	2025-11-06	0	t		\N		2025-11-07 01:34:09.800034+00	\N
182	1	23	2025-11-06	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-06T14:42:09.163194", "clock_out": "2025-11-06T18:10:39.985659", "duration_minutes": 208}, {"clock_in": "2025-11-06T20:11:02.828835", "clock_out": "2025-11-06T22:38:41.957014", "duration_minutes": 147}], "total_duration_minutes": 355, "last_updated": "2025-11-06T22:38:41.957014"}	\N	\N	2025-11-06 14:42:09.196197+00	\N
188	1	7	2025-11-06	0	t		\N		2025-11-07 05:19:05.544491+00	\N
190	1	27	2025-11-07	0	t		\N		2025-11-07 20:41:55.089885+00	\N
193	1	7	2025-11-08	0	t		\N		2025-11-08 18:52:43.257558+00	\N
191	1	28	2025-11-07	0	t		\N		2025-11-07 20:41:57.58391+00	\N
192	1	26	2025-11-07	0	t		\N		2025-11-07 20:41:58.467393+00	\N
189	1	23	2025-11-07	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-07T14:21:46.047618", "clock_out": "2025-11-07T18:27:15.656230", "duration_minutes": 245}, {"clock_in": "2025-11-07T20:17:59.611271", "clock_out": "2025-11-07T21:43:33.190084", "duration_minutes": 85}], "total_duration_minutes": 330, "last_updated": "2025-11-07T21:43:33.190084"}	\N	\N	2025-11-07 14:21:46.050161+00	\N
194	1	28	2025-11-09	0	t		\N		2025-11-09 16:13:14.618652+00	\N
195	1	32	2025-11-09	0	t		\N		2025-11-10 01:56:13.71129+00	\N
196	1	4	2025-11-10	0	f		400.00		2025-11-10 13:21:11.197373+00	\N
202	1	27	2025-11-11	0	t		\N		2025-11-12 00:43:44.05032+00	\N
198	1	5	2025-11-10	0	t		\N		2025-11-10 18:40:37.081001+00	\N
199	1	27	2025-11-10	0	t		\N		2025-11-10 18:40:37.381387+00	\N
205	1	23	2025-11-12	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-12T14:41:06.910073", "clock_out": "2025-11-12T18:34:36.316539", "duration_minutes": 233}, {"clock_in": "2025-11-12T20:03:35.195264", "clock_out": "2025-11-12T22:21:53.050478", "duration_minutes": 138}], "total_duration_minutes": 371, "last_updated": "2025-11-12T22:21:53.050478"}	\N	\N	2025-11-12 14:41:06.911936+00	\N
208	1	23	2025-11-13	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-13T15:21:38.681387", "clock_out": "2025-11-13T18:03:08.941633", "duration_minutes": 161}, {"clock_in": "2025-11-13T19:18:24.270563", "clock_out": "2025-11-13T22:33:37.614676", "duration_minutes": 195}], "total_duration_minutes": 356, "last_updated": "2025-11-13T22:33:37.614676"}	\N	\N	2025-11-13 15:21:38.684477+00	\N
197	1	23	2025-11-10	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-10T14:40:01.748783", "clock_out": "2025-11-10T17:55:08.648825", "duration_minutes": 195}, {"clock_in": "2025-11-10T19:34:51.259165", "clock_out": "2025-11-10T20:03:18.219519", "duration_minutes": 28}, {"clock_in": "2025-11-10T20:03:19.584613", "clock_out": "2025-11-10T20:03:20.776579", "duration_minutes": 0}, {"clock_in": "2025-11-10T20:19:20.846285", "clock_out": "2025-11-10T22:30:43.687276", "duration_minutes": 131}], "total_duration_minutes": 354, "last_updated": "2025-11-10T22:30:43.687276"}	\N	\N	2025-11-10 14:40:01.747883+00	\N
209	1	27	2025-11-13	0	t		\N		2025-11-14 00:23:43.144856+00	\N
211	1	4	2025-11-13	0	f		-700.00		2025-11-14 01:03:53.49567+00	\N
212	1	7	2025-11-13	0	t		\N		2025-11-14 01:41:47.150889+00	\N
201	1	4	2025-11-11	0	f		365.00		2025-11-11 20:31:21.874114+00	\N
200	1	23	2025-11-11	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-11T14:43:56.915361", "clock_out": "2025-11-11T14:43:57.475796", "duration_minutes": 0}, {"clock_in": "2025-11-11T14:43:58.198456", "clock_out": "2025-11-11T20:01:05.570778", "duration_minutes": 317}, {"clock_in": "2025-11-11T20:01:07.628136", "clock_out": "2025-11-11T21:56:44.523724", "duration_minutes": 115}, {"clock_in": "2025-11-11T21:56:48.214633", "clock_out": "2025-11-11T22:27:29.379643", "duration_minutes": 30}], "total_duration_minutes": 462, "last_updated": "2025-11-11T22:27:29.379643"}	\N	\N	2025-11-11 14:43:56.915504+00	\N
203	1	28	2025-11-11	0	t		\N		2025-11-12 03:32:38.441617+00	\N
204	1	7	2025-11-11	0	t		\N		2025-11-12 03:32:40.399603+00	\N
206	1	27	2025-11-12	0	t		\N		2025-11-12 22:53:39.462125+00	\N
207	1	4	2025-11-12	0	f		-500.00		2025-11-12 22:54:32.004374+00	\N
210	1	28	2025-11-13	0	t		\N		2025-11-14 00:23:44.878+00	\N
214	1	4	2025-11-14	0	f		0.00		2025-11-14 14:32:30.531279+00	\N
213	1	23	2025-11-14	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-14T14:25:19.216926", "clock_out": "2025-11-14T18:07:05.234113", "duration_minutes": 221}, {"clock_in": "2025-11-14T19:37:46.509677", "clock_out": "2025-11-14T22:29:15.985959", "duration_minutes": 171}], "total_duration_minutes": 392, "last_updated": "2025-11-14T22:29:15.985959"}	\N	\N	2025-11-14 14:25:19.218578+00	\N
215	1	27	2025-11-14	0	t		\N		2025-11-15 00:14:46.945706+00	\N
216	1	28	2025-11-14	0	t		\N		2025-11-15 00:14:49.484473+00	\N
217	1	7	2025-11-15	0	t		\N		2025-11-15 18:08:40.510351+00	\N
219	1	4	2025-11-15	0	f		-200.00		2025-11-15 21:57:02.446296+00	\N
218	1	23	2025-11-15	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-15T21:04:23.222491", "clock_out": "2025-11-16T00:00:00", "duration_minutes": 175}], "total_duration_minutes": 175, "last_updated": "2025-11-16T00:56:53.920542"}	\N	\N	2025-11-15 21:04:23.223499+00	\N
220	1	23	2025-11-16	\N	\N	{"sessions": [{"clock_in": "2025-11-16T15:05:00", "clock_out": "2025-11-16T18:20:00", "duration_minutes": 195}], "last_updated": "2025-11-16T18:20:00", "current_state": "clocked_out", "total_duration_minutes": 195}	\N	\N	2025-11-16 00:56:53.976394+00	\N
221	1	28	2025-11-15	0	t		\N		2025-11-16 01:01:37.708484+00	\N
222	1	27	2025-11-15	0	t		\N		2025-11-16 01:54:00.669475+00	\N
223	1	26	2025-11-15	0	t		\N		2025-11-16 03:59:32.416107+00	\N
224	1	4	2025-11-16	0	f		-470.00		2025-11-16 22:28:44.967263+00	\N
225	1	27	2025-11-16	0	t		\N		2025-11-17 01:45:16.468159+00	\N
226	1	7	2025-11-16	0	f		\N		2025-11-17 01:45:19.005292+00	\N
227	1	26	2025-11-16	0	t		\N		2025-11-17 01:45:22.427723+00	\N
228	1	28	2025-11-16	0	t		\N		2025-11-17 03:31:30.655967+00	\N
230	1	4	2025-11-17	0	f		-500.00		2025-11-17 16:35:59.588722+00	\N
247	1	33	2025-11-21	0	f	had to repush my pr from yesterday. it is live and working. Spent a few mins practicing the absolute basics of git branching and merging https://github.com/skills/resolve-merge-conflicts . fixed the switch camera button in staff app and used cloudflare to test locally on my phone. I had to disable the login system and have it always use a specific account. created a new branch where i added calulations for lsast trip assigned setup account creation date and improved the sort on the editor list	\N		2025-11-21 19:21:43.909593+00	\N
231	1	28	2025-11-17	0	t		\N		2025-11-17 19:35:51.452615+00	\N
232	1	27	2025-11-17	0	t		\N		2025-11-17 19:42:36.417162+00	\N
240	1	33	2025-11-19	0	f	I spent basially the entire day working on merging chagnes from yesterday. after mergin main into my feature branch and effectivly removing all of the features i scrapped the merge and had cursor remerge. added a little more functionality and attempted to merge again. did a little ui work. I need to master bootstrap and git. but I also need to stop relying on ai so much in general. the quesdtion is what is the biggest priority, propably git. ui would be nice too but is the least important. nodejs or overall improved dev skillsd that got me away from ai a bit would also be good. Also I need to start pring in smaller chunks when possible 	\N		2025-11-19 22:17:23.608009+00	\N
229	1	23	2025-11-17	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-17T15:16:29.506180", "clock_out": "2025-11-17T18:38:54.967812", "duration_minutes": 202}, {"clock_in": "2025-11-17T19:52:43.400321", "clock_out": "2025-11-17T22:45:57.382703", "duration_minutes": 173}], "total_duration_minutes": 375, "last_updated": "2025-11-17T22:45:57.382703"}	\N	\N	2025-11-17 15:16:29.510125+00	\N
234	1	27	2025-11-18	0	t		\N		2025-11-18 14:23:01.035242+00	\N
235	1	4	2025-11-18	0	f		300.00		2025-11-18 14:28:56.327359+00	\N
233	1	23	2025-11-18	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-18T14:13:46.061579", "clock_out": "2025-11-18T18:10:56.283290", "duration_minutes": 237}], "total_duration_minutes": 237, "last_updated": "2025-11-18T18:10:56.283290"}	\N	\N	2025-11-18 14:13:46.066774+00	\N
236	1	7	2025-11-18	0	t		\N		2025-11-18 19:28:56.718736+00	\N
237	1	23	2025-11-19	\N	\N	{"sessions": [{"clock_in": "2025-11-19T19:20:00", "clock_out": "2025-11-19T23:50:00", "duration_minutes": 270}, {"clock_in": "2025-11-19T14:55:48.840115", "clock_out": "2025-11-19T18:31:04.024007", "duration_minutes": 215}, {"clock_in": "2025-11-19T20:42:21.051723", "clock_out": "2025-11-19T22:23:26.534431", "duration_minutes": 101}], "last_updated": "2025-11-19T22:23:26.534431", "current_state": "clocked_out", "total_duration_minutes": 586}	\N	 | +4.5h late evening (manual)	2025-11-19 14:40:50.620106+00	\N
241	1	4	2025-11-20	0	f		40.00		2025-11-20 14:37:32.520594+00	\N
239	1	27	2025-11-19	0	t		\N		2025-11-19 14:56:07.863485+00	\N
248	1	12	2025-11-21	0	t		\N		2025-11-21 19:53:05.530306+00	\N
249	1	12	2025-11-19	0	t		\N		2025-11-21 19:53:20.417419+00	\N
243	1	33	2025-11-20	0	f	Spent the morning repairing functionality broken in yesterdays last merge. Finally put in a pr and sent keen migrations at noon today. I need to stop using ai so much. put less stuff per branch, and get a lot better with git.	\N		2025-11-20 16:51:17.323639+00	\N
242	1	23	2025-11-20	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-20T14:47:10.516884", "clock_out": "2025-11-20T20:22:32.274231", "duration_minutes": 335}], "total_duration_minutes": 335, "last_updated": "2025-11-20T20:22:32.274231"}	\N	\N	2025-11-20 14:47:10.520745+00	\N
244	1	7	2025-11-20	0	t		\N		2025-11-21 00:22:34.758886+00	\N
245	1	4	2025-11-21	0	f		-250.00		2025-11-21 14:48:36.346002+00	\N
253	1	4	2025-11-22	0	f		-200.00		2025-11-22 22:35:33.896286+00	\N
251	1	27	2025-11-22	0	t		\N		2025-11-22 22:35:02.802622+00	\N
250	1	7	2025-11-21	0	t		\N		2025-11-21 19:53:32.915885+00	\N
246	1	23	2025-11-21	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-21T15:20:16.665698", "clock_out": "2025-11-21T18:01:06.471081", "duration_minutes": 160}, {"clock_in": "2025-11-21T19:14:44.668806", "clock_out": "2025-11-21T21:13:46.139294", "duration_minutes": 119}], "total_duration_minutes": 279, "last_updated": "2025-11-21T21:13:46.139294"}	\N	\N	2025-11-21 15:20:16.667508+00	\N
252	1	26	2025-11-22	0	t		\N		2025-11-22 22:35:05.720542+00	\N
254	1	7	2025-11-22	0	t		\N		2025-11-22 22:36:36.917582+00	\N
257	1	5	2025-11-23	0	f		\N		2025-11-24 00:08:29.959731+00	\N
256	1	35	2025-11-23	0	f		5.00		2025-11-24 00:07:58.576148+00	\N
255	1	4	2025-11-23	0	f		-270.00		2025-11-23 20:42:04.657324+00	\N
258	1	27	2025-11-23	0	t		\N		2025-11-24 03:03:54.372399+00	\N
259	1	7	2025-11-23	0	t		\N		2025-11-24 03:03:58.982594+00	\N
261	1	33	2025-11-24	0	f	Created a repo to practice for then created and resolved a php merge issue. Read through Keenan’s weekend bug fixes. Added last week to operations portal. 	\N		2025-11-24 16:54:46.908379+00	\N
262	1	4	2025-11-24	0	f		-320.00		2025-11-24 17:09:12.243876+00	\N
392	1	45	2025-12-29	0	t		\N		2025-12-29 20:03:49.105074+00	\N
263	1	28	2025-11-24	0	t		\N		2025-11-24 18:49:54.754057+00	\N
260	1	23	2025-11-24	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-24T14:41:35.310247", "clock_out": "2025-11-24T18:12:02.595753", "duration_minutes": 210}, {"clock_in": "2025-11-24T19:31:58.512920", "clock_out": "2025-11-24T21:58:51.727764", "duration_minutes": 146}], "total_duration_minutes": 356, "last_updated": "2025-11-24T21:58:51.727764"}	\N	\N	2025-11-24 14:41:35.313014+00	\N
264	1	35	2025-11-24	0	f		10.00		2025-11-25 01:41:20.028107+00	\N
287	1	45	2025-12-01	0	t		\N		2025-12-02 03:28:53.798272+00	\N
288	1	41	2025-12-01	0	f		\N		2025-12-02 03:29:11.266278+00	\N
265	1	23	2025-11-25	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-25T14:35:45.795784", "clock_out": "2025-11-25T18:28:37.412591", "duration_minutes": 232}, {"clock_in": "2025-11-25T21:11:36.447391", "clock_out": "2025-11-25T23:28:16.492791", "duration_minutes": 136}], "total_duration_minutes": 368, "last_updated": "2025-11-25T23:28:16.492791"}	\N	\N	2025-11-25 14:35:45.799872+00	\N
266	1	4	2025-11-25	0	f		-270.00		2025-11-26 02:51:19.254118+00	\N
267	1	27	2025-11-25	0	t		\N		2025-11-26 04:36:04.695621+00	\N
269	1	7	2025-11-25	0	t		\N		2025-11-26 18:38:33.702402+00	\N
270	1	27	2025-11-26	0	t		\N		2025-11-26 19:37:25.710191+00	\N
271	1	7	2025-11-26	0	t		\N		2025-11-26 19:37:28.119863+00	\N
290	1	43	2025-12-02	0	t		\N		2025-12-02 15:44:44.737693+00	\N
268	1	23	2025-11-26	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-26T14:55:57.722070", "clock_out": "2025-11-26T18:37:34.580347", "duration_minutes": 221}, {"clock_in": "2025-11-26T20:12:53.917726", "clock_out": "2025-11-26T21:54:49.856975", "duration_minutes": 101}], "total_duration_minutes": 322, "last_updated": "2025-11-26T21:54:49.856975"}	\N	\N	2025-11-26 14:55:57.723067+00	\N
272	1	7	2025-11-27	0	t		\N		2025-11-28 14:38:53.794073+00	\N
291	1	42	2025-12-02	0	t		\N		2025-12-02 15:44:46.738411+00	\N
273	1	23	2025-11-28	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-28T14:48:17.685077", "clock_out": "2025-11-28T17:34:45.884354", "duration_minutes": 166}, {"clock_in": "2025-11-28T19:47:28.103615", "clock_out": "2025-11-28T22:12:14.401238", "duration_minutes": 144}], "total_duration_minutes": 310, "last_updated": "2025-11-28T22:12:14.401238"}	\N	\N	2025-11-28 14:48:17.686532+00	\N
274	1	12	2025-11-29	0	t		\N		2025-11-30 15:39:10.788011+00	\N
306	1	7	2025-12-04	0	t		\N		2025-12-04 21:46:32.42431+00	\N
275	1	28	2025-11-30	0	t		\N		2025-11-30 16:24:06.666424+00	\N
276	1	12	2025-11-30	0	t		\N		2025-11-30 19:20:35.411971+00	\N
289	1	23	2025-12-02	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-02T15:02:16.446363", "clock_out": "2025-12-02T17:31:40.162054", "duration_minutes": 149}, {"clock_in": "2025-12-02T20:20:33.287029", "clock_out": "2025-12-02T21:56:43.812764", "duration_minutes": 96}], "total_duration_minutes": 245, "last_updated": "2025-12-02T21:56:43.812764"}	\N	\N	2025-12-02 15:02:16.448812+00	\N
292	1	45	2025-12-02	0	t		\N		2025-12-02 22:43:04.912028+00	\N
293	1	41	2025-12-02	0	f		\N		2025-12-02 22:49:20.866533+00	\N
294	1	7	2025-12-02	0	t		\N		2025-12-02 23:52:32.846328+00	\N
277	1	4	2025-11-30	0	f		-1170.00		2025-11-30 21:50:02.341946+00	\N
278	1	7	2025-11-30	0	t		\N		2025-12-01 03:01:21.014294+00	\N
280	1	43	2025-12-01	0	t		\N		2025-12-01 17:17:59.385795+00	\N
281	1	42	2025-12-01	0	t		\N		2025-12-01 17:18:01.216913+00	\N
282	1	12	2025-12-01	0	t		\N		2025-12-01 17:18:12.891399+00	\N
295	1	12	2025-12-02	0	t		\N		2025-12-02 23:52:39.704113+00	\N
283	1	44	2025-12-01	0	t		\N		2025-12-01 20:03:01.746705+00	\N
296	1	28	2025-12-02	0	t		\N		2025-12-03 01:09:00.069095+00	\N
279	1	23	2025-12-01	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-01T14:38:52.405955", "clock_out": "2025-12-01T18:32:51.687055", "duration_minutes": 233}, {"clock_in": "2025-12-01T20:07:39.398651", "clock_out": "2025-12-01T22:47:15.534537", "duration_minutes": 159}], "total_duration_minutes": 392, "last_updated": "2025-12-01T22:47:15.534537"}	\N	\N	2025-12-01 14:38:52.409317+00	\N
284	1	7	2025-12-01	0	t		\N		2025-12-02 02:26:42.904653+00	\N
285	1	28	2025-12-01	0	t		\N		2025-12-02 03:15:07.857936+00	\N
286	1	30	2025-12-01	0	t		\N		2025-12-02 03:27:51.630975+00	\N
298	1	43	2025-12-03	0	t		\N		2025-12-03 15:17:36.662076+00	\N
299	1	42	2025-12-03	0	t		\N		2025-12-03 15:17:38.267562+00	\N
308	1	12	2025-12-05	0	t		\N		2025-12-05 16:09:27.571266+00	\N
300	1	12	2025-12-03	0	t		\N		2025-12-03 18:52:53.749277+00	\N
301	1	45	2025-12-03	0	t		\N		2025-12-03 18:53:00.586944+00	\N
307	1	23	2025-12-05	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-05T15:18:10.169266", "clock_out": "2025-12-05T18:22:02.792699", "duration_minutes": 183}, {"clock_in": "2025-12-05T20:36:39.418200", "clock_out": "2025-12-05T22:47:27.732643", "duration_minutes": 130}, {"clock_in": "2025-12-05T22:47:33.886736", "clock_out": "2025-12-05T23:00:34.028793", "duration_minutes": 13}], "total_duration_minutes": 326, "last_updated": "2025-12-05T23:00:34.028793"}	\N	\N	2025-12-05 15:18:10.171286+00	\N
297	1	23	2025-12-03	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-03T14:40:58.300501", "clock_out": "2025-12-03T18:27:34.436682", "duration_minutes": 226}, {"clock_in": "2025-12-03T20:20:36.237352", "clock_out": "2025-12-03T22:46:10.117449", "duration_minutes": 145}], "total_duration_minutes": 371, "last_updated": "2025-12-03T22:46:10.117449"}	\N	\N	2025-12-03 14:40:58.303322+00	\N
302	1	40	2025-12-03	0	t		\N		2025-12-03 23:10:51.486118+00	\N
303	1	27	2025-12-03	0	t		\N		2025-12-03 23:10:53.906107+00	\N
304	1	7	2025-12-03	0	t		\N		2025-12-04 04:23:56.418039+00	\N
309	1	7	2025-12-05	0	t		\N		2025-12-06 19:02:21.412804+00	\N
305	1	23	2025-12-04	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-04T15:13:13.187060", "clock_out": "2025-12-04T17:50:56.213661", "duration_minutes": 157}, {"clock_in": "2025-12-04T19:00:28.379878", "clock_out": "2025-12-04T22:20:41.188996", "duration_minutes": 200}, {"clock_in": "2025-12-04T22:20:49.142969", "clock_out": "2025-12-04T23:08:50.078997", "duration_minutes": 48}], "total_duration_minutes": 405, "last_updated": "2025-12-04T23:08:50.078997"}	\N	\N	2025-12-04 15:13:13.18881+00	\N
310	1	28	2025-12-06	0	t		\N		2025-12-06 19:02:52.104993+00	\N
313	1	4	2025-12-07	0	f		-400.00		2025-12-07 17:13:12.859799+00	\N
311	1	7	2025-12-06	0	t		\N		2025-12-06 20:42:48.33902+00	\N
312	1	23	2025-12-06	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-06T20:56:43.624088", "clock_out": "2025-12-06T22:40:18.420288", "duration_minutes": 103}], "total_duration_minutes": 103, "last_updated": "2025-12-06T22:40:18.420288"}	\N	\N	2025-12-06 20:56:43.62606+00	\N
314	1	7	2025-12-07	0	t		\N		2025-12-07 17:36:15.607975+00	\N
315	1	27	2025-12-07	0	t		\N		2025-12-07 17:36:19.879589+00	\N
316	1	12	2025-12-06	0	t		\N		2025-12-07 17:39:29.927331+00	\N
317	1	12	2025-12-07	0	t		\N		2025-12-07 17:48:31.278016+00	\N
318	1	44	2025-12-07	0	t		\N		2025-12-07 17:55:32.9785+00	\N
319	1	26	2025-12-07	0	t		\N		2025-12-07 20:56:20.819005+00	\N
320	1	28	2025-12-07	0	t		\N		2025-12-07 22:43:32.530067+00	\N
321	4	51	2025-12-08	0	t		\N		2025-12-08 00:22:23.338415+00	\N
323	1	28	2025-12-08	0	t		\N		2025-12-08 20:13:33.708875+00	\N
393	1	7	2025-12-29	0	t		\N		2025-12-29 23:46:06.849364+00	\N
361	1	7	2025-12-15	0	t		\N		2025-12-16 16:35:40.160854+00	\N
322	1	23	2025-12-08	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-08T16:19:09.914101", "clock_out": "2025-12-08T21:17:08.989144", "duration_minutes": 297}, {"clock_in": "2025-12-08T21:17:09.572538", "clock_out": "2025-12-08T22:18:42.977984", "duration_minutes": 61}], "total_duration_minutes": 358, "last_updated": "2025-12-08T22:18:42.977984"}	\N	\N	2025-12-08 16:19:09.916803+00	\N
324	1	12	2025-12-08	0	t		\N		2025-12-09 02:54:29.162328+00	\N
325	1	30	2025-12-08	0	f		\N		2025-12-09 02:54:31.267399+00	\N
326	1	27	2025-12-08	0	t		\N		2025-12-09 02:54:37.907196+00	\N
327	1	45	2025-12-08	0	t		\N		2025-12-09 04:17:08.5124+00	\N
328	1	44	2025-12-08	0	t		\N		2025-12-09 04:19:45.256458+00	\N
329	1	7	2025-12-08	0	t		\N		2025-12-09 04:41:12.091199+00	\N
360	1	23	2025-12-16	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-16T15:40:48.277507", "clock_out": "2025-12-16T20:42:46.886008", "duration_minutes": 301}], "total_duration_minutes": 301, "last_updated": "2025-12-16T20:42:46.886008"}	\N	\N	2025-12-16 15:40:48.279707+00	\N
362	1	44	2025-12-16	0	t		\N		2025-12-16 21:22:41.923346+00	\N
330	1	23	2025-12-09	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-09T14:44:52.187185", "clock_out": "2025-12-09T18:42:11.907384", "duration_minutes": 237}, {"clock_in": "2025-12-09T20:24:23.897466", "clock_out": "2025-12-09T22:34:49.395198", "duration_minutes": 130}], "total_duration_minutes": 367, "last_updated": "2025-12-09T22:34:49.395198"}	\N	\N	2025-12-09 14:44:52.186907+00	\N
331	1	44	2025-12-09	0	t		\N		2025-12-09 23:37:00.32706+00	\N
332	6	52	2025-12-09	0	t		\N		2025-12-09 23:43:32.092059+00	\N
333	1	7	2025-12-09	0	t		\N		2025-12-10 06:11:47.881322+00	\N
335	1	4	2025-12-10	0	f		-841.00		2025-12-10 14:59:22.49969+00	\N
336	1	12	2025-12-10	0	t		\N		2025-12-10 17:59:36.965209+00	\N
363	1	40	2025-12-16	0	t		\N		2025-12-16 21:38:41.352961+00	\N
337	1	7	2025-12-10	0	t		\N		2025-12-10 18:16:18.566884+00	\N
338	1	44	2025-12-10	0	t		\N		2025-12-10 19:12:44.173747+00	\N
364	1	4	2025-12-16	0	f		-900.00		2025-12-16 21:39:58.940822+00	\N
334	1	23	2025-12-10	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-10T14:30:32.295967", "clock_out": "2025-12-10T18:02:32.237195", "duration_minutes": 211}, {"clock_in": "2025-12-10T19:38:55.681370", "clock_out": "2025-12-10T22:02:12.115374", "duration_minutes": 143}], "total_duration_minutes": 354, "last_updated": "2025-12-10T22:02:12.115374"}	\N	\N	2025-12-10 14:30:32.297928+00	\N
340	1	4	2025-12-11	0	f		-200.00		2025-12-11 15:55:46.055204+00	\N
341	1	12	2025-12-11	0	t		\N		2025-12-11 16:33:05.173493+00	\N
342	1	7	2025-12-11	0	t		\N		2025-12-11 18:35:40.602936+00	\N
369	1	44	2025-12-19	0	f		\N		2025-12-19 11:28:26.001273+00	\N
343	1	44	2025-12-11	0	t		\N		2025-12-12 00:27:04.90083+00	\N
344	1	28	2025-12-11	0	t		\N		2025-12-12 00:37:30.706077+00	\N
339	1	23	2025-12-11	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-11T15:10:43.355343", "clock_out": "2025-12-11T17:57:18.598552", "duration_minutes": 166}, {"clock_in": "2025-12-11T21:40:31.650328", "clock_out": "2025-12-12T00:00:00", "duration_minutes": 139}], "total_duration_minutes": 305, "last_updated": "2025-12-12T00:37:33.127696"}	\N	\N	2025-12-11 15:10:43.359143+00	\N
345	1	23	2025-12-12	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-12T00:00:00", "clock_out": "2025-12-12T00:37:33.127696", "duration_minutes": 37}], "total_duration_minutes": 37, "last_updated": "2025-12-12T00:37:33.127696"}	\N	\N	2025-12-12 00:37:33.130665+00	\N
346	1	50	2025-12-11	0	t		\N		2025-12-12 00:41:05.278406+00	\N
347	1	27	2025-12-11	0	t		\N		2025-12-12 01:37:34.476455+00	\N
348	1	50	2025-12-12	0	t		\N		2025-12-12 15:05:11.41906+00	\N
349	1	40	2025-12-12	0	t		\N		2025-12-12 16:35:06.937397+00	\N
350	1	12	2025-12-12	0	t		\N		2025-12-12 16:35:09.387263+00	\N
351	1	44	2025-12-12	0	t		\N		2025-12-12 16:58:42.779408+00	\N
352	1	7	2025-12-12	0	t		\N		2025-12-12 22:57:24.465156+00	\N
353	1	50	2025-12-13	0	t		\N		2025-12-13 17:25:44.912033+00	\N
354	1	7	2025-12-13	0	t		\N		2025-12-13 18:30:58.902637+00	\N
355	1	50	2025-12-14	0	t		\N		2025-12-14 06:02:04.815625+00	\N
356	1	7	2025-12-14	0	t		\N		2025-12-14 20:36:24.662256+00	\N
357	1	4	2025-12-15	0	f		-1100.00		2025-12-15 23:56:49.35101+00	\N
358	1	44	2025-12-15	0	t		\N		2025-12-16 00:12:58.474645+00	\N
359	1	12	2025-12-15	0	t		\N		2025-12-16 00:17:43.190994+00	\N
370	1	7	2025-12-18	0	t		\N		2025-12-19 12:27:41.356743+00	\N
365	1	23	2025-12-17	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-17T17:26:38.518415", "clock_out": "2025-12-17T21:52:53.409211", "duration_minutes": 266}, {"clock_in": "2025-12-17T21:52:54.046607", "clock_out": "2025-12-17T21:52:54.831947", "duration_minutes": 0}], "total_duration_minutes": 266, "last_updated": "2025-12-17T21:52:54.831947"}	\N	\N	2025-12-17 17:26:38.521548+00	\N
366	1	7	2025-12-17	0	t		\N		2025-12-18 04:03:48.923863+00	\N
368	1	4	2025-12-18	0	f		-400.00		2025-12-18 18:10:04.134764+00	\N
371	1	50	2025-12-19	0	t		\N		2025-12-19 19:27:25.770594+00	\N
372	1	50	2025-12-20	0	t		\N		2025-12-20 15:43:37.530293+00	\N
367	1	23	2025-12-18	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-18T15:38:31.400402", "clock_out": "2025-12-18T19:35:53.617441", "duration_minutes": 237}, {"clock_in": "2025-12-18T21:31:38.262059", "clock_out": "2025-12-18T21:53:49.753909", "duration_minutes": 22}], "total_duration_minutes": 259, "last_updated": "2025-12-18T21:53:49.753909"}	\N	\N	2025-12-18 15:38:31.403062+00	\N
373	1	7	2025-12-20	0	t		\N		2025-12-20 23:39:54.573701+00	\N
374	1	28	2025-12-20	0	t		\N		2025-12-20 23:40:53.190387+00	\N
375	1	12	2025-12-20	0	t		\N		2025-12-21 00:10:24.760344+00	\N
376	1	50	2025-12-21	0	t		\N		2025-12-21 20:28:16.21549+00	\N
377	1	7	2025-12-21	0	t		\N		2025-12-21 20:28:24.516281+00	\N
380	1	44	2025-12-23	0	t		\N		2025-12-23 21:13:44.510074+00	\N
378	1	23	2025-12-22	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-22T14:44:58.772720", "clock_out": "2025-12-22T17:33:26.026927", "duration_minutes": 168}, {"clock_in": "2025-12-22T19:07:04.324260", "clock_out": "2025-12-22T22:10:13.142061", "duration_minutes": 183}], "total_duration_minutes": 351, "last_updated": "2025-12-22T22:10:13.142061"}	\N	\N	2025-12-22 14:44:58.775342+00	\N
379	1	23	2025-12-23	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-23T14:40:14.006722", "clock_out": "2025-12-23T17:58:48.162089", "duration_minutes": 198}, {"clock_in": "2025-12-23T20:33:24.591509", "clock_out": "2025-12-23T21:49:24.847642", "duration_minutes": 76}], "total_duration_minutes": 274, "last_updated": "2025-12-23T21:49:24.847642"}	\N	\N	2025-12-23 14:40:14.00977+00	\N
383	1	28	2025-12-24	0	f		\N		2025-12-24 16:00:39.441956+00	\N
381	1	23	2025-12-24	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-24T15:03:25.753426", "clock_out": "2025-12-24T16:58:26.662155", "duration_minutes": 115}], "total_duration_minutes": 115, "last_updated": "2025-12-24T16:58:26.662155"}	\N	\N	2025-12-24 15:03:25.755649+00	\N
382	1	7	2025-12-24	0	f		\N		2025-12-24 16:00:34.55199+00	\N
384	1	27	2025-12-25	0	f		\N		2025-12-25 20:58:49.7805+00	\N
385	1	44	2025-12-25	0	f		\N		2025-12-25 20:58:51.293693+00	\N
386	1	7	2025-12-25	0	f		\N		2025-12-25 20:58:54.854146+00	\N
387	1	12	2025-12-25	0	f		\N		2025-12-25 20:58:55.355326+00	\N
388	1	7	2025-12-28	0	t		\N		2025-12-29 02:16:07.212382+00	\N
390	1	44	2025-12-29	0	t		\N		2025-12-29 16:17:33.855334+00	\N
391	1	60	2025-12-29	0	t		\N		2025-12-29 16:26:55.298003+00	\N
394	1	60	2025-12-30	0	t		\N		2025-12-30 11:42:06.328447+00	\N
401	1	60	2025-12-31	0	t		\N		2025-12-31 17:50:36.091871+00	\N
412	1	12	2026-01-04	0	t		\N		2026-01-04 17:14:09.476173+00	\N
402	1	27	2025-12-31	0	t		\N		2025-12-31 18:29:13.471457+00	\N
403	1	7	2025-12-31	0	t		\N		2025-12-31 20:00:14.841206+00	\N
404	1	12	2025-12-31	0	t		\N		2025-12-31 22:07:33.784964+00	\N
389	1	23	2025-12-29	\N	\N	{"sessions": [{"clock_in": "2025-12-29T14:45:51.831497", "clock_out": "2025-12-29T20:10:00", "duration_minutes": 324}], "last_updated": "2025-12-29T23:46:09.225375", "current_state": "clocked_out", "total_duration_minutes": 324}	\N	\N	2025-12-29 14:45:51.833479+00	\N
400	1	23	2025-12-31	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-12-31T14:39:48.760837", "clock_out": "2025-12-31T17:47:25.573326", "duration_minutes": 187}, {"clock_in": "2025-12-31T17:47:26.872652", "clock_out": "2025-12-31T18:15:26.305778", "duration_minutes": 27}, {"clock_in": "2025-12-31T20:00:15.826097", "clock_out": "2025-12-31T22:20:22.435888", "duration_minutes": 140}], "total_duration_minutes": 354, "last_updated": "2025-12-31T22:20:22.435888"}	\N	\N	2025-12-31 14:39:48.762488+00	\N
406	1	7	2026-01-01	0	t		\N		2026-01-01 19:39:05.748968+00	\N
405	1	23	2026-01-01	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-01T19:18:11.972508", "clock_out": "2026-01-01T22:17:23.439090", "duration_minutes": 179}], "total_duration_minutes": 179, "last_updated": "2026-01-01T22:17:23.439090"}	\N	\N	2026-01-01 19:18:11.974078+00	\N
407	1	60	2026-01-01	0	t		\N		2026-01-01 22:27:50.97529+00	\N
408	1	28	2026-01-02	0	t		\N		2026-01-02 15:35:54.993747+00	\N
395	1	23	2025-12-30	\N	\N	{"sessions": [{"clock_in": "2025-12-30T14:25:15.164853", "clock_out": "2025-12-30T14:33:17.596958", "duration_minutes": 8}, {"clock_in": "2025-12-30T14:33:25.055544", "clock_out": "2025-12-30T14:41:34.245507", "duration_minutes": 8}, {"clock_in": "2025-12-30T14:41:35.573339", "clock_out": "2025-12-30T14:42:09.756459", "duration_minutes": 0}, {"clock_in": "2025-12-30T14:42:10.552556", "clock_out": "2025-12-30T18:22:25.282926", "duration_minutes": 220}, {"clock_in": "2025-12-30T20:32:45.709995", "clock_out": "2025-12-30T23:17:57.842751", "duration_minutes": 165}], "last_updated": "2025-12-30T23:17:57.842751", "current_state": "clocked_out", "total_duration_minutes": 401}	\N	\N	2025-12-30 14:25:15.167723+00	\N
396	1	44	2025-12-30	0	t		\N		2025-12-31 00:47:31.382038+00	\N
397	1	62	2025-12-30	0	t		\N		2025-12-31 00:47:33.246288+00	\N
398	1	27	2025-12-30	0	t		\N		2025-12-31 00:47:35.028747+00	\N
399	1	7	2025-12-30	0	t		\N		2025-12-31 03:18:00.948939+00	\N
414	1	60	2026-01-04	0	t		\N		2026-01-04 19:21:55.952844+00	\N
409	1	60	2026-01-02	0	t		\N		2026-01-02 15:35:57.727647+00	\N
413	1	23	2026-01-04	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-04T18:15:22.758933", "clock_out": "2026-01-04T19:56:23.051333", "duration_minutes": 101}, {"clock_in": "2026-01-04T19:56:23.991851", "clock_out": "2026-01-04T22:20:42.885747", "duration_minutes": 144}, {"clock_in": "2026-01-04T22:20:43.530794", "clock_out": "2026-01-04T22:31:10.786331", "duration_minutes": 10}, {"clock_in": "2026-01-04T22:31:11.860912", "clock_out": "2026-01-04T23:21:20.972199", "duration_minutes": 50}, {"clock_in": "2026-01-04T23:21:22.163519", "clock_out": "2026-01-04T23:39:20.179955", "duration_minutes": 17}], "total_duration_minutes": 322, "last_updated": "2026-01-04T23:39:20.179955"}	\N	\N	2026-01-04 18:15:22.761408+00	\N
415	1	44	2026-01-04	0	t		\N		2026-01-05 00:27:19.707794+00	\N
411	1	12	2026-01-02	0	t		\N		2026-01-02 19:18:42.095865+00	\N
416	1	27	2026-01-04	0	t		\N		2026-01-05 01:57:08.145901+00	\N
417	1	7	2026-01-04	0	t		\N		2026-01-05 02:10:34.244625+00	\N
418	1	23	2026-01-05	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-05T14:40:08.910422", "clock_out": "2026-01-05T18:07:16.158670", "duration_minutes": 207}, {"clock_in": "2026-01-05T18:46:44.968084", "clock_out": "2026-01-05T20:28:46.788067", "duration_minutes": 102}, {"clock_in": "2026-01-05T20:28:47.573592", "clock_out": "2026-01-05T21:51:00.053013", "duration_minutes": 82}, {"clock_in": "2026-01-05T21:51:08.338927", "clock_out": "2026-01-05T22:06:06.406139", "duration_minutes": 14}, {"clock_in": "2026-01-05T22:06:07.246687", "clock_out": "2026-01-05T22:37:21.255448", "duration_minutes": 31}, {"clock_in": "2026-01-05T22:37:21.950951", "clock_out": "2026-01-05T22:42:32.817840", "duration_minutes": 5}], "total_duration_minutes": 441, "last_updated": "2026-01-05T22:42:32.817840"}	\N	\N	2026-01-05 14:40:08.913705+00	\N
410	1	23	2026-01-02	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-02T16:32:01.958322", "clock_out": "2026-01-02T18:07:40.039818", "duration_minutes": 95}, {"clock_in": "2026-01-02T18:17:05.193194", "clock_out": "2026-01-02T21:27:37.870025", "duration_minutes": 190}, {"clock_in": "2026-01-02T21:27:38.607963", "clock_out": "2026-01-02T21:56:11.864410", "duration_minutes": 28}, {"clock_in": "2026-01-02T21:56:12.693158", "clock_out": "2026-01-02T22:55:23.927457", "duration_minutes": 59}], "total_duration_minutes": 372, "last_updated": "2026-01-02T22:55:23.927457"}	\N	\N	2026-01-02 16:32:01.960796+00	\N
419	1	7	2026-01-05	0	t		\N		2026-01-06 03:00:39.997358+00	\N
420	1	60	2026-01-05	0	t		\N		2026-01-06 03:00:40.357514+00	\N
421	1	27	2026-01-05	0	t		\N		2026-01-06 03:00:43.845544+00	\N
422	1	59	2026-01-05	0	t		\N		2026-01-06 03:00:50.663995+00	\N
423	1	63	2026-01-05	0	t		\N		2026-01-06 03:10:27.807329+00	\N
424	1	62	2026-01-05	0	t		\N		2026-01-06 03:41:09.947162+00	\N
425	1	44	2026-01-05	0	f		\N		2026-01-06 03:52:03.917395+00	\N
426	1	28	2026-01-05	0	t		\N		2026-01-06 03:52:30.946267+00	\N
428	1	59	2026-01-06	0	t		\N		2026-01-06 14:39:43.682534+00	\N
429	1	7	2026-01-06	0	t		\N		2026-01-06 15:01:33.05357+00	\N
431	1	28	2026-01-06	0	f		\N		2026-01-06 20:58:47.941919+00	\N
432	1	60	2026-01-06	0	t		\N		2026-01-06 20:59:01.892145+00	\N
430	1	27	2026-01-06	0	t		\N		2026-01-06 20:25:00.526036+00	\N
433	11	64	2026-01-06	0	t		\N		2026-01-07 01:19:40.884736+00	\N
427	1	23	2026-01-06	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-06T14:32:17.565077", "clock_out": "2026-01-06T16:53:09.796429", "duration_minutes": 140}, {"clock_in": "2026-01-06T16:59:36.344488", "clock_out": "2026-01-06T18:41:59.512764", "duration_minutes": 102}, {"clock_in": "2026-01-06T20:37:09.268176", "clock_out": "2026-01-06T21:54:41.731281", "duration_minutes": 77}], "total_duration_minutes": 319, "last_updated": "2026-01-06T21:54:41.731281"}	\N	\N	2026-01-06 14:32:17.567748+00	\N
434	11	64	2026-01-07	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-07T01:20:10.479172", "clock_out": "2026-01-07T01:20:13.855971", "duration_minutes": 0}], "total_duration_minutes": 0, "last_updated": "2026-01-07T01:20:13.855971"}	\N	\N	2026-01-07 01:20:10.482081+00	\N
435	1	63	2026-01-06	0	t		\N		2026-01-07 02:56:34.148301+00	\N
436	1	12	2026-01-06	0	t		\N		2026-01-07 03:01:39.6748+00	\N
437	1	50	2026-01-06	0	t		\N		2026-01-07 05:03:47.466389+00	\N
438	1	50	2026-01-07	0	t		\N		2026-01-07 15:23:04.560697+00	\N
441	1	12	2026-01-07	0	f		\N		2026-01-08 03:02:35.209356+00	\N
442	1	60	2026-01-07	0	t		\N		2026-01-08 03:20:35.646971+00	\N
444	1	50	2026-01-08	0	t		\N		2026-01-08 14:38:40.690901+00	\N
446	1	7	2026-01-08	0	t		\N		2026-01-08 14:39:20.861305+00	\N
439	1	23	2026-01-07	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-07T15:23:07.018103", "clock_out": "2026-01-07T18:06:13.120080", "duration_minutes": 163}, {"clock_in": "2026-01-07T19:54:46.537586", "clock_out": "2026-01-07T21:33:31.519986", "duration_minutes": 98}, {"clock_in": "2026-01-07T21:33:32.269154", "clock_out": "2026-01-07T22:03:11.623180", "duration_minutes": 29}, {"clock_in": "2026-01-07T22:03:13.126321", "clock_out": "2026-01-07T22:21:21.513906", "duration_minutes": 18}], "total_duration_minutes": 308, "last_updated": "2026-01-07T22:21:21.513906"}	\N	\N	2026-01-07 15:23:07.021608+00	\N
440	1	63	2026-01-07	0	t		\N		2026-01-08 02:00:17.223194+00	\N
443	1	7	2026-01-07	0	t		\N		2026-01-08 05:09:34.254418+00	\N
447	1	60	2026-01-08	0	t		\N		2026-01-08 15:00:18.76432+00	\N
445	1	23	2026-01-08	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2026-01-08T14:39:13.602579", "clock_out": "2026-01-08T14:53:04.808306", "duration_minutes": 13}, {"clock_in": "2026-01-08T14:53:06.742995", "clock_out": "2026-01-08T17:26:45.104799", "duration_minutes": 153}], "total_duration_minutes": 166, "last_updated": "2026-01-08T17:26:45.104799"}	\N	\N	2026-01-08 14:39:13.60492+00	\N
448	1	28	2026-01-08	0	t		\N		2026-01-09 03:16:24.314019+00	\N
449	1	50	2026-01-09	0	t		\N		2026-01-09 15:49:12.659875+00	\N
450	1	28	2026-01-09	0	t		\N		2026-01-09 16:18:40.356398+00	\N
451	1	60	2026-01-09	0	t		\N		2026-01-09 16:18:42.471727+00	\N
452	1	7	2026-01-09	0	t		\N		2026-01-09 17:55:42.007291+00	\N
453	1	27	2026-01-09	0	t		\N		2026-01-09 17:55:45.699925+00	\N
\.


--
-- TOC entry 3539 (class 0 OID 16433)
-- Dependencies: 222
-- Data for Name: exercise; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exercise (id, user_id, name, description, exercise_type, exercise_subtype, primary_muscles, secondary_muscles, equipment, equipment_modifiers, tags, injury_pain) FROM stdin;
1	1	Flat Bench Press 	\N	\N	\N	{Chest}	\N	\N	\N	\N	\N
2	1		\N	\N	\N	{}	\N	\N	\N	\N	\N
3	1	Deadlift 	Standard barbell deadlift 	\N	\N	{"Posterior chain"}	\N	\N	\N	\N	\N
4	1	Back squat 	Barbell ATG low bar backsquat	\N	\N	{"Posterior chain"}	\N	\N	\N	\N	\N
5	1	Overhead Press	Strict Barbell overhead press 	\N	\N	{Shoulders}	\N	\N	\N	\N	\N
6	1	Foam rolling	\N	\N	\N	{"Whole body"}	\N	\N	\N	\N	\N
7	1	Leg extensions 	Machine leg extensions 	\N	\N	{Quads}	\N	\N	\N	\N	\N
8	1	Dumbbell Row 	Off hand on bench and off foot close to bench pulling leg back 	\N	\N	{Lats}	\N	\N	\N	\N	\N
9	1	Pullups	\N	\N	\N	{Lats}	\N	\N	\N	\N	\N
10	1	Hanging leg raises 	\N	\N	\N	{Abs}	\N	\N	\N	\N	\N
11	4	Sushi 	Sushi 	Sushi 	Sushi 	{Sushi}	\N	\N	\N	\N	\N
12	8	Bench press	\N	Free weights	\N	{Chest,triceps}	\N	Barbell, bench 	{Incline,decline,dumbbell}	{Push,compound,strength}	\N
\.


--
-- TOC entry 3555 (class 0 OID 16595)
-- Dependencies: 238
-- Data for Name: food_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.food_entry (id, user_id, food_id, log_date, quantity, calories, protein_g, carbs_g, fat_g, meal_type, notes, created_at, updated_at, food_name) FROM stdin;
1	4	14	2025-12-08	0.00	0.00	0.00	0.00	0.00	\N	\N	2025-12-08 00:21:37.563241+00	2025-12-08 00:21:37.563241+00	Sushi 
\.


--
-- TOC entry 3553 (class 0 OID 16578)
-- Dependencies: 236
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.foods (id, user_id, name, category, brand, serving_size_amount, serving_size_unit, serving_unit, calories, protein_g, carbs_g, fat_g, fiber_g, notes, created_at) FROM stdin;
8	\N	test	\N	\N	12.00	g	\N	12.00	12.00	8.00	120.00	\N	\N	2025-11-25 01:15:12.615499+00
9	\N	k	\N	\N	100.00	g	\N	1.00	0.00	1.00	1.00	\N	\N	2025-11-25 01:27:07.786575+00
10	\N		\N	\N	100.00	g	\N	0.00	0.00	0.00	0.00	\N	\N	2025-11-25 01:27:09.453845+00
11	\N	Chic Fil A Chicken Buiscit 	\N	\N	1.00	piece	\N	460.00	19.00	45.00	23.00	\N	\N	2025-11-26 05:00:34.564654+00
12	\N	All American Club	\N	\N	1.00	piece	\N	1060.00	54.00	86.00	56.00	\N	\N	2025-11-26 05:02:33.959082+00
13	\N	Box Combo no slaw extra toast	\N	\N	100.00	piece	\N	1475.00	64.00	100.00	67.00	\N	\N	2025-11-26 05:05:47.86836+00
14	4	Sushi 	\N	\N	100.00	piece	\N	0.00	0.00	0.00	0.00	\N	\N	2025-12-08 00:21:16.03638+00
15	4		\N	\N	100.00	g	\N	0.00	0.00	0.00	0.00	\N	\N	2025-12-08 00:21:16.802256+00
16	4	Dry food 	\N	\N	100.00	cup	\N	0.00	0.00	0.00	0.00	\N	\N	2025-12-09 01:09:36.087938+00
\.


--
-- TOC entry 3551 (class 0 OID 16557)
-- Dependencies: 234
-- Data for Name: goal_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.goal_history (id, goal_id, change_type, old_value, new_value, changed_at, changed_by, reason, notes) FROM stdin;
\.


--
-- TOC entry 3549 (class 0 OID 16533)
-- Dependencies: 232
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.goals (id, user_id, metric_id, category, goal_text, target_value, progress, status, created_at, updated_at, goal_date, anchor_date, frequency, completed_at, notes) FROM stdin;
\.


--
-- TOC entry 3545 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: metric_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metric_history (id, metric_id, user_id, status, old_data_type, new_data_type, changed_at) FROM stdin;
\.


--
-- TOC entry 3543 (class 0 OID 16468)
-- Dependencies: 226
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metrics (id, user_id, category, subcategory, name, description, parent_id, is_required, data_type, unit, scale_min, scale_max, modifier_label, modifier_value, notes_on, active, created_at, updated_at, initials, time_type) FROM stdin;
48	1	\N	\N	3 Hours on Project	3 consecutive hours on a project	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-06 19:24:44.478441+00	2025-12-06 19:24:44.478441+00		week
51	4	\N	\N	Slaying 	Slaying all day 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-08 00:22:16.675567+00	2025-12-08 00:22:16.675567+00		week
55	7	\N	\N	Z		\N	f	text		\N	\N	\N	\N	f	t	2025-12-09 23:48:10.361485+00	2025-12-09 23:48:10.361485+00		day
59	1	\N	\N	30 mins straight violin		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-23 20:24:56.014103+00	2025-12-23 20:24:56.014103+00		day
63	1	\N	\N	1 line	Do an entry on the one line a day 5 year journal	\N	f	boolean		\N	\N	\N	\N	f	t	2026-01-06 03:10:06.358858+00	2026-01-06 03:10:06.358858+00		day
1	1	\N	\N	BW		\N	f	decimal	lbs	\N	\N	\N	\N	f	f	2025-09-22 04:27:14.194714+00	2025-09-22 04:27:14.194714+00	NA	day
2	1	\N	\N	Sleep	Hours in bed last night	\N	f	decimal	Hours	\N	\N	\N	\N	f	f	2025-09-22 04:28:02.511276+00	2025-09-22 04:28:02.511276+00	NA	day
3	1	\N	\N	Protein Intake		\N	f	decimal	Grams	\N	\N	\N	\N	f	f	2025-09-22 04:28:49.323002+00	2025-09-22 04:28:49.323002+00	NA	day
4	1	\N	\N	Net Liquid Assets	Checking Account + Savings Account(s) + Cash - Credit Card Balance(s)	\N	f	decimal	Dollars	\N	\N	\N	\N	f	f	2025-09-22 04:30:30.882221+00	2025-09-22 04:30:30.882221+00	NL	day
5	1	\N	\N	15 min workout	15 mins of physical training that will maintain or improve overall physical readiness: strength, endurance, flexibility, ect.	\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-22 04:33:28.325271+00	2025-09-22 04:33:28.325271+00	WO	day
6	1	\N	\N	10 mins cleaning	15 mins cleaning house or truck. If not at home and don't have access to truck then cleaning out email, photos, notes, home screen or something similar will count. 	\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-22 04:34:35.433746+00	2025-09-22 04:34:35.433746+00	NA	day
13	1	\N	\N	5 mins Mindlessness	>= 5 mins sitting or laying comfortably acknowledging thoughts but not indulging them. Notice a thought and push it away. Aiming for a slow empty calm mind. 	\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-23 15:12:56.293269+00	2025-09-23 15:12:56.293269+00	NA	day
12	1	\N	\N	Floss	Did I floss 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-23 15:10:43.249457+00	2025-09-23 15:10:43.249457+00	FL	day
14	1	\N	\N	5 mins+ violin learning songs		\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-24 22:32:12.512463+00	2025-09-24 22:32:12.512463+00	NA	day
15	1	\N	\N	5 mins violin practicing scales/arpeggios		\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-29 19:28:18.167268+00	2025-09-29 19:28:18.167268+00	NA	day
17	1	\N	\N	5 mins rhythm guitar practice	Intentionally learning and practicing specific rythym guitar techniques	\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-30 00:45:22.589016+00	2025-09-30 00:45:22.589016+00	NA	day
7	1	\N	\N	10 mins reading 	At least 10 mins of focused reading of a physical book, not an audiobook, not an article, and not about 10 minutes of total time throughout the day of sneaking a minute in. At least 10 mins in a row of focused reading.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:36:14.943501+00	2025-09-22 04:36:14.943501+00	RE	day
8	1	\N	\N	30 min Lifting Session 	At least 30 mins lifting.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:38:15.208471+00	2025-09-22 04:38:15.208471+00	NA	day
9	1	\N	\N	Hours Worked	Billable hours worked today.	\N	f	decimal	Hours	\N	\N	\N	\N	f	t	2025-09-22 04:38:58.818402+00	2025-09-22 04:38:58.818402+00	NA	day
10	1	\N	\N	Protein Goal (BW+10 gs)	>= BW + 10 grams of protein consumed today 	\N	f	decimal	Grams	\N	\N	\N	\N	f	t	2025-09-22 04:39:46.090656+00	2025-09-22 04:39:46.090656+00	NA	day
11	1	\N	\N	10 mins stretching		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 13:45:52.904118+00	2025-09-22 13:45:52.904118+00	NA	day
49	1	\N	\N	30 min murph set amrap		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-06 19:35:40.959531+00	2025-12-06 19:35:40.959531+00		week
52	6	\N	\N	Lifting		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-09 23:42:36.473019+00	2025-12-09 23:42:36.473019+00		day
53	6	\N	\N	A		\N	f	text		\N	\N	\N	\N	f	t	2025-12-09 23:43:18.023534+00	2025-12-09 23:43:18.023534+00		day
56	9	\N	\N	What’s 		\N	f	text		\N	\N	\N	\N	f	t	2025-12-10 01:35:47.509573+00	2025-12-10 01:35:47.509573+00		day
60	1	\N	\N	Update every dollar	Assign today’s transactions in every dollar to the correct parts of the budget	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-29 02:20:10.252083+00	2025-12-29 02:20:10.252083+00		day
19	1	\N	\N	Work Clock		\N	f	text	Time	\N	\N	\N	\N	f	t	2025-10-03 00:26:52.677238+00	2025-10-03 00:26:52.677238+00	NA	day
23	1	\N	\N	Work Work Work		\N	f	clock		\N	\N	\N	\N	f	t	2025-10-03 00:58:14.657091+00	2025-10-03 00:58:14.657091+00	NA	day
25	1	\N	\N	Project Work	Hours worked on programming projects outside of work	\N	f	clock	Hours	\N	\N	\N	\N	f	t	2025-10-07 02:13:12.255031+00	2025-10-07 02:13:12.255031+00	NA	day
26	1	\N	\N	Violin Video		\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-07 20:22:36.688445+00	2025-10-07 20:22:36.688445+00	NA	day
30	1	\N	\N	Journal	Write a dated entry in my journal	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 23:46:16.112664+00	2025-10-25 23:46:16.112664+00	NA	day
27	1	\N	\N	Practice Violin 5 mins		\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 14:07:15.355077+00	2025-10-25 14:07:15.355077+00	VI	day
28	1	\N	\N	One Feature	Add, complete, or fix one feature on a personal project or one hour towards a project	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 14:10:42.894599+00	2025-10-25 14:10:42.894599+00	OF	day
33	1	\N	\N	Work Journal	What did I do at work today? What did I learn? What problems did I encounter?	\N	f	text		\N	\N	\N	\N	f	t	2025-11-19 22:15:32.463263+00	2025-11-19 22:15:32.463263+00		day
38	1	\N	\N	Project clock	Time spent working on personal projects	\N	f	clock		\N	\N	\N	\N	f	t	2025-12-01 03:00:28.551285+00	2025-12-01 03:00:28.551285+00		day
43	1	\N	\N	learn something new in php	commit some php code with a new concept that i havent committed before	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-01 17:08:23.808652+00	2025-12-01 17:08:23.808652+00		day
61	1	\N	\N	30 min cardio intensive workout 		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-29 02:21:30.121421+00	2025-12-29 02:21:30.121421+00		week
64	11	\N	\N	Guitar 10 min a day 	You like guitar. Play it. 	\N	f	clock	10	\N	\N	\N	\N	t	t	2026-01-07 01:18:43.216927+00	2026-01-07 01:18:43.216927+00		day
16	1	\N	\N	5 mins learning lead songs	Spend time learning the lead parts for a song.	\N	f	boolean		\N	\N	\N	\N	f	f	2025-09-30 00:44:04.208524+00	2025-09-30 00:44:04.208524+00	NA	day
22	1	\N	\N	Test Clock	Test clock metric	\N	f	clock		\N	\N	\N	\N	f	f	2025-10-03 00:39:23.219964+00	2025-10-03 00:39:23.219964+00	NA	day
24	1	\N	\N	Playing and singing	practicing playing and singing a song at the same time	\N	f	boolean		\N	\N	\N	\N	f	f	2025-10-04 20:54:44.996085+00	2025-10-04 20:54:44.996085+00	NA	day
29	1	\N	\N	Read Yesterdays Financial Transactions	Read through yesterdays transactions and estimate its cashflow	\N	f	boolean		\N	\N	\N	\N	f	f	2025-10-25 14:16:07.609166+00	2025-10-25 14:16:07.609166+00	NA	day
31	1	\N	\N	5 minute Review	Review somthing I’ve read or written. Skim through a book I deeply enjoyed. Reread an old note of ideas or goals. Read old journal entries. Review annotations or notes from something.	\N	f	boolean		\N	\N	\N	\N	f	f	2025-10-26 01:12:13.935568+00	2025-10-26 01:12:13.935568+00	NA	day
32	1	\N	\N	1 rep 3 set songs 	Get at least one playthrough of at least  three songs from the set list or spend more than 30 mins working on the set, learning a hard part, charting songs ect 	\N	f	boolean		\N	\N	\N	\N	f	f	2025-11-08 18:51:45.274014+00	2025-11-08 18:51:45.274014+00	SL	day
34	1	\N	\N	Sing One Song		\N	f	boolean		\N	\N	\N	\N	f	f	2025-11-20 16:12:54.376923+00	2025-11-20 16:12:54.376923+00		day
35	1	\N	\N	Practice rythym ___ setlist songs		\N	f	decimal		\N	\N	\N	\N	f	f	2025-11-20 16:13:30.802598+00	2025-11-20 16:13:30.802598+00		day
36	1	\N	\N	Sing into a mic	listen to myself singing into a mic	\N	f	boolean		\N	\N	\N	\N	f	f	2025-11-20 16:13:53.411172+00	2025-11-20 16:13:53.411172+00		day
37	1	\N	\N	record myself singing and listen back		\N	f	boolean		\N	\N	\N	\N	f	f	2025-11-20 16:14:15.461612+00	2025-11-20 16:14:15.461612+00		day
39	1	\N	\N	Violin 20		\N	f	text		\N	\N	\N	\N	f	f	2025-12-01 03:06:21.415903+00	2025-12-01 03:06:21.415903+00		day
40	1	\N	\N	Practice violin 20 mins	Plan violin for 20 mins	\N	f	boolean		\N	\N	\N	\N	f	f	2025-12-01 03:06:39.431799+00	2025-12-01 03:06:39.431799+00		day
41	1	\N	\N	Review Dev's PWA changes	review all changes dev has put in to the pwa since i last looked at it	\N	f	boolean		\N	\N	\N	\N	f	f	2025-12-01 17:07:10.040625+00	2025-12-01 17:07:10.040625+00		day
42	1	\N	\N	practice a merge conflict	create and resolve a merge conflict on purpose	\N	f	boolean		\N	\N	\N	\N	f	f	2025-12-01 17:07:34.498149+00	2025-12-01 17:07:34.498149+00		day
44	1	\N	\N	50 pullups	50 pullups not chinups	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-01 17:12:48.172294+00	2025-12-01 17:12:48.172294+00		day
45	1	\N	\N	Record today’s work PP	Record my work at picture pros in my picture pros work file	\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-02 03:28:28.012695+00	2025-12-02 03:28:28.012695+00		day
50	1	\N	\N	30 mins writing		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-06 19:36:52.246932+00	2025-12-06 19:36:52.246932+00		week
54	7	\N	\N	Dinner at Calvin’s 		\N	f	text		\N	\N	\N	\N	f	t	2025-12-09 23:45:59.982252+00	2025-12-09 23:45:59.982252+00	DC	day
57	9	\N	\N	Times Calvin is Gay	If Calvin dose something Gay	\N	f	decimal	Times	\N	\N	\N	\N	f	t	2025-12-10 01:37:35.80478+00	2025-12-10 01:37:35.80478+00	Cg	day
58	10	\N	\N	dfsafsad		\N	f	text		\N	\N	\N	\N	f	t	2025-12-10 19:18:49.636165+00	2025-12-10 19:18:49.636165+00		day
62	1	\N	\N	100 pushups		\N	f	boolean		\N	\N	\N	\N	f	t	2025-12-30 04:13:35.915132+00	2025-12-30 04:13:35.915132+00		day
65	1	\N	\N	2 hours HT Dev	2 hours straight working on the habit tracker	\N	f	boolean		\N	\N	\N	\N	f	t	2026-01-07 16:37:30.268215+00	2026-01-07 16:37:30.268215+00		week
\.


--
-- TOC entry 3558 (class 0 OID 16676)
-- Dependencies: 241
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (id, filename, executed_at) FROM stdin;
1	001_add_clock_data_type.sql	2025-10-03 00:28:41.72681
\.


--
-- TOC entry 3541 (class 0 OID 16449)
-- Dependencies: 224
-- Data for Name: set_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.set_entry (id, workout_id, exercise_id, set_number, set_type, superset_id, reps, weight_kg, duration_s, rpe, rest_s, notes, injury_pain) FROM stdin;
\.


--
-- TOC entry 3562 (class 0 OID 16705)
-- Dependencies: 245
-- Data for Name: stripe_customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stripe_customers (id, stripe_customer_id, tier, active, subscription_id, created_at) FROM stdin;
1	cus_TWILw2fK9fb0iW	monthly	t	sub_1SZFkZHxPQinXpQvNivM607M	2025-11-30 18:53:43.034513+00
\.


--
-- TOC entry 3535 (class 0 OID 16400)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password_hash, first_name, last_name, created_at, updated_at, last_login, is_verified, settings, stripe_customer_id) FROM stdin;
3	CalvinWork	Calvingaienniework@yahoo.com	$2b$12$WsWpYS20FjwPV6XaBQS0weMVYwi2tWguU7ZJOSTlcwDg0tzKkW1hi	Calvin	Work	2025-11-30 18:30:17.710067+00	2025-11-30 18:30:17.710067+00	\N	f	{"enabledPages": [], "homePageLayout": []}	\N
7	Calvinsbiggestfan	jasonvanduzee@gmail.com	$2b$12$J3MuwSYJNM619Mx58jNXR.HjYln86xH8sItQ6bM9pBi0skWB/TZLi	Jason	VanDuzee	2025-12-09 23:45:24.465731+00	2025-12-09 23:45:24.465731+00	2025-12-10 01:08:51.508411+00	f	{"enabledPages": [], "workoutTypes": [], "homePageLayout": [{"section": "New Section", "metricIds": [0, 54]}], "homePageAnalytics": []}	\N
5	Admin	admin@exqmple.com	$2b$12$D7Z3CbvsYbFFh0YnlrXULO.wxCIvhx8NV7JznN.LWXHwnEcjNUyKK	Admin	Admin	2025-12-08 00:56:12.291147+00	2025-12-08 00:56:12.291147+00	\N	f	{"enabledPages": [], "homePageLayout": []}	\N
8	Edward Gaiennie	edwardgaiennie@gmail.com	$2b$12$offych7AQayKl97tKLTbL.mKCd5Qp8bTqm00VDlJtotBMcv2bbDHu	Edward	Gaiennie 	2025-12-10 01:15:25.991202+00	2025-12-10 01:15:25.991202+00	\N	f	{"enabledPages": [], "homePageLayout": []}	\N
9	LandonMelancon	LandonMelancon@gmail.com	$2b$12$iZhsZuWV.08LUtMmrSddqORmWhinDF6jCUQyXGZ3QsoTSQ3HMA4y2	Landon	Melancon	2025-12-10 01:34:21.990403+00	2025-12-10 01:34:21.990403+00	\N	f	{"enabledPages": [], "homePageLayout": []}	\N
6	cmuller	cameronjmuller117@gmail.com	$2b$12$jZntqIp4teE1p7NTqB8RLOcaHBcbwsnFxycF26.KfBgO7J.3hIqyu	Cameron	Muller	2025-12-09 23:40:33.225915+00	2025-12-09 23:40:33.225915+00	\N	f	{"enabledPages": [], "workoutTypes": [], "homePageLayout": [{"section": "New Section", "metricIds": [52]}], "homePageAnalytics": []}	\N
4	Graceanne123	graceannescott22@gmail.com	$2b$12$Sy22FsdBVOQ17MSxhscVuOuoaKt1pcpydn3bdDYe5bvEKSKyBcFVu	Grace anne 	Scott	2025-12-08 00:14:17.226256+00	2025-12-08 00:14:17.226256+00	2026-01-08 04:40:12.384784+00	f	{"enabledPages": [], "workoutTypes": ["Sushi "], "homePageLayout": [], "homePageAnalytics": []}	\N
1	Calvin	Calvingaiennie@gmail.com	$2b$12$HMz.T.FM6p2MePQMgkb4ZO6Z9oMfbIe.CV3i1Sf2nqwgKc2uqyp.i	Calvin	Gaiennie	2025-09-21 04:15:40.210767+00	2025-09-27 21:37:49.810728+00	2026-01-09 03:37:42.613908+00	f	{"enabledPages": ["homePage", "dietPage", "workoutPage", "analyticsPage"], "workoutTypes": ["Striking", "Grappling", "Lifting", "Stretching"], "homePageLayout": [{"section": "December Daily", "metricIds": [27, 12, 7, 60, 44, 62, 28, 63]}, {"section": "Work", "metricIds": [45, 23]}, {"section": "Weekly", "metricIds": [50, 59, 61, 65]}], "homePageAnalytics": [{"type": "line", "metricId": 4}]}	cus_TWILw2fK9fb0iW
10	admin	admin@example.com	$2b$12$2YNxYVgRtI/rrsIJJOlnQOwU7bn8MQs.fvmNJuqliX1Ay6xiQcXu2	a	a	2025-12-10 19:18:39.893604+00	2025-12-10 19:18:39.893604+00	\N	f	{"enabledPages": [], "workoutTypes": [], "homePageLayout": [{"section": "New Section", "metricIds": [58]}], "homePageAnalytics": []}	\N
11	Calvinballs69	jacksonjrusso@gmail.com	$2b$12$IehQn/n/QvG3fcd6kfB7S.yorT0gmoDiq8hrjVzAgC2LKWI7j3A4K	jackson	russo	2026-01-07 01:15:25.926279+00	2026-01-07 01:15:25.926279+00	\N	f	{"enabledPages": [], "workoutTypes": [], "homePageLayout": [{"section": "Guitar", "metricIds": [64]}], "homePageAnalytics": []}	\N
\.


--
-- TOC entry 3537 (class 0 OID 16418)
-- Dependencies: 220
-- Data for Name: workout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workout (id, user_id, started_at, ended_at, title, workout_type, notes) FROM stdin;
\.


--
-- TOC entry 3560 (class 0 OID 16687)
-- Dependencies: 243
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workouts (id, user_id, started_at, ended_at, title, workout_types, notes, exercises, is_draft, deleted_at) FROM stdin;
4	1	2025-10-26 18:08:20.862397+00	\N	Test 2	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 10, "notes": "", "weight": 5.0, "rest_duration": null}, {"reps": 10, "notes": "", "weight": 5.0, "rest_duration": null}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": 12, "notes": "", "weight": 6.0, "rest_duration": null}, {"reps": 5, "notes": "", "weight": 87.0, "rest_duration": null}], "notes": ""}]	f	2025-10-26 20:12:21.605402+00
30	6	2025-12-09 23:43:52.501176+00	\N	Upper 1	{Striking}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	t	\N
2	1	2025-10-26 18:07:11.174749+00	\N	dsaffsa	{Grappling}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 23, "notes": "", "weight": 4.0, "rest_duration": -2}], "notes": ""}]	f	2025-10-26 19:11:48.025781+00
31	8	2025-12-10 01:17:24.904933+00	\N		{}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	t	\N
6	1	2025-10-26 20:11:20.265872+00	\N	531 Deadlift Day 1 	{Lifting}	\N	[{"name": "Foam rolling", "sets": [{"reps": 5, "notes": "", "weight": 0.0, "rest_duration": null}], "notes": "5 mins foam rolling don’t know how to record this in here yet"}, {"name": "Deadlift ", "sets": [{"reps": 5, "notes": "", "weight": 135.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 155.0, "rest_duration": 150}, {"reps": 3, "notes": "", "weight": 185.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 205.0, "rest_duration": 150}, {"reps": 5, "notes": "", "weight": 225.0, "rest_duration": 180}, {"reps": 6, "notes": "", "weight": 265.0, "rest_duration": 250}], "notes": ""}, {"name": "Back squat ", "sets": [{"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 180}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 200}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 180}, {"reps": 5, "notes": "A click during rep three and starting to feel a bit like pain ", "weight": 90.0, "rest_duration": 240}], "notes": "A little bit of weirdness in my right knee. Not pain but definitely a feeling that shouldn’t be there on the front left inside kind of between the kneecap and the tip of my shinbone  "}, {"name": "Leg extensions ", "sets": [{"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": null}], "notes": "Cybex leg extension 12 \\nI don’t love this machine. I can’t get quite enough rang of motion at the bottom and a I am coming up off of it a lot. I have to hold the seat or handles hard. I feel it in my hips back and neck from straining to stay put "}]	f	\N
8	1	2025-10-27 18:34:21.215221+00	\N	531 Bench Day 2	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 15}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 30}, {"reps": 5, "notes": "", "weight": 75.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 95.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 115.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 115.0, "rest_duration": 120}, {"reps": 7, "notes": "", "weight": 135.0, "rest_duration": 60}], "notes": "Don’t hit the program exactly like it was intended I went too heavy and too few reps on set 4 so I did it right on set 5 and moved on "}, {"name": "Overhead Press", "sets": [{"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": null}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 210}], "notes": ""}, {"name": "Dumbbell Row ", "sets": [{"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 30.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 30.0, "rest_duration": null}], "notes": "Do 30 for all sets next time. \\nDid 10 each side need to build in single side exercises maybe with the superset feature also need to move the exercise select to also be the exercise title "}]	f	\N
10	1	2025-11-03 19:20:44.842263+00	\N	531 Squat 1	{Lifting}	\N	[{"name": "Back squat ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 5, "notes": "", "weight": 89.0, "rest_duration": 90}, {"reps": 3, "notes": "", "weight": 109.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 129.0, "rest_duration": 150}, {"reps": 5, "notes": "", "weight": 129.0, "rest_duration": 180}, {"reps": 5, "notes": "", "weight": 143.0, "rest_duration": 240}], "notes": ""}, {"name": "Deadlift ", "sets": [{"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": null}], "notes": ""}, {"name": "Leg extensions ", "sets": [{"reps": 10, "notes": "", "weight": 100.0, "rest_duration": 280}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": null}], "notes": "Faded machine upstairs "}]	f	\N
18	1	2025-11-10 18:20:58.788971+00	\N	531 Bench 2 	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 30}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 45}, {"reps": 5, "notes": "", "weight": 95.0, "rest_duration": 30}, {"reps": 3, "notes": "", "weight": 105.0, "rest_duration": 90}, {"reps": 3, "notes": "", "weight": 120.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 135.0, "rest_duration": 120}], "notes": ""}, {"name": "Overhead Press", "sets": [{"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 75}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": null}], "notes": ""}]	f	\N
14	1	2025-11-04 19:31:30.516337+00	\N	531 Press 1	{Lifting}	\N	[{"name": "Overhead Press", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 75.0, "rest_duration": 120}, {"reps": 8, "notes": "", "weight": 85.0, "rest_duration": 150}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": null}], "notes": ""}]	f	\N
12	1	2025-11-04 19:10:03.272165+00	\N	531 Press 1	{Lifting}	\N	[{"name": "Overhead Press", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	2025-11-04 19:10:07.388315+00
16	1	2025-11-06 19:22:13.824279+00	\N	531 Deadlift 2 	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 135.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 185.0, "rest_duration": 75}, {"reps": 3, "notes": "", "weight": 215.0, "rest_duration": 180}, {"reps": 3, "notes": "", "weight": 245.0, "rest_duration": 120}, {"reps": 6, "notes": "", "weight": 245.0, "rest_duration": 180}, {"reps": 8, "notes": "", "weight": 275.0, "rest_duration": 300}], "notes": ""}, {"name": "Back squat ", "sets": [{"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 180}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 150}], "notes": ""}]	f	\N
19	1	2025-12-05 19:42:18.539363+00	\N	Workout name 	{Lifting}	\N	[{"name": "Overhead Press", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}, {"name": "Back squat ", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	t	\N
21	4	2025-12-08 00:14:47.55041+00	\N	Slaying my day 	{Grappling}	\N	null	f	2025-12-08 00:19:14.037367+00
23	4	2025-12-08 00:19:22.740008+00	\N	Sushi morning routine 	{Stretching}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	\N
25	4	2025-12-08 00:19:46.12052+00	\N	Sushi 	{Stretching}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}, {"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	\N
27	4	2025-12-08 00:20:39.808925+00	\N	Sushi 	{Stretching}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	\N
29	4	2025-12-09 01:08:02.625046+00	\N	Sushi 	{Stretching}	\N	[{"name": "", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	\N
\.


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 229
-- Name: daily_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.daily_logs_id_seq', 453, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 221
-- Name: exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exercise_id_seq', 12, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 237
-- Name: food_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_entry_id_seq', 5, true);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 235
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_id_seq', 16, true);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 233
-- Name: goal_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.goal_history_id_seq', 1, false);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 231
-- Name: goals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.goals_id_seq', 1, false);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 227
-- Name: metric_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metric_history_id_seq', 1, false);


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 225
-- Name: metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metrics_id_seq', 65, true);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 240
-- Name: schema_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schema_migrations_id_seq', 1, true);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 223
-- Name: set_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.set_entry_id_seq', 1, false);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 244
-- Name: stripe_customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stripe_customers_id_seq', 1, true);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 239
-- Name: superset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.superset_seq', 1, false);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 219
-- Name: workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workout_id_seq', 1, false);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 242
-- Name: workouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workouts_id_seq', 31, true);


--
-- TOC entry 3348 (class 2606 OID 16521)
-- Name: daily_logs daily_logs_metric_id_log_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_metric_id_log_date_key UNIQUE (metric_id, log_date);


--
-- TOC entry 3350 (class 2606 OID 16519)
-- Name: daily_logs daily_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 16442)
-- Name: exercise exercise_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_name_key UNIQUE (name);


--
-- TOC entry 3340 (class 2606 OID 16440)
-- Name: exercise exercise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 16606)
-- Name: food_entry food_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 16608)
-- Name: food_entry food_entry_user_id_food_id_log_date_created_at_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_user_id_food_id_log_date_created_at_key UNIQUE (user_id, food_id, log_date, created_at);


--
-- TOC entry 3356 (class 2606 OID 16588)
-- Name: foods food_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 16566)
-- Name: goal_history goal_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 16545)
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 16499)
-- Name: metric_history metric_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 16481)
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 3362 (class 2606 OID 16684)
-- Name: schema_migrations schema_migrations_filename_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_filename_key UNIQUE (filename);


--
-- TOC entry 3364 (class 2606 OID 16682)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 16456)
-- Name: set_entry set_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_pkey PRIMARY KEY (id);


--
-- TOC entry 3368 (class 2606 OID 16714)
-- Name: stripe_customers stripe_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_customers
    ADD CONSTRAINT stripe_customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 16716)
-- Name: stripe_customers stripe_customers_stripe_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_customers
    ADD CONSTRAINT stripe_customers_stripe_customer_id_key UNIQUE (stripe_customer_id);


--
-- TOC entry 3328 (class 2606 OID 16416)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3330 (class 2606 OID 16412)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 16703)
-- Name: users users_stripe_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_stripe_customer_id_key UNIQUE (stripe_customer_id);


--
-- TOC entry 3334 (class 2606 OID 16414)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3336 (class 2606 OID 16426)
-- Name: workout workout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 16695)
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


--
-- TOC entry 3379 (class 2606 OID 16527)
-- Name: daily_logs daily_logs_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE CASCADE;


--
-- TOC entry 3380 (class 2606 OID 16522)
-- Name: daily_logs daily_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_logs
    ADD CONSTRAINT daily_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3372 (class 2606 OID 16443)
-- Name: exercise exercise_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT exercise_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3386 (class 2606 OID 16614)
-- Name: food_entry food_entry_food_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_food_id_fkey FOREIGN KEY (food_id) REFERENCES public.foods(id) ON DELETE SET NULL;


--
-- TOC entry 3387 (class 2606 OID 16609)
-- Name: food_entry food_entry_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_entry
    ADD CONSTRAINT food_entry_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3385 (class 2606 OID 16589)
-- Name: foods food_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT food_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3383 (class 2606 OID 16572)
-- Name: goal_history goal_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3384 (class 2606 OID 16567)
-- Name: goal_history goal_history_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.goals(id) ON DELETE CASCADE;


--
-- TOC entry 3381 (class 2606 OID 16551)
-- Name: goals goals_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE SET NULL;


--
-- TOC entry 3382 (class 2606 OID 16546)
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3377 (class 2606 OID 16500)
-- Name: metric_history metric_history_metric_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES public.metrics(id) ON DELETE CASCADE;


--
-- TOC entry 3378 (class 2606 OID 16505)
-- Name: metric_history metric_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_history
    ADD CONSTRAINT metric_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3375 (class 2606 OID 16487)
-- Name: metrics metrics_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.metrics(id) ON DELETE SET NULL;


--
-- TOC entry 3376 (class 2606 OID 16482)
-- Name: metrics metrics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3373 (class 2606 OID 16462)
-- Name: set_entry set_entry_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercise(id);


--
-- TOC entry 3374 (class 2606 OID 16457)
-- Name: set_entry set_entry_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.set_entry
    ADD CONSTRAINT set_entry_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workout(id) ON DELETE CASCADE;


--
-- TOC entry 3371 (class 2606 OID 16427)
-- Name: workout workout_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout
    ADD CONSTRAINT workout_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3388 (class 2606 OID 16696)
-- Name: workouts workouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-01-09 14:56:29 CST

--
-- PostgreSQL database dump complete
--

\unrestrict cz3u3yx4hfiMuTeYMUq1VcY2igsBzWfdyJTrZMG5zjMjp4bn94e9fC1cOiia3NM

