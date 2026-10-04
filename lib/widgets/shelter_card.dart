import 'package:flutter/material.dart';
import '../models/shelter.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ShelterCard extends StatelessWidget {
  final Shelter shelter;
  final VoidCallback onTap;
  final VoidCallback? onDirectionsTap;

  const ShelterCard({
    super.key,
    required this.shelter,
    required this.onTap,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorder = isDark ? AppColorsDark.border : AppColors.border;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final textMuted = isDark ? AppColorsDark.textMuted : AppColors.textMuted;
    final tagBg = isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: cardBorder, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top: Name, Distance & Availability Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shelter.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.near_me_outlined,
                              size: 13,
                              color: AppColors.infoBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${shelter.distance.toStringAsFixed(1)} km away',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.infoBlue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '•  ${shelter.shelterType}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        fontWeight: FontWeight.w700,
                        color: shelter.occupancyColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Address
              Text(
                shelter.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              // Occupancy bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Capacity: ${shelter.currentOccupancy} / ${shelter.capacity}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${shelter.availableSpots} spots left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: shelter.occupancyColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: shelter.occupancyRate.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: cardBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(shelter.occupancyColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Facility tags snippet
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: shelter.facilities.take(3).map((f) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 11, color: AppColors.safeGreen),
                        const SizedBox(width: 4),
                        Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Divider(color: cardBorder),
              const SizedBox(height: 8),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.safeGreen,
                        side: BorderSide(color: AppColors.safeGreen.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      onPressed: () {
                        AppHelpers.makePhoneCall(context, shelter.contactNumber);
                      },
                      icon: const Icon(Icons.phone_outlined, size: 15),
                      label: const Text(
                        'Call Shelter',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.infoBlue.withOpacity(0.12),
                        foregroundColor: AppColors.infoBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      onPressed: onDirectionsTap ??
                          () {
                            AppHelpers.openMapDirections(
                              context,
                              shelter.latitude,
                              shelter.longitude,
                              shelter.name,
                            );
                          },
                      icon: const Icon(Icons.directions_rounded, size: 15),
                      label: const Text(
                        'Directions',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
