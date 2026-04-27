-- =====================================================
-- SCHEMA COMPLETO - FINWEB
-- Sistema Financeiro com Supabase
-- =====================================================

-- =====================================================
-- 1. TABELAS DE CONFIGURAÇÃO
-- =====================================================

-- Contas Correntes/Poupança/Investimentos
CREATE TABLE IF NOT EXISTS public.accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(100) NOT NULL,
  account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('checking', 'savings', 'investment')),
  bank_name VARCHAR(100),
  account_number VARCHAR(20),
  initial_balance DECIMAL(15,2) DEFAULT 0,
  current_balance DECIMAL(15,2),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  UNIQUE(user_id, account_number),
  UNIQUE(user_id, name)
);

-- Categorias de Transações
CREATE TABLE IF NOT EXISTS public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
  color VARCHAR(7) DEFAULT '#3498db',
  is_active BOOLEAN DEFAULT true,
  parent_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  UNIQUE(user_id, name)
);

-- Tags Customizadas
CREATE TABLE IF NOT EXISTS public.tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  UNIQUE(user_id, name)
);

-- Centro de Custos
CREATE TABLE IF NOT EXISTS public.cost_centers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  UNIQUE(user_id, name)
);

-- Cartões de Crédito
CREATE TABLE IF NOT EXISTS public.credit_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  account_id UUID REFERENCES public.accounts(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(100) NOT NULL,
  last_digits VARCHAR(4),
  credit_limit DECIMAL(15,2),
  closing_day INTEGER NOT NULL CHECK (closing_day BETWEEN 1 AND 28),
  due_day INTEGER NOT NULL CHECK (due_day BETWEEN 1 AND 31),
  current_balance DECIMAL(15,2) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc')
);

-- Faturas de Cartão de Crédito
CREATE TABLE IF NOT EXISTS public.credit_card_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  credit_card_id UUID REFERENCES public.credit_cards(id) ON DELETE CASCADE NOT NULL,
  opening_date DATE NOT NULL,
  closing_date DATE NOT NULL,
  due_date DATE NOT NULL,
  total_amount DECIMAL(15,2) DEFAULT 0,
  paid_amount DECIMAL(15,2) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'closed', 'paid')),
  payment_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc')
);

-- Fluxo de Caixa Previsto
CREATE TABLE IF NOT EXISTS public.cashflow_forecast (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  account_id UUID REFERENCES public.accounts(id) ON DELETE SET NULL,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  description VARCHAR(255) NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
  forecast_date DATE NOT NULL,
  frequency VARCHAR(20) DEFAULT 'once' CHECK (frequency IN ('once', 'monthly', 'yearly')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc')
);

-- Auditoria
CREATE TABLE IF NOT EXISTS public.audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  action VARCHAR(100) NOT NULL,
  table_name VARCHAR(50) NOT NULL,
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc')
);

