import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/auth_config.dart';

/// Pantalla para reenviar email de confirmación
class ResendConfirmationScreen extends StatefulWidget {
  const ResendConfirmationScreen({super.key});

  @override
  State<ResendConfirmationScreen> createState() => _ResendConfirmationScreenState();
}

class _ResendConfirmationScreenState extends State<ResendConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resendConfirmation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: _emailController.text.trim(),
        emailRedirectTo: AuthConfig.emailConfirmUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de confirmación reenviado. Revisa tu bandeja de entrada.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        context.go('/auth/login');
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al reenviar confirmación'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            size: 48,
                            color: Color(0xFF2ED573),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título
                        Text(
                          'Reenviar Confirmación',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2ED573),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Descripción
                        Text(
                          'Ingresa tu email para reenviar el enlace de confirmación',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Campo de email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'tu@email.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Por favor ingresa un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Botón de reenvío
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _resendConfirmation,
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.send),
                            label: Text(_isLoading ? 'Enviando...' : 'Reenviar Confirmación'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Enlace de vuelta al login
                        TextButton(
                          onPressed: _isLoading ? null : () => context.go('/auth/login'),
                          child: const Text('Volver al Login'),
                        ),
                      ],
                    ),
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
