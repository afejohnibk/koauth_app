import 'package:hive/hive.dart';
import '../models/credential.dart';
import '../models/address.dart';
import '../models/card_info.dart';
import '../models/secure_note.dart';

class StorageService {
  static const _credentialBox = 'credentials';
  static const _addressBox = 'addresses';
  static const _cardBox = 'cards';
  static const _noteBox = 'notes';

  /// Initialize Hive boxes — call this before using the service
  static Future<void> init() async {
    await Hive.openBox<Credential>(_credentialBox);
    await Hive.openBox<Address>(_addressBox);
    await Hive.openBox<CardInfo>(_cardBox);
    await Hive.openBox<SecureNote>(_noteBox);
  }

  // ---------- CREDENTIALS ----------
  Future<void> saveCredential(Credential credential) async {
    final box = Hive.box<Credential>(_credentialBox);
    await box.add(credential);
  }

  List<Credential> getAllCredentials() {
    final box = Hive.box<Credential>(_credentialBox);
    return box.values.toList();
  }

  // ---------- ADDRESSES ----------
  Future<void> saveAddress(Address address) async {
    final box = Hive.box<Address>(_addressBox);
    await box.add(address);
  }

  List<Address> getAllAddresses() {
    final box = Hive.box<Address>(_addressBox);
    return box.values.toList();
  }

  // ---------- CARDS ----------
  Future<void> saveCard(CardInfo card) async {
    final box = Hive.box<CardInfo>(_cardBox);
    await box.add(card);
  }

  List<CardInfo> getAllCards() {
    final box = Hive.box<CardInfo>(_cardBox);
    return box.values.toList();
  }

  // ---------- SECURE NOTES ----------
  Future<void> saveNote(SecureNote note) async {
    final box = Hive.box<SecureNote>(_noteBox);
    await box.add(note);
  }

  List<SecureNote> getAllNotes() {
    final box = Hive.box<SecureNote>(_noteBox);
    return box.values.toList();
  }
}
