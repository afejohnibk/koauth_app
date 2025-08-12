import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometric(BuildContext context, {bool? isSetup}) async {
    bool canCheckBiometric = await auth.canCheckBiometrics;

    if (canCheckBiometric) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        bool authenticated = await auth.authenticate(
          localizedReason: "Use Fingerprint or FaceID to authenticate",
        );

        if (authenticated) {
          if (isSetup == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isBiometricEnabled', true);
          }
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication failed')),
          );
          return false;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biometrics not available')),
    );
    return false;
  }
}
