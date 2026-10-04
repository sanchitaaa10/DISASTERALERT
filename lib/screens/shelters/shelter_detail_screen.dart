import 'package:flutter/material.dart';
import '../../models/shelter.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ShelterDetailScreen extends StatelessWidget {
  final Shelter shelter;

  const ShelterDetailScreen({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evacuation Shelter Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Hero Banner
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: shelter.occupancyColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: shelter.occupancyColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                shelter.occupancyStatusText,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: shelter.occupancyColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              shelter.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              shelter.shelterType,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.infoBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.infoBlueSurface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.near_me_rounded,
                                color: AppColors.infoBlue, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              '${shelter.distance.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.infoBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  // Capacity Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Capacity: ${shelter.capacity} evacuees',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${shelter.availableSpots} spots available',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: shelter.occupancyColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: shelter.occupancyRate.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(shelter.occupancyColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & Operational Status Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.location_on_outlined,
                          title: 'Physical Address',
                          detail: shelter.address,
                        ),
                        const Divider(height: 20),
                        _infoRow(
                          icon: Icons.access_time_rounded,
                          title: 'Operational Schedule',
                          detail: shelter.openingStatus,
                        ),
                        const Divider(height: 20),
                        _infoRow(
                          icon: Icons.my_location_rounded,
                          title: 'GPS Coordinates',
                          detail:
                              '${shelter.latitude.toStringAsFixed(4)}° N, ${shelter.longitude.toStringAsFixed(4)}° E',
                        ),
                        const Divider(height: 20),
                        _infoRow(
                          icon: Icons.phone_outlined,
                          title: 'Shelter Control Desk',
                          detail: shelter.contactNumber,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Verified Relief Facilities
                  const Text(
                    'Verified Relief Facilities Onsite',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...shelter.facilities.map((facility) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.safeGreenSurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.safeGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              facility,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 28),

                  // Action Buttons
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.infoBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      AppHelpers.openMapDirections(
                        context,
                        shelter.latitude,
                        shelter.longitude,
                        shelter.name,
                      );
                    },
                    icon: const Icon(Icons.directions_rounded, size: 22),
                    label: const Text(
                      'Get Directions & Evacuation Route',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      AppHelpers.makePhoneCall(context, shelter.contactNumber);
                    },
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: Text('Call Shelter Desk (${shelter.contactNumber})'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
