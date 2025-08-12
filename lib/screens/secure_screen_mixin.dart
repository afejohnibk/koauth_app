import 'package:flutter/material.dart';
import '../services/auth_service.dart';

mixin SecureScreenMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  bool _showOverlay = false;
  bool _didPause = false;

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
      _didPause = true;
    } else if (state == AppLifecycleState.resumed && _didPause) {
      setState(() => _showOverlay = true); // ⬅️ Show overlay immediately
      _authService.checkBiometric(context).then((authenticated) {
        if (authenticated) {
          setState(() => _showOverlay = false);
        }
      });
      _didPause = false;
    }
  }

  Widget secureOverlayWrapper({required Widget child}) {
    return Stack(
      children: [
        child,
        if (_showOverlay)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.85)
                  : Colors.white.withOpacity(0.92),
              alignment: Alignment.center,
              child: const Text(
                "CoalAuth Secure",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
