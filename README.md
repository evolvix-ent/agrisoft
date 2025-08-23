# 🌱 AgriSoft by Evolvix Enterprise - Gestión Agrícola Inteligente

**AgriSoft** es una aplicación moderna y completa para la gestión agrícola desarrollada por **Evolvix Enterprise**, diseñada para ayudar a agricultores y empresas del sector a optimizar sus operaciones, aumentar la productividad y tomar decisiones basadas en datos.

## 🚀 Características

- **Autenticación**: Registro e inicio de sesión con email y contraseña
- **Gestión de Parcelas**: CRUD completo para parcelas agrícolas
- **Cuaderno de Labores**: Registro y seguimiento de actividades agrícolas
- **Dashboard**: Resumen de parcelas y labores recientes

- **Tema Material 3**: Diseño moderno con colores verde y marrón

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL + Auth + Real-time)
- **Gestión de Estado**: Riverpod
- **Navegación**: GoRouter
- **Formularios**: Flutter Form Builder


## 📋 Requisitos Previos

1. **Flutter SDK** (versión 3.24.0 o superior)
2. **Cuenta en Supabase** (gratuita)
3. **Cuenta en GitHub** (para despliegue automático)

## 🔧 Configuración del Proyecto

### 1. Configurar Supabase

1. Ve a [supabase.com](https://supabase.com) y crea una cuenta
2. Crea un nuevo proyecto llamado "agrisoft"
3. Ve al **SQL Editor** y ejecuta el script completo de `supabase_setup.sql`
4. Ve a **Settings > API** y copia:
   - Project URL
   - Anon key (clave pública)

### 2. Configurar Flutter

1. Clona o descarga este proyecto
2. Ejecuta `flutter pub get` para instalar dependencias
3. Abre `lib/src/core/constants.dart` y reemplaza:
   - `TU_SUPABASE_URL_AQUI` con tu Project URL
   - `TU_SUPABASE_ANON_KEY_AQUI` con tu Anon key
### 3. Generar Código

Ejecuta los siguientes comandos para generar el código necesario:

```bash
# Generar modelos JSON
flutter packages pub run build_runner build

# Si hay conflictos, usar --delete-conflicting-outputs
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Ejecutar la Aplicación

```bash
# Desarrollo (con hot reload)
flutter run

# Desarrollo web
flutter run -d chrome

# Producción (optimizada)
flutter run --release
```

## 🚀 Despliegue a Producción

### Despliegue Automático con GitHub Pages

1. **Configurar repositorio**:
   ```bash
   git remote add origin https://github.com/evolvix-ent/agrisoft.git
   git push -u origin main
   ```

2. **Habilitar GitHub Pages**:
   - Ve a Settings > Pages en tu repositorio
   - Source: GitHub Actions
   - El despliegue será automático en cada push

3. **Configurar URLs**:
   - Actualiza `productionBaseUrl` en `lib/src/core/config/auth_config.dart`
   - Configura las URLs en Supabase Dashboard

### Build Manual

```bash
# Hacer ejecutable el script
chmod +x scripts/build_production.sh

# Ejecutar build de producción
./scripts/build_production.sh
```

📖 **Para más detalles, consulta [DEPLOYMENT.md](DEPLOYMENT.md)**

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── src/
│   ├── core/                         # Configuración global
│   │   ├── constants.dart            # Constantes y configuración
│   │   ├── theme.dart               # Tema Material 3
│   │   └── router.dart              # Configuración de rutas
│   └── features/                    # Características por módulo
│       ├── auth/                    # Autenticación
│       │   └── presentation/
│       │       ├── login_screen.dart
│       │       └── register_screen.dart
│       ├── dashboard/               # Dashboard principal
│       │   └── presentation/
│       │       └── dashboard_screen.dart
│       ├── parcelas/               # Gestión de parcelas
│       │   ├── models/
│       │   │   └── parcela.dart
│       │   ├── services/
│       │   │   └── parcelas_service.dart
│       │   └── presentation/
│       │       ├── parcelas_list_screen.dart
│       │       └── parcela_form_screen.dart
│       └── labores/                # Cuaderno de labores
│           ├── models/
│           │   └── labor.dart
│           └── presentation/
│               ├── labores_list_screen.dart
│               └── labor_form_screen.dart
```

## 🗄️ Base de Datos

### Tablas Principales

#### `parcelas`
- `id` (UUID, PK)
- `user_id` (UUID, FK a auth.users)
- `nombre` (TEXT)
- `area` (DOUBLE PRECISION) - en hectáreas
- `tipo_cultivo` (TEXT)
- `fecha_siembra` (DATE, opcional)
- `created_at`, `updated_at` (TIMESTAMP)

#### `labores`
- `id` (UUID, PK)
- `parcela_id` (UUID, FK a parcelas)
- `user_id` (UUID, FK a auth.users)
- `tipo` (TEXT) - siembra, fertilizacion, riego, aplicacion, cosecha
- `fecha` (DATE)
- `descripcion` (TEXT, opcional)
- `producto` (TEXT, opcional)
- `cantidad` (DOUBLE PRECISION, opcional)
- `costo` (DOUBLE PRECISION, opcional)
- `created_at`, `updated_at` (TIMESTAMP)

### Seguridad (RLS)

- **Row Level Security** habilitado en todas las tablas
- Los usuarios solo pueden acceder a sus propios datos
- Políticas automáticas para SELECT, INSERT, UPDATE, DELETE

## 🎨 Diseño

### Colores
- **Primario**: Verde #4CAF50 (agricultura)
- **Secundario**: Marrón #795548 (tierra)
- **Acentos**: Verde claro #81C784

### Componentes
- Material 3 Design
- Cards con bordes redondeados (12px)
- Iconografía consistente
- Formularios con validación

## 🚧 Estado Actual (MVP)

### ✅ Completado
- Estructura base del proyecto
- Configuración de Supabase y Flutter
- Modelos de datos (Parcela, Labor)
- Pantallas de autenticación
- Navegación con GoRouter
- Tema Material 3
- Formularios básicos

### 🔄 En Desarrollo
- Integración completa con Supabase
- Funcionalidad CRUD real
- Validaciones avanzadas
- Manejo de errores mejorado

### 📋 Próximas Características
- Integración con OpenWeatherMap
- Búsqueda y filtros
- Estadísticas avanzadas
- Notificaciones
- Exportación de datos
- Modo offline

## 🧪 Testing

Para ejecutar las pruebas:

```bash
flutter test
```

## 📱 Plataformas Soportadas

- ✅ Android
- ✅ iOS
- 🔄 Web (en desarrollo)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -am 'Agrega nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Si tienes problemas con la configuración:

1. Verifica que todas las constantes en `constants.dart` estén configuradas
2. Asegúrate de que el script SQL se ejecutó correctamente en Supabase
3. Confirma que las dependencias están instaladas (`flutter pub get`)
4. Ejecuta `flutter doctor` para verificar tu entorno Flutter

## 🔗 Enlaces Útiles

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Supabase](https://supabase.com/docs)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [Material 3 Design](https://m3.material.io/)

---

**AgriSoft by Evolvix Enterprise** - Gestión Agrícola Inteligente 🌱
# agrisoft
