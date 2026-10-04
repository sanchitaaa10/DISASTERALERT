import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/shelter.dart';
import '../utils/constants.dart';
import 'shelter_card.dart';

class InteractiveShelterMap extends StatefulWidget {
  final List<Shelter> shelters;
  final Shelter? selectedShelter;
  final ValueChanged<Shelter> onShelterSelected;
  final VoidCallback onDetailsTap;

  const InteractiveShelterMap({
    super.key,
    required this.shelters,
    required this.selectedShelter,
    required this.onShelterSelected,
    required this.onDetailsTap,
  });

  @override
  State<InteractiveShelterMap> createState() => _InteractiveShelterMapState();
}

class _InteractiveShelterMapState extends State<InteractiveShelterMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale + 0.25).clamp(0.75, 2.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale - 0.25).clamp(0.75, 2.0);
    });
  }

  void _recenter() {
    setState(() {
      _zoomScale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Interactive Radar Canvas
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            color: const Color(0xFF0F172A), // Tactical deep navy slate
            child: AnimatedBuilder(
              animation: _radarController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _TacticalMapPainter(
                    sweepAngle: _radarController.value * 2 * math.pi,
                    shelters: widget.shelters,
                    selectedShelterId: widget.selectedShelter?.id,
                    zoomScale: _zoomScale,
                  ),
                  child: GestureDetector(
                    onTapUp: (details) {
                      _handleTap(details.localPosition, context);
                    },
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
        ),

        // Map HUD Overlay Controls (Top Right)
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _buildMapButton(
                icon: Icons.add_rounded,
                tooltip: 'Zoom In',
                onPressed: _zoomIn,
              ),
              const SizedBox(height: 6),
              _buildMapButton(
                icon: Icons.remove_rounded,
                tooltip: 'Zoom Out',
                onPressed: _zoomOut,
              ),
              const SizedBox(height: 6),
              _buildMapButton(
                icon: Icons.my_location_rounded,
                tooltip: 'Recenter Kharghar',
                onPressed: _recenter,
              ),
            ],
          ),
        ),

        // Live Radar Status Pill (Top Left)
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.safeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'RADAR ACTIVE • KHARGHAR ZONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Selected Shelter Preview Card at Bottom
        if (widget.selectedShelter != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: ShelterCard(
              shelter: widget.selectedShelter!,
              onTap: widget.onDetailsTap,
            ),
          ),
      ],
    );
  }

  void _handleTap(Offset tapPos, BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < widget.shelters.length; i++) {
      final shelter = widget.shelters[i];
      final pos = _calculateMarkerOffset(center, shelter, i, widget.shelters.length, size, _zoomScale);
      if ((tapPos - pos).distance < 24) {
        widget.onShelterSelected(shelter);
        return;
      }
    }
  }

  Widget _buildMapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.black.withOpacity(0.75),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  static Offset _calculateMarkerOffset(
    Offset center,
    Shelter shelter,
    int index,
    int total,
    Size size,
    double zoom,
  ) {
    // Map GPS distance (0.8km to 8.4km) into radial canvas radius
    final maxRadius = (math.min(size.width, size.height) / 2) * 0.85 * zoom;
    final normalizedDist = (shelter.distance / 9.0).clamp(0.15, 0.95);
    final r = maxRadius * normalizedDist;

    // Distribute angles realistically around center
    final angle = (index * (2 * math.pi / total)) + (shelter.distance * 0.5);
    final dx = center.dx + r * math.cos(angle);
    final dy = center.dy + r * math.sin(angle);
    return Offset(dx, dy);
  }
}

class _TacticalMapPainter extends CustomPainter {
  final double sweepAngle;
  final List<Shelter> shelters;
  final String? selectedShelterId;
  final double zoomScale;

  _TacticalMapPainter({
    required this.sweepAngle,
    required this.shelters,
    required this.selectedShelterId,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (math.min(size.width, size.height) / 2) * 0.85 * zoomScale;

    // 1. Draw Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.0;

    const gridStep = 40.0;
    for (double x = 0; x < size.width; x += gridStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw Concentric Range Rings
    final ringPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final ringSteps = [0.25, 0.50, 0.75, 1.0];
    final labels = ['2 km', '4 km', '6 km', '8 km'];

    for (int i = 0; i < ringSteps.length; i++) {
      final r = maxRadius * ringSteps[i];
      canvas.drawCircle(center, r, ringPaint);

      // Distance Label
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(center.dx + 4, center.dy - r + 2));
    }

    // 3. Draw Radar Sweep Beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          Colors.transparent,
          AppColors.emergencyRed.withOpacity(0.25),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius, sweepPaint);

    final sweepLinePaint = Paint()
      ..color = AppColors.emergencyRed.withOpacity(0.6)
      ..strokeWidth = 1.5;
    final sweepEnd = Offset(
      center.dx + maxRadius * math.cos(sweepAngle),
      center.dy + maxRadius * math.sin(sweepAngle),
    );
    canvas.drawLine(center, sweepEnd, sweepLinePaint);

    // 4. Center User Marker (Kharghar Base)
    final userHaloPaint = Paint()
      ..color = AppColors.infoBlue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 18, userHaloPaint);

    final userPinPaint = Paint()
      ..color = AppColors.infoBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7, userPinPaint);

    final userWhiteDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, userWhiteDot);

    // User Location Label
    final userLabel = TextPainter(
      text: const TextSpan(
        text: '📍 You (Kharghar)',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    userLabel.paint(canvas, Offset(center.dx - (userLabel.width / 2), center.dy + 12));

    // 5. Draw Shelter Pins
    for (int i = 0; i < shelters.length; i++) {
      final shelter = shelters[i];
      final isSelected = shelter.id == selectedShelterId;
      final pos = _InteractiveShelterMapState._calculateMarkerOffset(
        center,
        shelter,
        i,
        shelters.length,
        size,
        zoomScale,
      );

      // Shelter Pin Glow / Halo
      final haloPaint = Paint()
        ..color = (isSelected ? Colors.white : shelter.occupancyColor).withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, isSelected ? 16 : 12, haloPaint);

      // Pin Body
      final pinPaint = Paint()
        ..color = isSelected ? Colors.white : shelter.occupancyColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, isSelected ? 9 : 7, pinPaint);

      final innerPinPaint = Paint()
        ..color = isSelected ? AppColors.emergencyRed : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, isSelected ? 5 : 3, innerPinPaint);

      // Label above pin
      final shelterLabel = TextPainter(
        text: TextSpan(
          text: shelter.name.split(' ').first,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            backgroundColor: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      shelterLabel.paint(
        canvas,
        Offset(pos.dx - (shelterLabel.width / 2), pos.dy - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TacticalMapPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.selectedShelterId != selectedShelterId ||
        oldDelegate.zoomScale != zoomScale ||
        oldDelegate.shelters != shelters;
  }
}
