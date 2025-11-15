--
-- PostgreSQL database dump
--

\restrict iMXHWJVPFc1zydI6QEdBCS5clkAtr508VhJO0MRPtTUFAsPTcnyHwEq4q9cRoC3

-- Dumped from database version 17.6 (Debian 17.6-2.pgdg12+1)
-- Dumped by pg_dump version 17.6 (Homebrew)

-- Started on 2025-11-10 12:41:02 CST

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
197	1	23	2025-11-10	\N	\N	{"current_state": "clocked_out", "sessions": [{"clock_in": "2025-11-10T14:40:01.748783", "clock_out": "2025-11-10T17:55:08.648825", "duration_minutes": 195}], "total_duration_minutes": 195, "last_updated": "2025-11-10T17:55:08.648825"}	\N	\N	2025-11-10 14:40:01.747883+00	\N
198	1	5	2025-11-10	0	t		\N		2025-11-10 18:40:37.081001+00	\N
199	1	27	2025-11-10	0	t		\N		2025-11-10 18:40:37.381387+00	\N
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
\.


--
-- TOC entry 3555 (class 0 OID 16595)
-- Dependencies: 238
-- Data for Name: food_entry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.food_entry (id, user_id, food_id, log_date, quantity, calories, protein_g, carbs_g, fat_g, meal_type, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3553 (class 0 OID 16578)
-- Dependencies: 236
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.foods (id, user_id, name, category, brand, serving_size_amount, serving_size_unit, serving_unit, calories, protein_g, carbs_g, fat_g, fiber_g, notes, created_at) FROM stdin;
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

COPY public.metrics (id, user_id, category, subcategory, name, description, parent_id, is_required, data_type, unit, scale_min, scale_max, modifier_label, modifier_value, notes_on, active, created_at, updated_at, initials) FROM stdin;
12	1	\N	\N	Floss	Did I floss 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-23 15:10:43.249457+00	2025-09-23 15:10:43.249457+00	FL
4	1	\N	\N	Net Liquid Assets	Checking Account + Savings Account(s) + Cash - Credit Card Balance(s)	\N	f	decimal	Dollars	\N	\N	\N	\N	f	t	2025-09-22 04:30:30.882221+00	2025-09-22 04:30:30.882221+00	NL
5	1	\N	\N	15 min workout	15 mins of physical training that will maintain or improve overall physical readiness: strength, endurance, flexibility, ect.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:33:28.325271+00	2025-09-22 04:33:28.325271+00	WO
7	1	\N	\N	10 mins reading 	At least 10 mins of focused reading of a physical book, not an audiobook, not an article, and not about 10 minutes of total time throughout the day of sneaking a minute in. At least 10 mins in a row of focused reading.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:36:14.943501+00	2025-09-22 04:36:14.943501+00	RE
1	1	\N	\N	BW		\N	f	decimal	lbs	\N	\N	\N	\N	f	t	2025-09-22 04:27:14.194714+00	2025-09-22 04:27:14.194714+00	NA
2	1	\N	\N	Sleep	Hours in bed last night	\N	f	decimal	Hours	\N	\N	\N	\N	f	t	2025-09-22 04:28:02.511276+00	2025-09-22 04:28:02.511276+00	NA
3	1	\N	\N	Protein Intake		\N	f	decimal	Grams	\N	\N	\N	\N	f	t	2025-09-22 04:28:49.323002+00	2025-09-22 04:28:49.323002+00	NA
8	1	\N	\N	30 min Lifting Session 	At least 30 mins lifting.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:38:15.208471+00	2025-09-22 04:38:15.208471+00	NA
9	1	\N	\N	Hours Worked	Billable hours worked today.	\N	f	decimal	Hours	\N	\N	\N	\N	f	t	2025-09-22 04:38:58.818402+00	2025-09-22 04:38:58.818402+00	NA
10	1	\N	\N	Protein Goal (BW+10 gs)	>= BW + 10 grams of protein consumed today 	\N	f	decimal	Grams	\N	\N	\N	\N	f	t	2025-09-22 04:39:46.090656+00	2025-09-22 04:39:46.090656+00	NA
11	1	\N	\N	10 mins stretching		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 13:45:52.904118+00	2025-09-22 13:45:52.904118+00	NA
13	1	\N	\N	5 mins Mindlessness	>= 5 mins sitting or laying comfortably acknowledging thoughts but not indulging them. Notice a thought and push it away. Aiming for a slow empty calm mind. 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-23 15:12:56.293269+00	2025-09-23 15:12:56.293269+00	NA
6	1	\N	\N	10 mins cleaning	15 mins cleaning house or truck. If not at home and don't have access to truck then cleaning out email, photos, notes, home screen or something similar will count. 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-22 04:34:35.433746+00	2025-09-22 04:34:35.433746+00	NA
14	1	\N	\N	5 mins+ violin learning songs		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-24 22:32:12.512463+00	2025-09-24 22:32:12.512463+00	NA
15	1	\N	\N	5 mins violin practicing scales/arpeggios		\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-29 19:28:18.167268+00	2025-09-29 19:28:18.167268+00	NA
17	1	\N	\N	5 mins rhythm guitar practice	Intentionally learning and practicing specific rythym guitar techniques	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-30 00:45:22.589016+00	2025-09-30 00:45:22.589016+00	NA
16	1	\N	\N	5 mins learning lead songs	Spend time learning the lead parts for a song.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-09-30 00:44:04.208524+00	2025-09-30 00:44:04.208524+00	NA
19	1	\N	\N	Work Clock		\N	f	text	Time	\N	\N	\N	\N	f	t	2025-10-03 00:26:52.677238+00	2025-10-03 00:26:52.677238+00	NA
22	1	\N	\N	Test Clock	Test clock metric	\N	f	clock		\N	\N	\N	\N	f	t	2025-10-03 00:39:23.219964+00	2025-10-03 00:39:23.219964+00	NA
23	1	\N	\N	Work Work Work		\N	f	clock		\N	\N	\N	\N	f	t	2025-10-03 00:58:14.657091+00	2025-10-03 00:58:14.657091+00	NA
24	1	\N	\N	Playing and singing	practicing playing and singing a song at the same time	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-04 20:54:44.996085+00	2025-10-04 20:54:44.996085+00	NA
25	1	\N	\N	Project Work	Hours worked on programming projects outside of work	\N	f	clock	Hours	\N	\N	\N	\N	f	t	2025-10-07 02:13:12.255031+00	2025-10-07 02:13:12.255031+00	NA
26	1	\N	\N	Violin Video		\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-07 20:22:36.688445+00	2025-10-07 20:22:36.688445+00	NA
29	1	\N	\N	Read Yesterdays Financial Transactions	Read through yesterdays transactions and estimate its cashflow	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 14:16:07.609166+00	2025-10-25 14:16:07.609166+00	NA
30	1	\N	\N	Journal	Write a dated entry in my journal	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 23:46:16.112664+00	2025-10-25 23:46:16.112664+00	NA
31	1	\N	\N	5 minute Review	Review somthing I’ve read or written. Skim through a book I deeply enjoyed. Reread an old note of ideas or goals. Read old journal entries. Review annotations or notes from something.	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-26 01:12:13.935568+00	2025-10-26 01:12:13.935568+00	NA
32	1	\N	\N	1 rep 3 set songs 	Get at least one playthrough of at least  three songs from the set list or spend more than 30 mins working on the set, learning a hard part, charting songs ect 	\N	f	boolean		\N	\N	\N	\N	f	t	2025-11-08 18:51:45.274014+00	2025-11-08 18:51:45.274014+00	SL
27	1	\N	\N	Practice Violin 5 mins		\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 14:07:15.355077+00	2025-10-25 14:07:15.355077+00	VI
28	1	\N	\N	One Feature	Add, complete, or fix one feature on a personal project or one hour towards a project	\N	f	boolean		\N	\N	\N	\N	f	t	2025-10-25 14:10:42.894599+00	2025-10-25 14:10:42.894599+00	OF
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
\.


--
-- TOC entry 3535 (class 0 OID 16400)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password_hash, first_name, last_name, created_at, updated_at, last_login, is_verified, settings, stripe_customer_id) FROM stdin;
1	Calvin	Calvingaiennie@gmail.com	$2b$12$CQcVyqiAOC7ONzi9hNGZKufUmsGOvBPlmSs0yK3i5EduXou3BAtVq	Calvin	Gaiennie	2025-09-21 04:15:40.210767+00	2025-09-27 21:37:49.810728+00	2025-11-05 00:13:02.544615+00	f	{"enabledPages": ["homePage", "dietPage", "workoutPage", "analyticsPage"], "workoutTypes": ["Striking", "Grappling", "Lifting", "Stretching"], "homePageLayout": [{"section": "Direct Inputs or Outputs for Main Goals", "metricIds": [4, 5, 27, 28]}, {"section": "Second Level Inputs, Outputs, or Other Habits", "metricIds": [7, 26, 12, 32]}, {"section": "Misc Tracking ", "metricIds": [23]}]}	\N
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
2	1	2025-10-26 18:07:11.174749+00	\N	dsaffsa	{Grappling}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 23, "notes": "", "weight": 4.0, "rest_duration": -2}], "notes": ""}]	f	2025-10-26 19:11:48.025781+00
6	1	2025-10-26 20:11:20.265872+00	\N	531 Deadlift Day 1 	{Lifting}	\N	[{"name": "Foam rolling", "sets": [{"reps": 5, "notes": "", "weight": 0.0, "rest_duration": null}], "notes": "5 mins foam rolling don’t know how to record this in here yet"}, {"name": "Deadlift ", "sets": [{"reps": 5, "notes": "", "weight": 135.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 155.0, "rest_duration": 150}, {"reps": 3, "notes": "", "weight": 185.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 205.0, "rest_duration": 150}, {"reps": 5, "notes": "", "weight": 225.0, "rest_duration": 180}, {"reps": 6, "notes": "", "weight": 265.0, "rest_duration": 250}], "notes": ""}, {"name": "Back squat ", "sets": [{"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 180}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 200}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 180}, {"reps": 5, "notes": "A click during rep three and starting to feel a bit like pain ", "weight": 90.0, "rest_duration": 240}], "notes": "A little bit of weirdness in my right knee. Not pain but definitely a feeling that shouldn’t be there on the front left inside kind of between the kneecap and the tip of my shinbone  "}, {"name": "Leg extensions ", "sets": [{"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 90.0, "rest_duration": null}], "notes": "Cybex leg extension 12 \\nI don’t love this machine. I can’t get quite enough rang of motion at the bottom and a I am coming up off of it a lot. I have to hold the seat or handles hard. I feel it in my hips back and neck from straining to stay put "}]	f	\N
8	1	2025-10-27 18:34:21.215221+00	\N	531 Bench Day 2	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 15}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 30}, {"reps": 5, "notes": "", "weight": 75.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 95.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 115.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 115.0, "rest_duration": 120}, {"reps": 7, "notes": "", "weight": 135.0, "rest_duration": 60}], "notes": "Don’t hit the program exactly like it was intended I went too heavy and too few reps on set 4 so I did it right on set 5 and moved on "}, {"name": "Overhead Press", "sets": [{"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": null}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 210}], "notes": ""}, {"name": "Dumbbell Row ", "sets": [{"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 25.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 30.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 30.0, "rest_duration": null}], "notes": "Do 30 for all sets next time. \\nDid 10 each side need to build in single side exercises maybe with the superset feature also need to move the exercise select to also be the exercise title "}]	f	\N
10	1	2025-11-03 19:20:44.842263+00	\N	531 Squat 1	{Lifting}	\N	[{"name": "Back squat ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 5, "notes": "", "weight": 89.0, "rest_duration": 90}, {"reps": 3, "notes": "", "weight": 109.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 129.0, "rest_duration": 150}, {"reps": 5, "notes": "", "weight": 129.0, "rest_duration": 180}, {"reps": 5, "notes": "", "weight": 143.0, "rest_duration": 240}], "notes": ""}, {"name": "Deadlift ", "sets": [{"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 155.0, "rest_duration": null}], "notes": ""}, {"name": "Leg extensions ", "sets": [{"reps": 10, "notes": "", "weight": 100.0, "rest_duration": 280}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 110.0, "rest_duration": null}], "notes": "Faded machine upstairs "}]	f	\N
18	1	2025-11-10 18:20:58.788971+00	\N	531 Bench 2 	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 30}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 45}, {"reps": 5, "notes": "", "weight": 95.0, "rest_duration": 30}, {"reps": 3, "notes": "", "weight": 105.0, "rest_duration": 90}, {"reps": 3, "notes": "", "weight": 120.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 135.0, "rest_duration": 120}], "notes": ""}, {"name": "Overhead Press", "sets": [{"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 90}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 75}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 45.0, "rest_duration": null}], "notes": ""}]	f	\N
14	1	2025-11-04 19:31:30.516337+00	\N	531 Press 1	{Lifting}	\N	[{"name": "Overhead Press", "sets": [{"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 45.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 65.0, "rest_duration": 120}, {"reps": 5, "notes": "", "weight": 75.0, "rest_duration": 120}, {"reps": 8, "notes": "", "weight": 85.0, "rest_duration": 150}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 60}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": null}], "notes": ""}]	f	\N
12	1	2025-11-04 19:10:03.272165+00	\N	531 Press 1	{Lifting}	\N	[{"name": "Overhead Press", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}, {"name": "Flat Bench Press ", "sets": [{"reps": null, "notes": "", "weight": null, "rest_duration": null}], "notes": ""}]	f	2025-11-04 19:10:07.388315+00
16	1	2025-11-06 19:22:13.824279+00	\N	531 Deadlift 2 	{Lifting}	\N	[{"name": "Flat Bench Press ", "sets": [{"reps": 5, "notes": "", "weight": 135.0, "rest_duration": 60}, {"reps": 5, "notes": "", "weight": 155.0, "rest_duration": 60}, {"reps": 3, "notes": "", "weight": 185.0, "rest_duration": 75}, {"reps": 3, "notes": "", "weight": 215.0, "rest_duration": 180}, {"reps": 3, "notes": "", "weight": 245.0, "rest_duration": 120}, {"reps": 6, "notes": "", "weight": 245.0, "rest_duration": 180}, {"reps": 8, "notes": "", "weight": 275.0, "rest_duration": 300}], "notes": ""}, {"name": "Back squat ", "sets": [{"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 180}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 150}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 120}, {"reps": 10, "notes": "", "weight": 85.0, "rest_duration": 150}], "notes": ""}]	f	\N
\.


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 229
-- Name: daily_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.daily_logs_id_seq', 199, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 221
-- Name: exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exercise_id_seq', 10, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 237
-- Name: food_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_entry_id_seq', 1, false);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 235
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.food_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.metrics_id_seq', 32, true);


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

SELECT pg_catalog.setval('public.stripe_customers_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


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

SELECT pg_catalog.setval('public.workouts_id_seq', 18, true);


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


-- Completed on 2025-11-10 12:41:10 CST

--
-- PostgreSQL database dump complete
--

\unrestrict iMXHWJVPFc1zydI6QEdBCS5clkAtr508VhJO0MRPtTUFAsPTcnyHwEq4q9cRoC3

