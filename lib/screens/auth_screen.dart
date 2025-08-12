import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_nav_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService auth = AuthService();
  bool _hasAuthenticated = false;

  @override
  void initState() {
    super.initState();

    // Defer biometric check until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runBiometric();
    });
  }

  Future<void> _runBiometric() async {
    if (_hasAuthenticated) return;

    final success = await auth.checkBiometric(context);
    if (success) {
      _hasAuthenticated = true;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'CoalAuth',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            // Fingerprint Button
            Column(
              children: [
                Text(
                  'Scan your fingerprint to verify your identity',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint, size: 32),
                  label: const Text('Authenticate'),
                  onPressed: _runBiometric,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
