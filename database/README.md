# Database - Instruções de Setup

## 🚀 Setup Supabase

### Passo 1: Criar Projeto Supabase

1. Acesse https://supabase.com
2. Crie uma conta (gratuita)
3. Crie um novo projeto
4. Aguarde a inicialização (5-10 minutos)

### Passo 2: Executar Schema

1. Vá em **SQL Editor**
2. Clique em **New Query**
3. Copie todo o conteúdo de `schema-completo.sql`
4. Cole na query
5. Clique **Run**
6. ⏳ Aguarde completar (30-60 segundos)

### Passo 3: Executar Migração

1. **New Query** novamente
2. Copie todo o conteúdo de `migrate-transactions-evolve.sql`
3. Cole e clique **Run**
4. ⏳ Aguarde completar

### Passo 4: Verificar Tabelas

Vá em **Tables** no painel esquerdo e verifique se criou:

```
✅ accounts
✅ categories
✅ tags
✅ cost_centers
✅ credit_cards
✅ transactions
✅ credit_card_invoices
✅ credit_card_transactions
✅ cashflow_forecast
✅ transaction_tags
✅ audit_log
```

## 📊 Estrutura das Tabelas

### accounts
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key (auth.users)
name (VARCHAR)
account_type (VARCHAR) - checking|savings|investment
bank_name (VARCHAR)
account_number (VARCHAR)
initial_balance (DECIMAL)
current_balance (DECIMAL)
is_active (BOOLEAN)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### categories
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key
name (VARCHAR)
type (VARCHAR) - income|expense
color (VARCHAR)
is_active (BOOLEAN)
parent_id (UUID) - Foreign Key (self)
created_at (TIMESTAMP)
```

### transactions
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key
account_id (UUID) - Foreign Key
category_id (UUID) - Foreign Key
credit_card_id (UUID) - Foreign Key
cost_center_id (UUID) - Foreign Key

-- Colunas originais
descricao (TEXT)
valor (NUMERIC)
tipo (VARCHAR) - income|expense|transfer
data (DATE)
pago (BOOLEAN)
criado_em (TIMESTAMP)
categoria (VARCHAR) - LEGADO

-- Novas colunas
transaction_date (DATE)
paid_status (VARCHAR) - pending|paid|overdue
is_recurring (BOOLEAN)
recurring_frequency (VARCHAR)
notes (TEXT)
updated_at (TIMESTAMP)
```

### credit_cards
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key
account_id (UUID) - Foreign Key
name (VARCHAR)
last_digits (VARCHAR)
credit_limit (DECIMAL)
closing_day (INTEGER)
due_day (INTEGER)
current_balance (DECIMAL)
is_active (BOOLEAN)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### credit_card_invoices
```sql
id (UUID) - Primary Key
credit_card_id (UUID) - Foreign Key
opening_date (DATE)
closing_date (DATE)
due_date (DATE)
total_amount (DECIMAL)
paid_amount (DECIMAL)
status (VARCHAR) - open|closed|paid
payment_date (TIMESTAMP)
created_at (TIMESTAMP)
```

### cashflow_forecast
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key
account_id (UUID) - Foreign Key
category_id (UUID) - Foreign Key
description (VARCHAR)
amount (DECIMAL)
type (VARCHAR) - income|expense
forecast_date (DATE)
frequency (VARCHAR) - once|monthly|yearly
is_active (BOOLEAN)
created_at (TIMESTAMP)
```

### audit_log
```sql
id (UUID) - Primary Key
user_id (UUID) - Foreign Key
action (VARCHAR) - INSERT|UPDATE|DELETE
table_name (VARCHAR)
record_id (UUID)
old_values (JSONB)
new_values (JSONB)
created_at (TIMESTAMP)
```

## 🔐 Row Level Security (RLS)

Todas as tabelas têm RLS habilitado com políticas:

- **SELECT:** Usuário vê apenas seus dados
- **INSERT:** Usuário insere apenas com seu user_id
- **UPDATE:** Usuário edita apenas seus dados
- **DELETE:** Usuário deleta apenas seus dados

## 🔔 Triggers de Auditoria

Cada alteração (INSERT/UPDATE/DELETE) é registrada automaticamente em `audit_log` com:

- Ação realizada
- Tabela modificada
- ID do registro
- Valores antes (para UPDATE/DELETE)
- Valores depois (para INSERT/UPDATE)
- Timestamp

## 🔄 Trigger de updated_at

Colunas `updated_at` são sincronizadas automaticamente em:

- accounts
- credit_cards
- transactions

## 📈 Índices para Performance

Criados índices em:

- transactions(user_id, transaction_date DESC)
- accounts(user_id)
- credit_cards(user_id, account_id)
- categories(user_id, type)
- cashflow_forecast(user_id, forecast_date)
- audit_log(user_id, created_at DESC)

## 🧪 Testar Conexão

No seu `src/js/utils/db.js`:

```javascript
// Teste de conexão
const testConnection = async () => {
  const { data, error } = await supabase.auth.getUser();
  if (error) console.error('Erro de conexão:', error);
  else console.log('Conectado com sucesso!', data);
};
```

## 🆘 Troubleshooting

### Erro: "permission denied"
- Verifique se você está logado no Supabase
- Verifique se as permissões de RLS estão corretas

### Erro: "relation does not exist"
- Execute o schema completo novamente
- Verifique se todas as tabelas foram criadas

### Erro: "foreign key violation"
- Verifique se os IDs existem nas tabelas referenciadas
- Verifique a ordem de inserção de dados

### Dados desaparecendo
- Verifique RLS policies
- Verifique se user_id está correto

## 📚 Referências

- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL RLS](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
