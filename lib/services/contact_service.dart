import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact.dart';
import '../models/trusted_contact.dart';
import '../data/mock_contacts.dart';
import '../utils/constants.dart';

class ContactService {
  final List<EmergencyContact> _emergencyContacts = List.from(kMockEmergencyContacts);
  List<TrustedContact> _trustedContacts = [];

  List<EmergencyContact> getEmergencyContacts() {
    return List.unmodifiable(_emergencyContacts);
  }

  List<TrustedContact> getTrustedContacts() {
    return List.unmodifiable(_trustedContacts);
  }

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(AppConstants.keyTrustedContacts);
      if (savedJson != null && savedJson.isNotEmpty) {
        final decoded = jsonDecode(savedJson) as List<dynamic>;
        _trustedContacts = decoded
            .map((item) => TrustedContact.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _trustedContacts = List.from(kInitialTrustedContacts);
        await _persistContacts();
      }
    } catch (_) {
      _trustedContacts = List.from(kInitialTrustedContacts);
    }
  }

  Future<void> addTrustedContact(TrustedContact contact) async {
    // If marked as primary, unmark other contacts
    if (contact.isPrimary) {
      _trustedContacts = _trustedContacts
          .map((c) => c.copyWith(isPrimary: false))
          .toList();
    }
    _trustedContacts.add(contact);
    await _persistContacts();
  }

  Future<void> updateTrustedContact(TrustedContact contact) async {
    if (contact.isPrimary) {
      _trustedContacts = _trustedContacts
          .map((c) => c.id == contact.id ? contact : c.copyWith(isPrimary: false))
          .toList();
    } else {
      final index = _trustedContacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _trustedContacts[index] = contact;
      }
    }
    await _persistContacts();
  }

  Future<void> deleteTrustedContact(String id) async {
    _trustedContacts.removeWhere((c) => c.id == id);
    await _persistContacts();
  }

  Future<void> _persistContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_trustedContacts.map((c) => c.toJson()).toList());
      await prefs.setString(AppConstants.keyTrustedContacts, encoded);
    } catch (_) {
      // Graceful fallback for environments without storage
    }
  }
}
