import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/email_confirmation_screen.dart';
import '../features/auth/presentation/auth_callback_screen.dart';
import '../features/auth/presentation/resend_confirmation_screen.dart';
import '../features/parcelas/presentation/parcela_form_screen.dart';
import '../features/labores/presentation/labor_form_screen.dart';
import 'navigation/responsive_main_navigation.dart';

/// Provider para el router de la aplicación
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // Si no está logueado y no está en una ruta de auth, redirigir a login
      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }
      
      // Si está logueado y está en una ruta de auth, redirigir al dashboard
      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      // =====================================================
      // RUTAS DE AUTENTICACIÓN
      // =====================================================
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/confirm',
        name: 'email-confirmation',
        builder: (context, state) => const EmailConfirmationScreen(),
      ),
      GoRoute(
        path: '/auth/callback',
        name: 'auth-callback',
        builder: (context, state) => const AuthCallbackScreen(),
      ),
      GoRoute(
        path: '/auth/resend',
        name: 'resend-confirmation',
        builder: (context, state) => const ResendConfirmationScreen(),
      ),
      
      // =====================================================
      // RUTA PRINCIPAL CON NAVEGACIÓN INFERIOR
      // =====================================================
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const ResponsiveMainNavigation(),
      ),

      // =====================================================
      // RUTAS DE FORMULARIOS (PANTALLAS COMPLETAS)
      // =====================================================
      GoRoute(
        path: '/parcelas/nueva',
        name: 'nueva-parcela',
        builder: (context, state) => const ParcelaFormScreen(),
      ),
      GoRoute(
        path: '/parcelas/editar/:id',
        name: 'editar-parcela',
        builder: (context, state) {
          final parcelaId = state.pathParameters['id']!;
          return ParcelaFormScreen(parcelaId: parcelaId);
        },
      ),
      GoRoute(
        path: '/labores/nueva',
        name: 'nueva-labor',
        builder: (context, state) {
          final parcelaId = state.uri.queryParameters['parcela_id'];
          return LaborFormScreen(parcelaId: parcelaId);
        },
      ),
      GoRoute(
        path: '/labores/editar/:id',
        name: 'editar-labor',
        builder: (context, state) {
          final laborId = state.pathParameters['id']!;
          return LaborFormScreen(laborId: laborId);
        },
      ),
    ],
    
    // =====================================================
    // MANEJO DE ERRORES
    // =====================================================
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'La página "${state.matchedLocation}" no existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Ir al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Extensiones útiles para navegación
extension GoRouterExtension on GoRouter {
  /// Navega al dashboard principal
  void goToDashboard() => go('/dashboard');

  /// Navega al login
  void goToLogin() => go('/auth/login');

  /// Navega al registro
  void goToRegister() => go('/auth/register');

  /// Navega a crear nueva parcela
  void goToNuevaParcela() => go('/parcelas/nueva');

  /// Navega a editar parcela
  void goToEditarParcela(String parcelaId) => go('/parcelas/editar/$parcelaId');

  /// Navega a crear nueva labor
  void goToNuevaLabor({String? parcelaId}) {
    final query = parcelaId != null ? '?parcela_id=$parcelaId' : '';
    go('/labores/nueva$query');
  }

  /// Navega a editar labor
  void goToEditarLabor(String laborId) => go('/labores/editar/$laborId');

  /// Regresa a la pestaña de parcelas
  void goBackToParcelas() => go('/dashboard');

  /// Regresa a la pestaña de labores
  void goBackToLabores() => go('/dashboard');
}
