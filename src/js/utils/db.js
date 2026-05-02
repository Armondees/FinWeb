// =====================================================
// DB.JS - Cliente Supabase
// =====================================================

import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from './config.js';

// ... (resto do seu código db.js)
export let supabase = null; // Mude de 'let' para 'export let'

export const initSupabase = () => {
  if (!SUPABASE_URL || SUPABASE_URL.includes('SEU_PROJECT_ID')) {
    throw new Error('❌ Configure as credenciais em src/js/utils/config.js!');
  }
  supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  console.log('✅ Supabase inicializado');
  return supabase;
};
// ...

export const getSupabase = () => {
  if (!supabase) throw new Error('❌ Supabase não foi inicializado! Chame initSupabase() primeiro.');
  return supabase;
};

export const getCurrentUser = async () => {
  const { data: { user } } = await getSupabase().auth.getUser();
  return user;
};

export const getSession = async () => {
  const { data: { session } } = await getSupabase().auth.getSession();
  return session;
};

export const db = {
  select: async (table, options = {}) => {
    let query = getSupabase().from(table).select('*');
    if (options.eq) Object.entries(options.eq).forEach(([k, v]) => { query = query.eq(k, v); });
    if (options.order) query = query.order(options.order.column, { ascending: options.order.asc ?? false });
    if (options.limit) query = query.limit(options.limit);
    const { data, error } = await query;
    if (error) throw error;
    return data;
  },
  insert: async (table, data) => {
    const { data: result, error } = await getSupabase().from(table).insert([data]);
    if (error) throw error;
    return result;
  },
  update: async (table, data, id) => {
    const { data: result, error } = await getSupabase().from(table).update(data).eq('id', id);
    if (error) throw error;
    return result;
  },
  delete: async (table, id) => {
    const { error } = await getSupabase().from(table).delete().eq('id', id);
    if (error) throw error;
    return true;
  }
};
