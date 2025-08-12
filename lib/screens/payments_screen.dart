import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/card_info.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late Box<CardInfo> _box;

  final _cardNumberController = TextEditingController();
  final _holderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box<CardInfo>('cards');
  }

  void _clearForm() {
    _cardNumberController.clear();
    _holderController.clear();
    _expiryController.clear();
    _cvvController.clear();
  }

  void _showCardForm({CardInfo? existing, int? index}) {
    if (existing != null) {
      _cardNumberController.text = existing.cardNumber;
      _holderController.text = existing.cardholderName;
      _expiryController.text = existing.expiryDate;
      _cvvController.text = existing.cvv;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing != null ? "Edit Card" : "Add Card", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Card Number'),
              ),
              TextField(
                controller: _holderController,
                decoration: const InputDecoration(labelText: 'Card Holder Name'),
              ),
              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
              ),
              TextField(
                controller: _cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Card"),
                onPressed: () {
                  final card = CardInfo(
                    cardholderName: _holderController.text.trim(),
                    cardNumber: _cardNumberController.text.trim(),
                    expiryDate: _expiryController.text.trim(),
                    cvv: _cvvController.text.trim(),
                  );
                  if (existing != null && index != null) {
                    _box.putAt(index, card);
                  } else {
                    _box.add(card);
                  }
                  _clearForm();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Card"),
        content: const Text("Are you sure you want to delete this card?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _box.deleteAt(index);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTile(CardInfo card, int index) {
    final masked = card.cardNumber.length >= 4
        ? '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}'
        : card.cardNumber;

    return ListTile(
      leading: const Icon(Icons.credit_card),
      title: Text(masked),
      subtitle: Text('${card.cardholderName} - Exp: ${card.expiryDate}'),
      onTap: () => _showCardForm(existing: card, index: index),
      onLongPress: () => _confirmDelete(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cards")),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (_, Box<CardInfo> box, __) {
          final cards = box.values.toList();
          if (cards.isEmpty) {
            return const Center(child: Text("No saved cards"));
          }
          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (_, index) => _buildCardTile(cards[index], index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCardForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
