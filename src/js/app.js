// =====================================================
// APP.JS - Aplicação Principal
// =====================================================

import { initSupabase, getCurrentUser } from './utils/db.js';
import { loginUser, logoutUser, registerUser } from './modules/auth.js';

const app = {
  init: async function() {
    console.log('🚀 Inicializando FinWeb...');
    
    // Inicializar Supabase
    await initSupabase();
    
    // Verificar se usuário está autenticado
    const user = await getCurrentUser();
    
    if (user) {
      console.log('✅ Usuário logado:', user.email);
      this.loadDashboard();
    } else {
      console.log('⚠️ Usuário não autenticado');
      this.loadLoginPage();
    }
  },
  
  loadDashboard: function() {
    console.log('📊 Carregando dashboard...');
    window.location.href = '/dashboard.html';
  },
  
  loadLoginPage: function() {
    console.log('🔐 Carregando página de login...');
    window.location.href = '/login.html';
  }
};

// Iniciar app quando DOM estiver pronto
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => app.init());
} else {
  app.init();
}

export default app;
