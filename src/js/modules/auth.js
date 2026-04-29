// =====================================================
// AUTH.JS - Módulo de Autenticação
// =====================================================

import { getSupabase, getCurrentUser } from '../utils/db.js';
import { validators } from '../utils/validators.js';

/**
 * Login com email e senha
 */
export const loginUser = async (email, password) => {
  if (!validators.email(email)) {
    throw new Error('❌ Email inválido');
  }
  
  if (!validators.password(password)) {
    throw new Error('❌ Senha deve ter pelo menos 6 caracteres');
  }
  
  const supabase = getSupabase();
  
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  });
  
  if (error) throw new Error(`❌ Erro ao fazer login: ${error.message}`);
  
  console.log('✅ Login realizado com sucesso');
  return data;
};

/**
 * Registrar novo usuário
 */
export const registerUser = async (email, password, passwordConfirm) => {
  if (!validators.email(email)) {
    throw new Error('❌ Email inválido');
  }
  
  if (!validators.password(password)) {
    throw new Error('❌ Senha deve ter pelo menos 6 caracteres');
  }
  
  if (password !== passwordConfirm) {
    throw new Error('❌ Senhas não conferem');
  }
  
  const supabase = getSupabase();
  
  const { data, error } = await supabase.auth.signUp({
    email,
    password
  });
  
  if (error) throw new Error(`❌ Erro ao registrar: ${error.message}`);
  
  console.log('✅ Usuário registrado com sucesso');
  return data;
};

/**
 * Logout
 */
export const logoutUser = async () => {
  const supabase = getSupabase();
  
  const { error } = await supabase.auth.signOut();
  
  if (error) throw new Error(`❌ Erro ao fazer logout: ${error.message}`);
  
  console.log('✅ Logout realizado com sucesso');
  window.location.href = '/public/login.html';
};

/**
 * Verificar autenticação
 */
export const requireAuth = async () => {
  const user = await getCurrentUser();
  
  if (!user) {
    console.warn('⚠️ Usuário não autenticado, redirecionando...');
    window.location.href = '/public/login.html';
    return null;
  }
  
  return user;
};
