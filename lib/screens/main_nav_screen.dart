import 'package:flutter/material.dart';
import 'authenticator_screen.dart';
import 'vault_screen.dart';
import 'payments_screen.dart';
import 'verified_id_screen.dart';
import '../widgets/secure_overlay.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _showSecureOverlay = false;

  final List<Widget> _screens = const [
    AuthenticatorScreen(),
    VaultScreen(),
    PaymentsScreen(),
    VerifiedIDScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        _showSecureOverlay = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _showSecureOverlay = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF024A9E);
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: primaryBlue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Authenticator',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.vpn_key),
                label: 'Vault',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                label: 'Payments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity),
                label: 'Verified ID',
              ),
            ],
          ),
        ),

        // Secure overlay
        if (_showSecureOverlay)
          const Positioned.fill(
            child: SecureOverlay(),
          ),
      ],
    );
  }
}
