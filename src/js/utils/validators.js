// =====================================================
// VALIDATORS.JS - Funções de Validação
// =====================================================

export const validators = {
  /**
   * Validar email
   */
  email: (email) => {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  },
  
  /**
   * Validar senha
   */
  password: (password) => {
    return password && password.length >= 6;
  },
  
  /**
   * Validar valor monetário
   */
  money: (value) => {
    const num = parseFloat(value);
    return !isNaN(num) && num >= 0;
  },
  
  /**
   * Validar data
   */
  date: (date) => {
    return !isNaN(Date.parse(date));
  },
  
  /**
   * Validar string não vazia
   */
  required: (value) => {
    return value && value.trim().length > 0;
  }
};
