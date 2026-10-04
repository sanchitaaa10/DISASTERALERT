import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trusted_contact.dart';
import '../../providers/contact_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/contact_card.dart';
import '../../widgets/empty_state_widget.dart';

class TrustedContactsScreen extends StatelessWidget {
  const TrustedContactsScreen({super.key});

  void _showContactDialog(BuildContext context, {TrustedContact? existingContact}) {
    showDialog(
      context: context,
      builder: (ctx) => _ContactFormDialog(existingContact: existingContact),
    );
  }

  void _confirmDelete(BuildContext context, TrustedContact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Delete Trusted Contact?'),
        content: Text('Remove "${contact.name}" from your emergency SOS broadcast circle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.emergencyRed),
            onPressed: () {
              Provider.of<ContactProvider>(context, listen: false)
                  .deleteTrustedContact(contact.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = contactProvider.trustedContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Add Contact',
            onPressed: () => _showContactDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.emergencyRed,
        foregroundColor: Colors.white,
        onPressed: () => _showContactDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Contact', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Informational Banner
          Container(
            color: AppColors.infoBlueSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, color: AppColors.infoBlue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${contacts.length} trusted contacts will automatically receive your GPS telemetry during an SOS distress event.',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.infoBlue,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: contacts.isEmpty
                ? EmptyStateWidget.noContacts(
                    onAdd: () => _showContactDialog(context),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TrustedContactCard(
                          contact: contact,
                          onEdit: () => _showContactDialog(context, existingContact: contact),
                          onDelete: () => _confirmDelete(context, contact),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContactFormDialog extends StatefulWidget {
  final TrustedContact? existingContact;

  const _ContactFormDialog({this.existingContact});

  @override
  State<_ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<_ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late String _relationship;
  late bool _isPrimary;

  final List<String> _relationshipOptions = [
    'Mother',
    'Father',
    'Spouse',
    'Sibling',
    'Roommate / Friend',
    'College Faculty Mentor',
    'Hostel Security Warden',
    'Neighbor',
    'Relative / Guardian',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.existingContact;
    _nameController = TextEditingController(text: c?.name ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _relationship = c?.relationship ?? _relationshipOptions.first;
    _isPrimary = c?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<ContactProvider>(context, listen: false);

    if (widget.existingContact != null) {
      final updated = widget.existingContact!.copyWith(
        name: _nameController.text.trim(),
        relationship: _relationship,
        phone: _phoneController.text.trim(),
        isPrimary: _isPrimary,
        notes: _notesController.text.trim(),
      );
      provider.updateTrustedContact(updated);
    } else {
      final newContact = TrustedContact(
        id: 'tc_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        relationship: _relationship,
        phone: _phoneController.text.trim(),
        isPrimary: _isPrimary,
        notes: _notesController.text.trim(),
      );
      provider.addTrustedContact(newContact);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingContact != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.emergencyRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.contact_emergency_rounded,
                        color: AppColors.emergencyRed,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? 'Edit Trusted Contact' : 'Add Trusted Contact',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Name
                TextFormField(
                  controller: _nameController,
                  validator: AppValidators.validateName,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'e.g. Kavita Sharma',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                // Relationship Dropdown
                DropdownButtonFormField<String>(
                  value: _relationshipOptions.contains(_relationship)
                      ? _relationship
                      : _relationshipOptions.first,
                  decoration: const InputDecoration(
                    labelText: 'Relationship *',
                    prefixIcon: Icon(Icons.family_restroom_rounded),
                  ),
                  items: _relationshipOptions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _relationship = val);
                  },
                ),
                const SizedBox(height: 14),
                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  validator: AppValidators.validatePhone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '+91 98201 XXXXX',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                // Optional Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Location / Emergency Notes (Optional)',
                    hintText: 'e.g. Kharghar Sector 10 / Knows blood group',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                // Primary SOS Toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.emergencyRed,
                  title: const Text(
                    'Set as Primary SOS Contact',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'First recipient dialed during automated distress protocols.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  value: _isPrimary,
                  onChanged: (val) => setState(() => _isPrimary = val),
                ),
                const SizedBox(height: 20),
                // Dialog Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.emergencyRed,
                        ),
                        onPressed: _saveContact,
                        child: Text(isEdit ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
