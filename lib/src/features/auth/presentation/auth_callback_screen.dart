import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pantalla para manejar callbacks de autenticación de Supabase
class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  bool _isLoading = true;
  String _message = 'Procesando autenticación...';

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    try {
      // Obtener los parámetros de la URL
      final uri = Uri.base;
      final accessToken = uri.queryParameters['access_token'];
      final refreshToken = uri.queryParameters['refresh_token'];
      final type = uri.queryParameters['type'];

      if (accessToken != null && refreshToken != null) {
        // Establecer la sesión usando el refresh token
        await Supabase.instance.client.auth.setSession(refreshToken);

        setState(() {
          _message = '¡Autenticación exitosa! Redirigiendo...';
        });

        // Redirigir al dashboard
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/dashboard');
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _message = 'Error en la autenticación. Parámetros inválidos.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _message = 'Error al procesar la autenticación: ${error.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2ED573).withValues(alpha: 0.1),
              const Color(0xFF3742FA).withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo de AgriSoft
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          size: 48,
                          color: Color(0xFF2ED573),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título
                      Text(
                        'AgriSoft',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2ED573),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Indicador de carga o mensaje
                      if (_isLoading) ...[
                        const CircularProgressIndicator(
                          color: Color(0xFF2ED573),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Mensaje
                      Text(
                        _message,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),

                      // Botón de acción si hay error
                      if (!_isLoading) ...[
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/auth/login'),
                          child: const Text('Volver al Login'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
