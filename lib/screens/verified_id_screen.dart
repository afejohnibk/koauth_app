import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VerifiedIDScreen extends StatefulWidget {
  const VerifiedIDScreen({super.key});

  @override
  State<VerifiedIDScreen> createState() => _VerifiedIDScreenState();
}

class _VerifiedIDScreenState extends State<VerifiedIDScreen> {
  final MobileScannerController _controller = MobileScannerController();
  String? resultText;

  void _onDetect(BarcodeCapture capture) {
    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => resultText = code);

    // Stop scanning temporarily to prevent duplicate scans
    _controller.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Scanned: $code")),
    );

    // Optional: Resume after delay
    Future.delayed(const Duration(seconds: 3), () {
      _controller.start();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verified ID Scanner")),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                resultText ?? 'Scan a QR code',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
