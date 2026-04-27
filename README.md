# FinWeb - Sistema Financeiro Completo

## 📊 Visão Geral

FinWeb é um sistema financeiro completo desenvolvido com **Supabase** e **JavaScript vanilla**, oferecendo:

- ✅ Gestão de contas correntes, poupança e investimentos
- ✅ Rastreamento de transações com categorias
- ✅ Cartões de crédito e faturas
- ✅ Fluxo de caixa e previsões
- ✅ Relatórios detalhados
- ✅ Row Level Security (RLS) - Segurança por usuário
- ✅ Auditoria automática de todas as mudanças

## 🛠️ Stack Tecnológico

- **Backend:** Supabase (PostgreSQL + Auth)
- **Frontend:** HTML5 + CSS3 + JavaScript Vanilla
- **Autenticação:** Supabase Auth
- **Banco de Dados:** PostgreSQL com RLS
- **Segurança:** Row Level Security + Triggers de Auditoria

## 🚀 Quick Start

### 1. Configurar Supabase

```bash
1. Acesse https://supabase.com
2. Crie um novo projeto (gratuito)
3. Vá em SQL Editor
4. Execute: database/schema-completo.sql
5. Execute: database/migrate-transactions-evolve.sql
```

### 2. Configurar Variáveis de Ambiente

```bash
cp .env.example .env.local

# Edite .env.local com suas credenciais:
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua-anon-key-aqui
```

### 3. Iniciar o Servidor

```bash
# Abra index.html no navegador ou use um servidor local
python -m http.server 8000
# ou
npx http-server
```

## 📁 Estrutura do Projeto

```
finweb/
├── database/
│   ├── schema-completo.sql (11 tabelas)
│   ├── migrate-transactions-evolve.sql (migração)
│   └── README.md (instruções)
├── src/
│   ├── js/
│   │   ├── app.js (app principal)
│   │   ├── utils/
│   │   │   ├── db.js (cliente Supabase)
│   │   │   ├── format.js (formatações)
│   │   │   ├── validators.js (validações)
│   │   │   └── api.js (helpers de API)
│   │   └── modules/
│   │       ├── auth.js (autenticação)
│   │       ├── accounts.js (contas)
│   │       ├── categories.js (categorias)
│   │       ├── transactions.js (transações)
│   │       ├── cards.js (cartões)
│   │       ├── reports.js (relatórios)
│   │       └── cashflow.js (fluxo de caixa)
│   └── css/
│       ├── global.css (estilos globais)
│       ├── components.css (componentes)
│       ├── pages.css (páginas)
│       └── dashboard.css (dashboard)
├── public/
│   ├── index.html (dashboard)
│   ├── login.html (login)
│   ├── signup.html (cadastro)
│   ├── accounts.html (contas)
│   ├── categories.html (categorias)
│   ├── transactions.html (transações)
│   ├── cards.html (cartões)
│   ├── reports.html (relatórios)
│   └── settings.html (configurações)
├── .env.example (variáveis de exemplo)
├── .gitignore
└── ROADMAP.md (plano do projeto)
```

## 🔐 Segurança

### Row Level Security (RLS)
- Cada usuário vê apenas seus próprios dados
- Políticas automáticas em todas as tabelas
- Impossible para usuário acessar dados de outro

### Auditoria
- Todas as mudanças são registradas em `audit_log`
- Rastreia: INSERT, UPDATE, DELETE
- Armazena valores antes/depois em JSON
- Rastreability completa

## 📊 Tabelas do Banco de Dados

```
┌─ CONFIGURAÇÃO ────────────────────┐
│ • accounts (contas)
│ • categories (categorias)
│ • tags (tags)
│ • cost_centers (centros de custo)
│ • credit_cards (cartões)
├─ MOVIMENTAÇÃO ────────────────────┤
│ • transactions (transações)
│ • credit_card_invoices (faturas)
│ • credit_card_transactions (relação)
│ • cashflow_forecast (fluxo previsto)
│ • transaction_tags (relação)
├─ AUDITORIA ────────────────────┤
│ • audit_log (rastreamento)
└────────────────────────────────┘
```

## 🎯 Roadmap

Ver `ROADMAP.md` para o plano de desenvolvimento em 10 fases.

## 📝 Documentação

- `database/README.md` - Instruções de setup do banco
- `ROADMAP.md` - Plano completo do projeto

## 💡 Features Principais

### Gestão de Contas
- Criar/editar/deletar contas
- Rastrear saldo em tempo real
- Suporte a múltiplos tipos (corrente, poupança, investimento)

### Transações
- CRUD completo de transações
- Categorização automática
- Recorrências (mensal, anual, etc)
- Tags customizadas
- Auditoria de alterações

### Cartões de Crédito
- Gestão de cartões
- Faturas automáticas
- Rastreamento de gastos
- Alertas de vencimento

### Relatórios
- Visão geral financeira
- Gastos por categoria
- Fluxo de caixa
- Previsões
- Exportação de dados

## 🤝 Contribuindo

Este é um projeto pessoal. Sinta-se livre para fazer fork e melhorar!

## 📄 Licença

MIT

## 👤 Autor

Armondees

---

**Últimas Atualizações:** 2026-04-27
