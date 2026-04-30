-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.accounts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name character varying NOT NULL,
  account_type character varying NOT NULL CHECK (account_type::text = ANY (ARRAY['checking'::character varying, 'savings'::character varying, 'investment'::character varying]::text[])),
  bank_name character varying,
  account_number character varying,
  initial_balance numeric DEFAULT 0,
  current_balance numeric,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT accounts_pkey PRIMARY KEY (id),
  CONSTRAINT accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.audit_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  action character varying NOT NULL,
  table_name character varying NOT NULL,
  record_id uuid,
  old_values jsonb,
  new_values jsonb,
  ip_address inet,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT audit_log_pkey PRIMARY KEY (id),
  CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.cashflow_forecast (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  account_id uuid,
  category_id uuid,
  description character varying NOT NULL,
  amount numeric NOT NULL,
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])),
  forecast_date date NOT NULL,
  frequency character varying DEFAULT 'once'::character varying CHECK (frequency::text = ANY (ARRAY['once'::character varying, 'monthly'::character varying, 'yearly'::character varying]::text[])),
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  cost_center_id uuid,
  CONSTRAINT cashflow_forecast_pkey PRIMARY KEY (id),
  CONSTRAINT cashflow_forecast_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT cashflow_forecast_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT cashflow_forecast_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id),
  CONSTRAINT cashflow_forecast_cost_center_id_fkey FOREIGN KEY (cost_center_id) REFERENCES public.cost_centers(id)
);
CREATE TABLE public.categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name character varying NOT NULL,
  type character varying NOT NULL CHECK (type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])),
  color character varying DEFAULT '#3498db'::character varying,
  is_active boolean DEFAULT true,
  parent_id uuid,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT categories_pkey PRIMARY KEY (id),
  CONSTRAINT categories_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id)
);
CREATE TABLE public.cost_centers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name character varying NOT NULL,
  description text,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  code character varying,
  type character varying DEFAULT 'personal'::character varying CHECK (type::text = ANY (ARRAY['personal'::character varying, 'business'::character varying, 'project'::character varying, 'family'::character varying, 'other'::character varying]::text[])),
  parent_id uuid,
  color character varying DEFAULT '#06b6d4'::character varying,
  updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT cost_centers_pkey PRIMARY KEY (id),
  CONSTRAINT cost_centers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT cost_centers_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.cost_centers(id)
);
CREATE TABLE public.credit_card_invoices (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  credit_card_id uuid NOT NULL,
  opening_date date NOT NULL,
  closing_date date NOT NULL,
  due_date date NOT NULL,
  total_amount numeric DEFAULT 0,
  paid_amount numeric DEFAULT 0,
  status character varying DEFAULT 'open'::character varying CHECK (status::text = ANY (ARRAY['open'::character varying, 'closed'::character varying, 'paid'::character varying]::text[])),
  payment_date timestamp with time zone,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT credit_card_invoices_pkey PRIMARY KEY (id),
  CONSTRAINT credit_card_invoices_credit_card_id_fkey FOREIGN KEY (credit_card_id) REFERENCES public.credit_cards(id)
);
CREATE TABLE public.credit_card_transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  transaction_id uuid NOT NULL,
  invoice_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT credit_card_transactions_pkey PRIMARY KEY (id),
  CONSTRAINT credit_card_transactions_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id),
  CONSTRAINT credit_card_transactions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.credit_card_invoices(id)
);
CREATE TABLE public.credit_cards (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  account_id uuid NOT NULL,
  name character varying NOT NULL,
  last_digits character varying,
  credit_limit numeric,
  closing_day integer NOT NULL CHECK (closing_day >= 1 AND closing_day <= 28),
  due_day integer NOT NULL CHECK (due_day >= 1 AND due_day <= 31),
  current_balance numeric DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT credit_cards_pkey PRIMARY KEY (id),
  CONSTRAINT credit_cards_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT credit_cards_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id)
);
CREATE TABLE public.tags (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name character varying NOT NULL,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT tags_pkey PRIMARY KEY (id),
  CONSTRAINT tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.transaction_tags (
  transaction_id uuid NOT NULL,
  tag_id uuid NOT NULL,
  CONSTRAINT transaction_tags_pkey PRIMARY KEY (transaction_id, tag_id),
  CONSTRAINT transaction_tags_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id),
  CONSTRAINT transaction_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id)
);
CREATE TABLE public.transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid(),
  descricao text,
  valor numeric,
  tipo text,
  data date,
  criado_em timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  categoria_legado text,
  pago boolean DEFAULT false,
  account_id uuid,
  category_id uuid,
  credit_card_id uuid,
  cost_center_id uuid,
  transaction_date date,
  paid_status character varying DEFAULT 'pending'::character varying CHECK (paid_status::text = ANY (ARRAY['pending'::character varying, 'paid'::character varying, 'overdue'::character varying]::text[])),
  is_recurring boolean DEFAULT false,
  recurring_frequency character varying CHECK (recurring_frequency::text = ANY (ARRAY['daily'::character varying, 'weekly'::character varying, 'monthly'::character varying, 'yearly'::character varying]::text[])),
  notes text,
  updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  status character varying NOT NULL DEFAULT 'paid'::character varying CHECK (status::text = ANY (ARRAY['paid'::character varying, 'planned'::character varying, 'overdue'::character varying]::text[])),
  due_date date,
  installment_group_id uuid,
  installment_number integer DEFAULT 1,
  installment_total integer DEFAULT 1,
  invoice_id uuid,
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id),
  CONSTRAINT transactions_credit_card_id_fkey FOREIGN KEY (credit_card_id) REFERENCES public.credit_cards(id),
  CONSTRAINT transactions_cost_center_id_fkey FOREIGN KEY (cost_center_id) REFERENCES public.cost_centers(id),
  CONSTRAINT transactions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.credit_card_invoices(id)
);