-- =====================================================
-- 2. ÍNDICES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_accounts_user ON public.accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_active ON public.accounts(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_categories_user ON public.categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_type ON public.categories(user_id, type);
CREATE INDEX IF NOT EXISTS idx_tags_user ON public.tags(user_id);
CREATE INDEX IF NOT EXISTS idx_cost_centers_user ON public.cost_centers(user_id);
CREATE INDEX IF NOT EXISTS idx_credit_cards_user ON public.credit_cards(user_id);
CREATE INDEX IF NOT EXISTS idx_credit_cards_account ON public.credit_cards(account_id);
CREATE INDEX IF NOT EXISTS idx_invoices_card ON public.credit_card_invoices(credit_card_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON public.credit_card_invoices(status);
CREATE INDEX IF NOT EXISTS idx_cashflow_user_date ON public.cashflow_forecast(user_id, forecast_date);
CREATE INDEX IF NOT EXISTS idx_audit_user ON public.audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_table ON public.audit_log(table_name);

-- =====================================================
-- 3. TRIGGERS
-- =====================================================

-- Função para registrar auditoria
CREATE OR REPLACE FUNCTION audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_log (user_id, action, table_name, record_id, new_values)
    VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_log (user_id, action, table_name, record_id, old_values, new_values)
    VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_log (user_id, action, table_name, record_id, old_values)
    VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers de auditoria
CREATE TRIGGER audit_accounts AFTER INSERT OR UPDATE OR DELETE ON public.accounts FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
CREATE TRIGGER audit_categories AFTER INSERT OR UPDATE OR DELETE ON public.categories FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
CREATE TRIGGER audit_tags AFTER INSERT OR UPDATE OR DELETE ON public.tags FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
CREATE TRIGGER audit_cost_centers AFTER INSERT OR UPDATE OR DELETE ON public.cost_centers FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
CREATE TRIGGER audit_credit_cards AFTER INSERT OR UPDATE OR DELETE ON public.credit_cards FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
CREATE TRIGGER audit_invoices AFTER INSERT OR UPDATE OR DELETE ON public.credit_card_invoices FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Função para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = (NOW() AT TIME ZONE 'utc');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_accounts_updated_at BEFORE UPDATE ON public.accounts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_credit_cards_updated_at BEFORE UPDATE ON public.credit_cards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 4. RLS - ROW LEVEL SECURITY
-- =====================================================

-- Ativar RLS
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cost_centers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.credit_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.credit_card_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cashflow_forecast ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- Policies - ACCOUNTS
CREATE POLICY "Users can view their own accounts" ON public.accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own accounts" ON public.accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own accounts" ON public.accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own accounts" ON public.accounts FOR DELETE USING (auth.uid() = user_id);

-- Policies - CATEGORIES
CREATE POLICY "Users can view their own categories" ON public.categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own categories" ON public.categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own categories" ON public.categories FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own categories" ON public.categories FOR DELETE USING (auth.uid() = user_id);

-- Policies - TAGS
CREATE POLICY "Users can view their own tags" ON public.tags FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own tags" ON public.tags FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own tags" ON public.tags FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own tags" ON public.tags FOR DELETE USING (auth.uid() = user_id);

-- Policies - COST_CENTERS
CREATE POLICY "Users can view their own cost centers" ON public.cost_centers FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own cost centers" ON public.cost_centers FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own cost centers" ON public.cost_centers FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own cost centers" ON public.cost_centers FOR DELETE USING (auth.uid() = user_id);

-- Policies - CREDIT_CARDS
CREATE POLICY "Users can view their own credit cards" ON public.credit_cards FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own credit cards" ON public.credit_cards FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own credit cards" ON public.credit_cards FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own credit cards" ON public.credit_cards FOR DELETE USING (auth.uid() = user_id);

-- Policies - CREDIT_CARD_INVOICES
CREATE POLICY "Users can view invoices of their cards" ON public.credit_card_invoices FOR SELECT
  USING (credit_card_id IN (SELECT id FROM public.credit_cards WHERE user_id = auth.uid()));
CREATE POLICY "Users can insert invoices for their cards" ON public.credit_card_invoices FOR INSERT
  WITH CHECK (credit_card_id IN (SELECT id FROM public.credit_cards WHERE user_id = auth.uid()));
CREATE POLICY "Users can update invoices of their cards" ON public.credit_card_invoices FOR UPDATE
  USING (credit_card_id IN (SELECT id FROM public.credit_cards WHERE user_id = auth.uid()));
CREATE POLICY "Users can delete invoices of their cards" ON public.credit_card_invoices FOR DELETE
  USING (credit_card_id IN (SELECT id FROM public.credit_cards WHERE user_id = auth.uid()));

-- Policies - CASHFLOW_FORECAST
CREATE POLICY "Users can view their own forecasts" ON public.cashflow_forecast FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own forecasts" ON public.cashflow_forecast FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own forecasts" ON public.cashflow_forecast FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own forecasts" ON public.cashflow_forecast FOR DELETE USING (auth.uid() = user_id);

-- Policies - AUDIT_LOG
CREATE POLICY "Users can view their own audit log" ON public.audit_log FOR SELECT USING (auth.uid() = user_id);

-- =====================================================
-- FIM DO SCHEMA
-- =====================================================
