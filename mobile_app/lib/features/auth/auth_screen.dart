import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/features/auth/widgets/auth_card.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: ACGradients.dimmedPrimaryGradient,
            ),
          ),
          const SafeArea(
            child: Center(
              child: AuthCard(),
            ),
          ),
        ],
      ),
    );
  }
}
