import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pantalla para manejar la confirmación de email
class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  State<EmailConfirmationScreen> createState() => _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  bool _isLoading = true;
  bool _isSuccess = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _handleEmailConfirmation();
  }

  Future<void> _handleEmailConfirmation() async {
    try {
      // Obtener los parámetros de la URL
      final uri = Uri.base;
      final token = uri.queryParameters['token'];
      final type = uri.queryParameters['type'];

      if (token != null && type == 'signup') {
        // Verificar el token de confirmación
        final response = await Supabase.instance.client.auth.verifyOTP(
          token: token,
          type: OtpType.signup,
        );

        if (response.user != null) {
          setState(() {
            _isSuccess = true;
            _message = '¡Email confirmado exitosamente! Ya puedes iniciar sesión.';
            _isLoading = false;
          });

          // Redirigir al login después de 3 segundos
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              context.go('/auth/login');
            }
          });
        } else {
          setState(() {
            _isSuccess = false;
            _message = 'Error al confirmar el email. El enlace puede haber expirado.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isSuccess = false;
          _message = 'Enlace de confirmación inválido.';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isSuccess = false;
        _message = 'Error al confirmar el email: ${error.toString()}';
        _isLoading = false;
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
                      // Logo o ícono
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isLoading 
                              ? Colors.blue.withValues(alpha: 0.1)
                              : _isSuccess 
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          _isLoading 
                              ? Icons.email_outlined
                              : _isSuccess 
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                          size: 48,
                          color: _isLoading 
                              ? Colors.blue
                              : _isSuccess 
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título
                      Text(
                        _isLoading 
                            ? 'Confirmando Email...'
                            : _isSuccess 
                                ? '¡Email Confirmado!'
                                : 'Error de Confirmación',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isLoading 
                              ? Colors.blue
                              : _isSuccess 
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Mensaje
                      if (_isLoading)
                        const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Verificando tu email...',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      else
                        Text(
                          _message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 24),

                      // Botones de acción
                      if (!_isLoading) ...[
                        if (_isSuccess)
                          ElevatedButton.icon(
                            onPressed: () => context.go('/auth/login'),
                            icon: const Icon(Icons.login),
                            label: const Text('Ir al Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          )
                        else
                          Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => context.go('/auth/register'),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Intentar Nuevamente'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => context.go('/auth/login'),
                                child: const Text('Volver al Login'),
                              ),
                            ],
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
