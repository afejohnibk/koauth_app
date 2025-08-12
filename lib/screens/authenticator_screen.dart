import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'setup_key_screen.dart';
import 'qr_otp_scanner_screen.dart';
import 'package:flutter/services.dart';
import 'secure_screen_mixin.dart';
class AuthenticatorScreen extends StatefulWidget {
  const AuthenticatorScreen({super.key});

  @override
  State<AuthenticatorScreen> createState() => _AuthenticatorScreenState();
}

class _AuthenticatorScreenState extends State<AuthenticatorScreen> with WidgetsBindingObserver, SecureScreenMixin<AuthenticatorScreen> {
  final List<Map<String, String>> entries = [];
  List<bool> codeVisible = [];

  late Timer _timer;
  int _remaining = 30;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final now = DateTime.now();
    _remaining = 30 - (now.second % 30);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() {
        _remaining = 30 - (now.second % 30);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _generateTOTP(String secret) {
    return OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      length: 6,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Scan a QR code'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QROTPScannerScreen(onScanned: (entry) {
                      setState(() {
                        entries.add(entry);
                        codeVisible.add(false);
                      });
                    }),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key),
              title: const Text('Enter a setup key'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SetupKeyScreen(onSave: (entry) {
                      setState(() {
                        entries.add(entry);
                        codeVisible.add(false);
                      });
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 72, color: Color(0xFF024A9E)),
            const SizedBox(height: 24),
            const Text(
              "It looks like there aren't any CoalAuth codes here yet.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add a code"),
              onPressed: _showAddOptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPList() {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final code = _generateTOTP(entry['secret']!);

        return ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  value: _remaining / 30,
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF024A9E),
                  strokeWidth: 3,
                ),
              ),
              const Icon(Icons.shield, size: 16),
            ],
          ),
          title: Text(entry['issuer'] ?? 'Unknown'),
          subtitle: Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: codeVisible[index]
                      ? Text(
                          'Code: $code',
                          key: ValueKey('visible_$index'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF024A9E),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          'Code: ••••••',
                          key: ValueKey('hidden_$index'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
              ),
              IconButton(
                icon: Icon(
                  codeVisible[index]
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: codeVisible[index]
                      ? const Color(0xFF024A9E)
                      : Colors.grey,
                ),
                tooltip: codeVisible[index] ? "Hide code" : "Reveal code",
                onPressed: () {
                  setState(() {
                    codeVisible[index] = !codeVisible[index];
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: "Copy code",
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return secureOverlayWrapper(
      child: Scaffold(
      appBar: AppBar(title: const Text("Coal Authenticator")),
      body: entries.isEmpty ? _buildEmptyState() : _buildOTPList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: const Icon(Icons.add),
      ),
      ),
    );
  }
}
