import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/contact_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/contact_card.dart';
import '../../widgets/search_field.dart';
import 'trusted_contacts_screen.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final allContacts = contactProvider.emergencyContacts;

    final filtered = allContacts.where((c) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.phone.contains(q) ||
          c.description.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Helplines'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TrustedContactsScreen()),
              );
            },
            icon: const Icon(Icons.people_alt_outlined, size: 18),
            label: const Text('Trusted (5)'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Notice
          Container(
            color: AppColors.emergencyRedSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.emergencyRed, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'All national helpline numbers are toll-free and accessible 24/7 without active cellular balance.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emergencyRedDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchField(
              hintText: 'Search helplines (Police, Ambulance, NDRF)...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Helplines List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: EmergencyContactCard(contact: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
