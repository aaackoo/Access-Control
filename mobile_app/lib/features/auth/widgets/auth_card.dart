import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/notifiers/auth_notifier.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/features/auth/widgets/auth_header.dart';
import 'package:access_control/features/auth/widgets/demo_accounts_section.dart';
import 'package:access_control/features/auth/widgets/error_display.dart';
import 'package:access_control/features/auth/widgets/submit_button.dart';
import 'package:access_control/features/widgets/general_input_field.dart';
import 'package:access_control/flavors.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthCard extends ConsumerStatefulWidget {
  const AuthCard({super.key});

  @override
  ConsumerState<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends ConsumerState<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ref.read(authNotifierProvider.notifier).clearError();

    await ref.read(authNotifierProvider.notifier).signIn(
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go(Routes.home);
      }
    });

    return Card(
      color: ACColors.background,
      elevation: 8,
      margin: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 400,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(),
                  const SizedBox(height: 32),
                  GeneralInputField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    label: context.l10n.emailLabel,
                    hintText: context.l10n.emailHint,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return '${context.l10n.enterCorrectEmail}!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GeneralInputField(
                    controller: _passwordController,
                    icon: Icons.lock_outlined,
                    label: context.l10n.passwordLabel,
                    hintText: context.l10n.passwordHint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${context.l10n.enterCorrectPassword}!';
                      }
                      return null;
                    },
                    onSubmit: _submit,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (authState.hasError)
                    ErrorDisplay(error: authState.error ?? ''),
                  SubmitButton(
                    isLoading: authState.isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),
                  if (Flavors.appFlavor == FlavorOption.dev)
                    DemoAccountsSection(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
