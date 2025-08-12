import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:core';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/totp_entry.dart';


class QROTPScannerScreen extends StatefulWidget {
  final Function(Map<String, String>) onScanned;

  const QROTPScannerScreen({super.key, required this.onScanned});

  @override
  State<QROTPScannerScreen> createState() => _QROTPScannerScreenState();
}

class _QROTPScannerScreenState extends State<QROTPScannerScreen> {
  bool scanned = false;

  void _handleScan(String code) {
  if (scanned || !code.startsWith("otpauth://")) return;

  scanned = true;

  final uri = Uri.parse(code);
  final issuer = uri.queryParameters['issuer'] ?? 'Unknown';
  final secret = uri.queryParameters['secret'] ?? '';
  final account = uri.path.split(':').last;

  Hive.box<TOTPEntry>('totp_entries').add(
    TOTPEntry(
      issuer: issuer, 
      account: account,
      secret: secret,
    ),
  );

  // Show success and close scanner
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Added $issuer")),
  );

  Navigator.pop(context); // return to previous screen
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan TOTP QR Code")),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) _handleScan(code);
        },
      ),
    );
  }
}
