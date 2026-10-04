import 'package:flutter/material.dart';
import '../models/emergency_contact.dart';
import '../models/trusted_contact.dart';
import '../services/contact_service.dart';

class ContactProvider extends ChangeNotifier {
  final ContactService _service = ContactService();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  List<EmergencyContact> get emergencyContacts => _service.getEmergencyContacts();
  List<TrustedContact> get trustedContacts => _service.getTrustedContacts();

  TrustedContact? get primaryContact {
    try {
      return trustedContacts.firstWhere((c) => c.isPrimary);
    } catch (_) {
      return trustedContacts.isNotEmpty ? trustedContacts.first : null;
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _service.initialize();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addTrustedContact(TrustedContact contact) async {
    await _service.addTrustedContact(contact);
    notifyListeners();
  }

  Future<void> updateTrustedContact(TrustedContact contact) async {
    await _service.updateTrustedContact(contact);
    notifyListeners();
  }

  Future<void> deleteTrustedContact(String id) async {
    await _service.deleteTrustedContact(id);
    notifyListeners();
  }
}
