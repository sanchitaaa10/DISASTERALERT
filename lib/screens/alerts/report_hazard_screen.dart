import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alert.dart';
import '../../providers/alert_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';

class ReportHazardScreen extends StatefulWidget {
  const ReportHazardScreen({super.key});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  final _formKey = GlobalKey<FormState>();
  DisasterType _selectedType = DisasterType.flood;
  AlertSeverity _selectedSeverity = AlertSeverity.high;
  late TextEditingController _locationCtrl;
  final TextEditingController _landmarkCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _safetyRuleCtrl = TextEditingController();
  bool _hasPhotoAttached = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final loc = Provider.of<LocationProvider>(context, listen: false);
    _locationCtrl = TextEditingController(text: '${loc.locationName} (Sectors 12-20)');
    _landmarkCtrl.text = 'Near Sector 14 Metro Station & CIDCO Flyover';
    _descCtrl.text = 'Severe waterlogging under the low-lying arterial underpass. Water height exceeds 2 feet, vehicles stalled.';
    _safetyRuleCtrl.text = 'Avoid the underpass. Take diversion route via Central Park highway.';
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _landmarkCtrl.dispose();
    _descCtrl.dispose();
    _safetyRuleCtrl.dispose();
    super.dispose();
  }

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);

    String title;
    switch (_selectedType) {
      case DisasterType.flood:
        title = 'Citizen Alert: Road Inundation & Waterlogging';
        break;
      case DisasterType.fire:
        title = 'Citizen Alert: Active Fire / Smoke Hazard';
        break;
      case DisasterType.gasLeak:
        title = 'Citizen Alert: Chemical / Gas Vapor Leak';
        break;
      case DisasterType.landslide:
        title = 'Citizen Alert: Landslide & Debris Flow';
        break;
      case DisasterType.severeStorm:
        title = 'Citizen Alert: Severe Wind & Fallen Debris';
        break;
      default:
        title = 'Citizen Alert: Critical Local Hazard';
    }

    final newAlert = AlertModel(
      id: 'hazard_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: _selectedType,
      description: '${_descCtrl.text.trim()} Landmark: ${_landmarkCtrl.text.trim()}',
      severity: _selectedSeverity,
      location: _locationCtrl.text.trim(),
      timestamp: DateTime.now(),
      isActive: true,
      affectedRadiusKm: 5.0,
      safetyInstructions: [
        _safetyRuleCtrl.text.trim().isNotEmpty
            ? _safetyRuleCtrl.text.trim()
            : 'Exercise extreme caution and avoid the immediate perimeter.',
        'Follow instructions from local civil defense and traffic wardens.',
      ],
      source: 'Citizen Community Watch (Verified & Broadcasted)',
    );

    alertProvider.addAlert(newAlert, notifProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: newAlert.severityColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Hazard report published to live emergency grid!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Hazard / Incident'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isDark ? AppColorsDark.warningOrange : AppColors.warningOrange).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: (isDark ? AppColorsDark.warningOrange : AppColors.warningOrange).withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.campaign_rounded,
                      color: isDark ? AppColorsDark.warningOrange : AppColors.warningOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verified crowdsourced reports are immediately broadcasted to regional responders and citizens in Kharghar.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Hazard Type
              const Text('HAZARD CATEGORY', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              DropdownButtonFormField<DisasterType>(
                value: _selectedType,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_rounded)),
                items: const [
                  DropdownMenuItem(value: DisasterType.flood, child: Text('Waterlogging & Flooding')),
                  DropdownMenuItem(value: DisasterType.severeStorm, child: Text('Fallen Tree / Power Cables')),
                  DropdownMenuItem(value: DisasterType.fire, child: Text('Structure Fire / Dense Smoke')),
                  DropdownMenuItem(value: DisasterType.landslide, child: Text('Landslide / Slope Collapse')),
                  DropdownMenuItem(value: DisasterType.gasLeak, child: Text('Gas Odor / Chemical Leak')),
                  DropdownMenuItem(value: DisasterType.earthquake, child: Text('Structural Damage / Cracks')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              const SizedBox(height: 16),

              // Severity Level
              const Text('SEVERITY ASSESSMENT', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              SegmentedButton<AlertSeverity>(
                segments: const [
                  ButtonSegment(value: AlertSeverity.low, label: Text('Low')),
                  ButtonSegment(value: AlertSeverity.medium, label: Text('Medium')),
                  ButtonSegment(value: AlertSeverity.high, label: Text('High')),
                  ButtonSegment(value: AlertSeverity.critical, label: Text('Critical')),
                ],
                selected: {_selectedSeverity},
                onSelectionChanged: (set) {
                  setState(() => _selectedSeverity = set.first);
                },
              ),
              const SizedBox(height: 16),

              // Location
              const Text('AFFECTED AREA & GEOLOCATION', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.emergencyRed),
                  labelText: 'Area / Sector',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please specify location' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _landmarkCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.flag_rounded),
                  labelText: 'Landmark / Cross street',
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text('DESCRIPTION OF HAZARD', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe current conditions, danger, road passability...',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please provide description' : null,
              ),
              const SizedBox(height: 16),

              // Safety Advice
              const Text('RECOMMENDED EVASION / SAFETY ADVICE', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: _safetyRuleCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.security_rounded),
                  hintText: 'e.g. Avoid underpass, use highway flyover',
                ),
              ),
              const SizedBox(height: 16),

              // Photo Attachment Mock
              const Text('PHOTO EVIDENCE', style: _sectionTitleStyle),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _hasPhotoAttached
                            ? (isDark ? AppColorsDark.safeGreen.withOpacity(0.18) : AppColors.safeGreen.withOpacity(0.18))
                            : (isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _hasPhotoAttached ? Icons.image_rounded : Icons.add_a_photo_rounded,
                        color: _hasPhotoAttached ? AppColors.safeGreen : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasPhotoAttached ? 'Photo Attached: Hazard_Evidence_01.jpg' : 'Attach Field Photo',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _hasPhotoAttached ? 'GPS metadata verified (19.0473° N, 73.0699° E)' : 'Optional evidence for faster verification',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _hasPhotoAttached ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                        color: _hasPhotoAttached ? AppColors.safeGreen : AppColors.infoBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hasPhotoAttached = !_hasPhotoAttached;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.emergencyRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(_isSubmitting ? 'BROADCASTING REPORT...' : 'BROADCAST HAZARD REPORT'),
                onPressed: _isSubmitting ? null : _submitReport,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle _sectionTitleStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.6,
  color: AppColors.textMuted,
);
