// =====================================================
// FORMAT.JS - Utilitários de Formatação
// =====================================================

export const format = {
  /**
   * Formata valor monetário em Real brasileiro
   * Ex: 1234.5 → "R$ 1.234,50"
   */
  money: (value) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value ?? 0);
  },

  /**
   * Formata data para pt-BR
   * Ex: "2024-04-28" → "28/04/2024"
   */
  date: (value) => {
    if (!value) return '-';
    return new Intl.DateTimeFormat('pt-BR').format(new Date(value));
  },

  /**
   * Formata data e hora para pt-BR
   * Ex: "2024-04-28T14:30:00" → "28/04/2024 14:30"
   */
  datetime: (value) => {
    if (!value) return '-';
    return new Intl.DateTimeFormat('pt-BR', {
      dateStyle: 'short',
      timeStyle: 'short'
    }).format(new Date(value));
  },

  /**
   * Formata número com casas decimais
   * Ex: 1234.5678 → "1.234,57"
   */
  number: (value, decimals = 2) => {
    return new Intl.NumberFormat('pt-BR', {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals
    }).format(value ?? 0);
  },

  /**
   * Formata porcentagem
   * Ex: 0.1567 → "15,67%"
   */
  percent: (value, decimals = 2) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'percent',
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals
    }).format(value ?? 0);
  }
};