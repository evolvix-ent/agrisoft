-- =====================================================
-- AGRISOFT - CONFIGURACIÓN DE BASE DE DATOS SUPABASE
-- Migración Idempotente
-- =====================================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLA: parcelas (Migración segura)
-- =====================================================
CREATE TABLE IF NOT EXISTS parcelas (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    nombre TEXT NOT NULL,
    area DOUBLE PRECISION NOT NULL CHECK (area > 0),
    tipo_cultivo TEXT NOT NULL,
    fecha_siembra DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para optimizar consultas (IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_parcelas_user_id ON parcelas(user_id);
CREATE INDEX IF NOT EXISTS idx_parcelas_tipo_cultivo ON parcelas(tipo_cultivo);

-- =====================================================
-- TABLA: labores (Migración segura)
-- =====================================================
CREATE TABLE IF NOT EXISTS labores (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    parcela_id UUID REFERENCES parcelas(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('siembra', 'fertilizacion', 'riego', 'aplicacion', 'cosecha')),
    fecha DATE NOT NULL,
    descripcion TEXT,
    producto TEXT,
    cantidad DOUBLE PRECISION CHECK (cantidad >= 0),
    costo DOUBLE PRECISION CHECK (costo >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para optimizar consultas (IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_labores_parcela_id ON labores(parcela_id);
CREATE INDEX IF NOT EXISTS idx_labores_user_id ON labores(user_id);
CREATE INDEX IF NOT EXISTS idx_labores_tipo ON labores(tipo);
CREATE INDEX IF NOT EXISTS idx_labores_fecha ON labores(fecha DESC);

-- =====================================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- =====================================================
ALTER TABLE parcelas ENABLE ROW LEVEL SECURITY;
ALTER TABLE labores ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS DE SEGURIDAD PARA PARCELAS
-- =====================================================
-- Eliminar políticas existentes antes de crearlas
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can view their own parcels' AND polrelid = 'parcelas'::regclass) THEN
        CREATE POLICY "Users can view their own parcels" 
        ON parcelas FOR SELECT 
        USING (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can insert their own parcels' AND polrelid = 'parcelas'::regclass) THEN
        CREATE POLICY "Users can insert their own parcels" 
        ON parcelas FOR INSERT 
        WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can update their own parcels' AND polrelid = 'parcelas'::regclass) THEN
        CREATE POLICY "Users can update their own parcels" 
        ON parcelas FOR UPDATE 
        USING (auth.uid() = user_id)
        WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can delete their own parcels' AND polrelid = 'parcelas'::regclass) THEN
        CREATE POLICY "Users can delete their own parcels" 
        ON parcelas FOR DELETE 
        USING (auth.uid() = user_id);
    END IF;
END $$;

-- =====================================================
-- POLÍTICAS DE SEGURIDAD PARA LABORES
-- =====================================================
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can view their own labores' AND polrelid = 'labores'::regclass) THEN
        CREATE POLICY "Users can view their own labores" 
        ON labores FOR SELECT 
        USING (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can insert their own labores' AND polrelid = 'labores'::regclass) THEN
        CREATE POLICY "Users can insert their own labores" 
        ON labores FOR INSERT 
        WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can update their own labores' AND polrelid = 'labores'::regclass) THEN
        CREATE POLICY "Users can update their own labores" 
        ON labores FOR UPDATE 
        USING (auth.uid() = user_id)
        WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_policy WHERE polname = 'Users can delete their own labores' AND polrelid = 'labores'::regclass) THEN
        CREATE POLICY "Users can delete their own labores" 
        ON labores FOR DELETE 
        USING (auth.uid() = user_id);
    END IF;
END $$;

-- =====================================================
-- FUNCIÓN PARA ACTUALIZAR updated_at AUTOMÁTICAMENTE
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updated_at
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.triggers WHERE trigger_name = 'update_parcelas_updated_at') THEN
        CREATE TRIGGER update_parcelas_updated_at 
        BEFORE UPDATE ON parcelas 
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT FROM information_schema.triggers WHERE trigger_name = 'update_labores_updated_at') THEN
        CREATE TRIGGER update_labores_updated_at 
        BEFORE UPDATE ON labores 
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- =====================================================
-- VISTA PARA ESTADÍSTICAS DEL DASHBOARD
-- =====================================================
CREATE OR REPLACE VIEW dashboard_stats AS
SELECT 
    p.user_id,
    COUNT(DISTINCT p.id) as total_parcelas,
    COALESCE(SUM(p.area), 0) as area_total,
    COUNT(DISTINCT l.id) as total_labores,
    COALESCE(SUM(l.costo), 0) as costo_total
FROM parcelas p
LEFT JOIN labores l ON p.id = l.parcela_id
GROUP BY p.user_id;

-- Habilitar RLS en la vista
ALTER VIEW dashboard_stats SET (security_invoker = true);