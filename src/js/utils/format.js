// =====================================================
// FORMAT.JS - Funções de Formatação
// =====================================================

export const format = {
  /**
   * Formatar moeda (BRL)
   */
  money: (value) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value);
  },
  
  /**
   * Formatar data (dd/mm/yyyy)
   */
  date: (dateString) => {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('pt-BR').format(date);
  },
  
  /**
   * Formatar data e hora
   */
  dateTime: (dateString) => {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('pt-BR', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  },
  
  /**
   * Formatar percentual
   */
  percent: (value) => {
    return `${(value * 100).toFixed(2)}%`;
  }
};
