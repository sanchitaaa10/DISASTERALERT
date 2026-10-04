import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EnvironmentalTelemetryCard extends StatelessWidget {
  const EnvironmentalTelemetryCard({super.key});

  void _showTelemetryDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final sheetBg = isDark ? AppColorsDark.surface : AppColors.surface;
        final textColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
        final subtextColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColorsDark.border : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Environmental Sensor Network',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sensors located at Kharghar Hills, CIDCO Creek & Taloja Industrial Grid',
                style: TextStyle(fontSize: 12, color: subtextColor),
              ),
              const SizedBox(height: 16),
              _detailRow(
                'Rainfall Rate',
                '42 mm/h',
                'Moderate monsoonal showers. Inundation risk low along Sion-Panvel express corridor.',
                Icons.water_drop_rounded,
                AppColors.infoBlue,
                isDark,
              ),
              const Divider(height: 16),
              _detailRow(
                'Flood Basin Stage',
                'Normal (Level 1)',
                'Gadhi river basin & Panvel creek flow rate normal. Dam gates 1 & 2 closed.',
                Icons.waves_rounded,
                AppColors.safeGreen,
                isDark,
              ),
              const Divider(height: 16),
              _detailRow(
                'Wind Velocity',
                '36 km/h (Gusts 48 km/h)',
                'South-westerly winds. Secure loose scaffolding on mid-rise buildings.',
                Icons.air_rounded,
                AppColors.warningOrange,
                isDark,
              ),
              const Divider(height: 16),
              _detailRow(
                'Air Quality Index',
                'AQI 68 (Satisfactory)',
                'Particulate PM2.5 within permissible CPCB standards.',
                Icons.eco_rounded,
                AppColors.safeGreen,
                isDark,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value, String desc, IconData icon, Color color, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => _showTelemetryDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.safeGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kharghar Micro-Climate Grid',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _metricColumn(
                        'RAIN RATE',
                        '42 mm/h',
                        Icons.water_drop_outlined,
                        AppColors.infoBlue,
                        isDark,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: isDark ? AppColorsDark.border : AppColors.border,
                    ),
                    Expanded(
                      child: _metricColumn(
                        'FLOOD STAGE',
                        'Level 1 Safe',
                        Icons.waves_rounded,
                        AppColors.safeGreen,
                        isDark,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: isDark ? AppColorsDark.border : AppColors.border,
                    ),
                    Expanded(
                      child: _metricColumn(
                        'WIND GUSTS',
                        '36 km/h',
                        Icons.air_rounded,
                        AppColors.warningOrange,
                        isDark,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: isDark ? AppColorsDark.border : AppColors.border,
                    ),
                    Expanded(
                      child: _metricColumn(
                        'AIR AQI',
                        '68 (Good)',
                        Icons.eco_outlined,
                        AppColors.safeGreen,
                        isDark,
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

  Widget _metricColumn(String label, String value, IconData icon, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
