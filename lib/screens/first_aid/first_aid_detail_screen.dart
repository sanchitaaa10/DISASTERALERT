import 'package:flutter/material.dart';
import '../../models/first_aid.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final FirstAid guide;

  const FirstAidDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Banner
            Container(
              color: guide.categoryColor.withOpacity(0.08),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: guide.categoryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(guide.icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.categoryName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: guide.categoryColor,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          guide.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Medical Disclaimer Warning Banner
            Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Color(0xFFE65100), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'IMPORTANT MEDICAL NOTICE: This guidance provides basic first-aid education. It is not a substitute for professional clinical diagnosis or emergency trauma treatment.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBF360C),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // When It Happens
                  _buildSectionCard(
                    title: 'When It Happens & Causes',
                    icon: Icons.help_outline_rounded,
                    color: AppColors.infoBlue,
                    child: Text(
                      guide.whenItHappens,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What To Do (Steps)
                  _buildSectionCard(
                    title: 'Action Protocol: What To Do',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.safeGreen,
                    child: Column(
                      children: List.generate(guide.steps.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: const BoxDecoration(
                                  color: AppColors.safeGreenSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: AppColors.safeGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  guide.steps[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What NOT To Do (Warnings)
                  _buildSectionCard(
                    title: 'Crucial Warnings: What NOT To Do',
                    icon: Icons.cancel_outlined,
                    color: AppColors.emergencyRed,
                    child: Column(
                      children: guide.whatNotToDo.map((warning) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.close_rounded,
                                    color: AppColors.emergencyRed, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  warning,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // When to Seek Professional Help
                  _buildSectionCard(
                    title: 'When to Seek Immediate Medical Help',
                    icon: Icons.medical_services_outlined,
                    color: const Color(0xFFC2185B),
                    child: Text(
                      guide.whenToSeekHelp,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emergencyRedDark,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Call Emergency Ambulance Button
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emergencyRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      AppHelpers.makePhoneCall(context, guide.emergencyNumber);
                    },
                    icon: const Icon(Icons.call_rounded, size: 20),
                    label: Text(
                      'Call Medical Helpline (${guide.emergencyNumber})',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
