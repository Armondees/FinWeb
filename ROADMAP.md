# ROADMAP - FinWeb

## Visão Geral

Plano de desenvolvimento em 10 fases para completar o sistema financeiro completo.

---

## FASE 1: Fundação Estrutural ✅

**Status:** COMPLETO

### Banco de Dados
- ✅ Schema com 11 tabelas
- ✅ Row Level Security (RLS)
- ✅ Triggers de auditoria
- ✅ Índices de performance
- ✅ Views úteis

### Frontend Base
- ✅ Estrutura HTML/CSS/JS
- ✅ Página de login
- ✅ Dashboard básico
- ✅ Cliente Supabase

---

## FASE 2: Autenticação & Contas 🔄

**Status:** EM PROGRESSO

### Autenticação
- ⬜ Login com email/senha
- ⬜ Cadastro de usuário
- ⬜ Recuperação de senha
- ⬜ Sessão persistente

### Gestão de Contas
- ⬜ CRUD de contas
- ⬜ Listar contas
- ⬜ Editar saldo inicial
- ⬜ Deletar contas

---

## FASE 3: Categorias & Tags

**Status:** PLANEJADO

### Categorias
- ⬜ CRUD de categorias
- ⬜ Categorias pai/filho (hierarquia)
- ⬜ Editar cores
- ⬜ Ativar/desativar

### Tags
- ⬜ CRUD de tags
- ⬜ Associar tags a transações
- ⬜ Filtrar por tags

---

## FASE 4: Transações Básicas

**Status:** PLANEJADO

### CRUD de Transações
- ⬜ Criar transação
- ⬜ Listar transações
- ⬜ Editar transação
- ⬜ Deletar transação

### Filtros & Busca
- ⬜ Filtrar por data
- ⬜ Filtrar por categoria
- ⬜ Filtrar por account
- ⬜ Busca por descrição

### Views
- ⬜ Listar tudo
- ⬜ Apenas receitas
- ⬜ Apenas despesas
- ⬜ Não pagas

---

## FASE 5: Cartões de Crédito

**Status:** PLANEJADO

### Gestão de Cartões
- ⬜ CRUD de cartões
- ⬜ Definir limite de crédito
- ⬜ Definir datas de fechamento
- ⬜ Vincular conta

### Faturas
- ⬜ Gerar faturas automáticas
- ⬜ Listar faturas abertas
- ⬜ Marcar como paga
- ⬜ Ver detalhes da fatura

### Transações de Cartão
- ⬜ Lançar no cartão
- ⬜ Visualizar gastos do mês
- ⬜ Alocar a faturas

---

## FASE 6: Dashboard Avançado

**Status:** PLANEJADO

### Widgets
- ⬜ Saldo total
- ⬜ Receita vs Despesa (mês)
- ⬜ Gastos por categoria (pie chart)
- ⬜ Timeline de transações
- ⬜ Cartões em aberto
- ⬜ Próximos pagamentos

### Gráficos
- ⬜ Chart.js ou similar
- ⬜ Atualização em tempo real
- ⬜ Exportar gráficos

---

## FASE 7: Fluxo de Caixa

**Status:** PLANEJADO

### Previsão
- ⬜ Adicionar receitas/despesas previstas
- ⬜ Definir frequência (mensal, anual)
- ⬜ Visualizar previsão por mês
- ⬜ Comparar real vs previsto

### Análise
- ⬜ Identificar padrões
- ⬜ Alertas de fluxo negativo
- ⬜ Recomendações de economias

---

## FASE 8: Relatórios Detalhados

**Status:** PLANEJADO

### Relatórios Disponíveis
- ⬜ Resumo mensal
- ⬜ Gastos por categoria
- ⬜ Receitas por origem
- ⬜ Transações recorrentes
- ⬜ Análise de cartão de crédito
- ⬜ Fluxo de caixa anual

### Exportação
- ⬜ PDF
- ⬜ CSV/Excel
- ⬜ Impressão

---

## FASE 9: Transações Recorrentes

**Status:** PLANEJADO

### Funcionalidades
- ⬜ Criar recorrências
- ⬜ Automação de lançamentos
- ⬜ Editar/pausar recorrências
- ⬜ Histórico de execuções
- ⬜ Alertas de próximas transações

---

## FASE 10: Deploy & Otimização

**Status:** PLANEJADO

### Deploy
- ⬜ Vercel ou Netlify
- ⬜ Domínio customizado
- ⬜ HTTPS
- ⬜ CDN

### Otimização
- ⬜ Performance (Lighthouse 90+)
- ⬜ Mobile responsivo (100%)
- ⬜ PWA (Progressive Web App)
- ⬜ Offline mode
- ⬜ Service Workers

### Segurança
- ⬜ Audit de segurança
- ⬜ Testes de penetração
- ⬜ OWASP compliance
- ⬜ Rate limiting

---

## Timeline Estimada

```
FASE 1: ████████████████████ (COMPLETO)
FASE 2: ████░░░░░░░░░░░░░░░░ (20%)
FASE 3: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 4: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 5: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 6: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 7: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 8: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 9: ░░░░░░░░░░░░░░░░░░░░ (0%)
FASE 10: ░░░░░░░░░░░░░░░░░░░░ (0%)
```

**Semanas por Fase:**
- FASE 1: 1 semana ✅
- FASE 2: 1 semana 🔄
- FASE 3: 3-5 dias
- FASE 4: 1 semana
- FASE 5: 1 semana
- FASE 6: 1 semana
- FASE 7: 1 semana
- FASE 8: 5-7 dias
- FASE 9: 5-7 dias
- FASE 10: 1-2 semanas

**Total Estimado:** 10-12 semanas para MVP completo

---

## Últimas Atualizações

- 2026-04-27: Roadmap criado
