import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../services/siren_audio_service.dart';
import '../../utils/constants.dart';

enum StrobeMode { solidWhite, fastStrobe, morseSos }

class RescueBeaconScreen extends StatefulWidget {
  const RescueBeaconScreen({super.key});

  @override
  State<RescueBeaconScreen> createState() => _RescueBeaconScreenState();
}

class _RescueBeaconScreenState extends State<RescueBeaconScreen>
    with SingleTickerProviderStateMixin {
  bool _isSirenActive = false;
  bool _isStrobeActive = false;
  StrobeMode _strobeMode = StrobeMode.fastStrobe;
  Color _strobeColor = Colors.white;
  Timer? _strobeTimer;
  int _morseStep = 0;

  late AnimationController _sirenWaveController;
  final SirenAudioService _audioService = SirenAudioService();

  // SOS timing in tenths of a second:
  // dot = 2, dash = 6, intra-letter = 2, inter-letter = 6, inter-word = 14
  static const List<int> _morsePattern = [
    // S: dot, dot, dot
    1, 0, 1, 0, 1, 0, 0,
    // O: dash, dash, dash
    2, 2, 0, 2, 2, 0, 2, 2, 0, 0,
    // S: dot, dot, dot
    1, 0, 1, 0, 1, 0, 0, 0, 0,
  ];

  @override
  void initState() {
    super.initState();
    _sirenWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _strobeTimer?.cancel();
    _sirenWaveController.dispose();
    _audioService.stopSiren();
    super.dispose();
  }

  void _toggleSiren() {
    setState(() {
      _isSirenActive = !_isSirenActive;
      if (_isSirenActive) {
        _sirenWaveController.repeat();
        _audioService.startSiren();
      } else {
        _sirenWaveController.stop();
        _audioService.stopSiren();
      }
    });
  }

  void _startStrobe() {
    _strobeTimer?.cancel();
    setState(() {
      _isStrobeActive = true;
    });

    if (_strobeMode == StrobeMode.solidWhite) {
      setState(() {
        _strobeColor = Colors.white;
      });
      return;
    }

    if (_strobeMode == StrobeMode.fastStrobe) {
      _strobeTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
        if (!mounted) return;
        setState(() {
          _strobeColor = _strobeColor == Colors.white ? AppColors.emergencyRed : Colors.white;
        });
      });
    } else if (_strobeMode == StrobeMode.morseSos) {
      _morseStep = 0;
      _strobeTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (!mounted) return;
        final state = _morsePattern[_morseStep % _morsePattern.length];
        setState(() {
          _strobeColor = state > 0 ? Colors.white : Colors.black;
          _morseStep++;
        });
      });
    }
  }

  void _stopStrobe() {
    _strobeTimer?.cancel();
    setState(() {
      _isStrobeActive = false;
      _strobeColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Full-screen Strobe Overlay if active
    if (_isStrobeActive) {
      return GestureDetector(
        onTap: _stopStrobe,
        child: Scaffold(
          backgroundColor: _strobeColor,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_rounded, color: Colors.white, size: 28),
                  SizedBox(height: 6),
                  Text(
                    'RESCUE BEACON ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tap anywhere on screen to stop',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tactical Rescue Tools'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Optical Strobe Section Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColorsDark.cautionYellow : AppColors.cautionYellow).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on_rounded, color: AppColors.cautionYellow, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Optical Rescue Screen Strobe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'High-intensity screen flasher for night search & rescue',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Strobe Mode Selector
                  SegmentedButton<StrobeMode>(
                    segments: const [
                      ButtonSegment(value: StrobeMode.fastStrobe, label: Text('Strobe')),
                      ButtonSegment(value: StrobeMode.morseSos, label: Text('SOS Morse')),
                      ButtonSegment(value: StrobeMode.solidWhite, label: Text('Torch')),
                    ],
                    selected: {_strobeMode},
                    onSelectionChanged: (set) {
                      setState(() {
                        _strobeMode = set.first;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? AppColorsDark.cautionYellow : const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.lightbulb_rounded),
                    label: const Text('ACTIVATE FULL-SCREEN BEACON'),
                    onPressed: _startStrobe,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Emergency Audible Siren Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: _isSirenActive
                      ? (isDark ? AppColorsDark.emergencyRed : AppColors.emergencyRed)
                      : (isDark ? AppColorsDark.border : AppColors.border),
                  width: _isSirenActive ? 2.0 : 1.0,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.emergencyRed.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volume_up_rounded, color: AppColors.emergencyRed, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Audible Distress Siren',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _isSirenActive
                                  ? '🔊 110 dB Emergency Wail Active'
                                  : 'High-frequency alarm synthesizer',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isSirenActive
                                    ? AppColors.emergencyRed
                                    : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
                                fontWeight: _isSirenActive ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Animated Siren Waveform Canvas
                  if (_isSirenActive)
                    AnimatedBuilder(
                      animation: _sirenWaveController,
                      builder: (context, _) {
                        return Container(
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: CustomPaint(
                            painter: _SirenWavePainter(
                              progress: _sirenWaveController.value,
                              waveColor: AppColors.emergencyRed,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        );
                      },
                    ),

                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _isSirenActive ? Colors.grey.shade800 : AppColors.emergencyRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(_isSirenActive ? Icons.stop_rounded : Icons.alarm_rounded),
                    label: Text(_isSirenActive ? 'STOP SIREN AUDIO' : 'PLAY EMERGENCY SIREN'),
                    onPressed: _toggleSiren,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tactical Orientation & Telemetry Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColorsDark.infoBlue : AppColors.infoBlue).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.explore_rounded, color: AppColors.infoBlue, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tactical Compass & Telemetry',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Field position and orientation coordinates',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Telemetry Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _telemetryItem('HEADING', '192° SSW', Icons.navigation_rounded, isDark),
                      _telemetryItem('ELEVATION', '18 m MSL', Icons.terrain_rounded, isDark),
                      _telemetryItem('GPS LAT', '${location.latitude.toStringAsFixed(4)}° N', Icons.my_location_rounded, isDark),
                      _telemetryItem('GPS LON', '${location.longitude.toStringAsFixed(4)}° E', Icons.location_searching_rounded, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _telemetryItem(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? AppColorsDark.infoBlue : AppColors.infoBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: isDark ? AppColorsDark.textMuted : AppColors.textMuted,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SirenWavePainter extends CustomPainter {
  final double progress;
  final Color waveColor;

  _SirenWavePainter({required this.progress, required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height / 2;

    path.moveTo(0, midY);
    for (double x = 0; x < size.width; x += 2) {
      final y = midY + math.sin((x / size.width * 4 * math.pi) + (progress * 2 * math.pi)) * (size.height * 0.35);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SirenWavePainter oldDelegate) => true;
}
