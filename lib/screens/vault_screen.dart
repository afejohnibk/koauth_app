import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';
import '../models/credential.dart';
import '../models/address.dart';
import '../models/secure_note.dart';
import 'apps_web_screen.dart';
import 'addresses_screen.dart';
import 'notes_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> with WidgetsBindingObserver {
  final AuthService _authService = AuthService();
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
      _authService.checkBiometric(context);
      _didPause = false;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVaultTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF024A9E)),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressesBox = Hive.box<Address>('addresses');
    final notesBox = Hive.box<SecureNote>('notes');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vault"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Credential>('credentials').listenable(),
            builder: (context, Box<Credential> credsBox, _) {
              return ValueListenableBuilder(
                valueListenable: addressesBox.listenable(),
                builder: (context, Box<Address> addrBox, _) {
                  return ValueListenableBuilder(
                    valueListenable: notesBox.listenable(),
                    builder: (context, Box<SecureNote> noteBox, _) {
                      final passwordCount = credsBox.length;
                      final addressCount = addrBox.length;
                      final noteCount = noteBox.length;

                      return ListView(
                        children: [
                          _buildSectionTitle("Sign-in Info"),
                          _buildVaultTile(
                            icon: Icons.shield,
                            title: 'Apps & Websites',
                            subtitle: '$passwordCount saved',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AppsWebsitesScreen(),
                                ),
                              );
                            },
                          ),
                          _buildSectionTitle("Private Info"),
                          _buildVaultTile(
                            icon: Icons.location_on,
                            title: 'Addresses',
                            subtitle: '$addressCount saved',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddressesScreen(),
                                ),
                              );
                            },
                          ),
                          _buildVaultTile(
                            icon: Icons.note,
                            title: 'Secure Notes',
                            subtitle: '$noteCount saved',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotesScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                'Secured by CoalAuth',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
