// =====================================================
// DB.JS - Cliente Supabase
// =====================================================

import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2';

let supabase = null;

/**
 * Inicializar Supabase
 */
export const initSupabase = async () => {
  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
  const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
  
  if (!supabaseUrl || !supabaseKey) {
    throw new Error('❌ Variáveis de ambiente Supabase não configuradas!');
  }
  
  supabase = createClient(supabaseUrl, supabaseKey);
  console.log('✅ Supabase inicializado');
  return supabase;
};

/**
 * Obter instância do Supabase
 */
export const getSupabase = () => {
  if (!supabase) {
    throw new Error('❌ Supabase não foi inicializado!');
  }
  return supabase;
};

/**
 * Obter usuário atual
 */
export const getCurrentUser = async () => {
  const sb = getSupabase();
  const { data: { user } } = await sb.auth.getUser();
  return user;
};

/**
 * Obter sessão
 */
export const getSession = async () => {
  const sb = getSupabase();
  const { data: { session } } = await sb.auth.getSession();
  return session;
};

/**
 * Operações de banco de dados
 */
export const db = {
  /**
   * SELECT
   */
  select: async (table, options = {}) => {
    const sb = getSupabase();
    let query = sb.from(table).select('*');
    
    if (options.eq) {
      Object.entries(options.eq).forEach(([key, value]) => {
        query = query.eq(key, value);
      });
    }
    
    if (options.order) {
      query = query.order(options.order.column, { ascending: options.order.asc ?? false });
    }
    
    if (options.limit) {
      query = query.limit(options.limit);
    }
    
    const { data, error } = await query;
    if (error) throw error;
    return data;
  },
  
  /**
   * INSERT
   */
  insert: async (table, data) => {
    const sb = getSupabase();
    const { data: result, error } = await sb.from(table).insert([data]);
    if (error) throw error;
    return result;
  },
  
  /**
   * UPDATE
   */
  update: async (table, data, id) => {
    const sb = getSupabase();
    const { data: result, error } = await sb
      .from(table)
      .update(data)
      .eq('id', id);
    if (error) throw error;
    return result;
  },
  
  /**
   * DELETE
   */
  delete: async (table, id) => {
    const sb = getSupabase();
    const { error } = await sb.from(table).delete().eq('id', id);
    if (error) throw error;
    return true;
  }
};
