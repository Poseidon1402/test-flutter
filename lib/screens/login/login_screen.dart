import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth_bloc.dart';
import '../../shared_components/logo.dart';
part 'components/decorative_icon.dart';
part 'components/login_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'alice@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1335), Color(0xFF2D1B4E)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.15,
              child: _DecorativeIcon(
                icon: Icons.shopping_bag_outlined,
                rotation: -0.2,
                opacity: 0.1,
              ),
            ),
            Positioned(
              top: size.height * 0.25,
              right: size.width * 0.1,
              child: _DecorativeIcon(
                icon: Icons.shopping_bag_outlined,
                rotation: 0.3,
                opacity: 0.08,
              ),
            ),
            Positioned(
              bottom: size.height * 0.3,
              left: size.width * 0.1,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: 0.15,
                opacity: 0.09,
              ),
            ),
            Positioned(
              bottom: size.height * 0.15,
              right: size.width * 0.2,
              child: _DecorativeIcon(
                icon: Icons.card_giftcard_outlined,
                rotation: -0.25,
                opacity: 0.07,
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state.status == AuthStatus.authenticated) {
                            context.goNamed('home');
                          }
                        },
                        builder: (context, state) {
                          return _LoginCard(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onSubmit: _submit,
                            state: state,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Decorative icon and login card moved to components/ parts
