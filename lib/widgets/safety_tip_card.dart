import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SafetyTipCard extends StatefulWidget {
  const SafetyTipCard({super.key});

  @override
  State<SafetyTipCard> createState() => _SafetyTipCardState();
}

class _SafetyTipCardState extends State<SafetyTipCard> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % AppConstants.safetyTips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextTip() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % AppConstants.safetyTips.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tip = AppConstants.safetyTips[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.surface : const Color(0xFFF1F8F5);
    final borderColor = isDark ? AppColorsDark.border : const Color(0xFFC8E6C9);
    final titleColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final instructionColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor, width: 1.2),
      ),
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
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.safeGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppColors.safeGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SAFETY PROTOCOL TIP (${_currentIndex + 1}/${AppConstants.safetyTips.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.safeGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.safeGreen),
                onPressed: _nextTip,
                tooltip: 'Next Safety Tip',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tip['title'] ?? '',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tip['instruction'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: instructionColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
