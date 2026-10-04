import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/shelter.dart';
import '../../providers/shelter_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_filter_chip.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/interactive_shelter_map.dart';
import '../../widgets/search_field.dart';
import '../../widgets/shelter_card.dart';
import 'shelter_detail_screen.dart';

enum _ShelterViewMode { map, list }

class ShelterLocatorScreen extends StatefulWidget {
  const ShelterLocatorScreen({super.key});

  @override
  State<ShelterLocatorScreen> createState() => _ShelterLocatorScreenState();
}

class _ShelterLocatorScreenState extends State<ShelterLocatorScreen> {
  _ShelterViewMode _viewMode = _ShelterViewMode.map;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openShelterDetail(Shelter shelter) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShelterDetailScreen(shelter: shelter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shelterProvider = Provider.of<ShelterProvider>(context);
    final shelters = shelterProvider.filteredShelters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Shelters'),
        actions: [
          // View Mode Switcher
          SegmentedButton<_ShelterViewMode>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              selectedBackgroundColor: AppColors.infoBlue.withOpacity(0.12),
              selectedForegroundColor: AppColors.infoBlue,
            ),
            segments: const [
              ButtonSegment(
                value: _ShelterViewMode.map,
                icon: Icon(Icons.radar_rounded, size: 16),
                label: Text('Radar', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: _ShelterViewMode.list,
                icon: Icon(Icons.list_rounded, size: 16),
                label: Text('List', style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {_viewMode},
            onSelectionChanged: (set) {
              setState(() => _viewMode = set.first);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchField(
              hintText: 'Search shelters by name, area...',
              controller: _searchController,
              onChanged: (val) => shelterProvider.setSearchQuery(val),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                CustomFilterChip(
                  label: 'All (${shelterProvider.allShelters.length})',
                  isSelected: !shelterProvider.onlyAvailable &&
                      shelterProvider.maxDistanceKm == null &&
                      shelterProvider.selectedFacility == null,
                  onSelected: (_) => shelterProvider.clearFilters(),
                  activeColor: AppColors.infoBlue,
                ),
                CustomFilterChip(
                  label: 'Available Only',
                  isSelected: shelterProvider.onlyAvailable,
                  onSelected: (val) => shelterProvider.toggleOnlyAvailable(val),
                  activeColor: AppColors.safeGreen,
                ),
                CustomFilterChip(
                  label: 'Within 5 km',
                  isSelected: shelterProvider.maxDistanceKm == 5.0,
                  onSelected: (val) =>
                      shelterProvider.setMaxDistance(val ? 5.0 : null),
                  activeColor: AppColors.warningOrange,
                ),
                CustomFilterChip(
                  label: 'Medical Aid',
                  isSelected: shelterProvider.selectedFacility == 'Medical',
                  onSelected: (val) =>
                      shelterProvider.setSelectedFacility(val ? 'Medical' : null),
                  activeColor: AppColors.emergencyRed,
                ),
                CustomFilterChip(
                  label: 'Drinking Water',
                  isSelected: shelterProvider.selectedFacility == 'Water',
                  onSelected: (val) =>
                      shelterProvider.setSelectedFacility(val ? 'Water' : null),
                  activeColor: AppColors.infoBlue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Content
          Expanded(
            child: shelters.isEmpty
                ? EmptyStateWidget.noShelters(
                    onReset: () {
                      _searchController.clear();
                      shelterProvider.clearFilters();
                    },
                  )
                : _viewMode == _ShelterViewMode.map
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: InteractiveShelterMap(
                          shelters: shelters,
                          selectedShelter: shelterProvider.selectedShelter ??
                              (shelters.isNotEmpty ? shelters.first : null),
                          onShelterSelected: (s) {
                            shelterProvider.selectShelter(s.id);
                          },
                          onDetailsTap: () {
                            final s = shelterProvider.selectedShelter ??
                                (shelters.isNotEmpty ? shelters.first : null);
                            if (s != null) _openShelterDetail(s);
                          },
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: shelters.length,
                        itemBuilder: (context, index) {
                          final shelter = shelters[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ShelterCard(
                              shelter: shelter,
                              onTap: () => _openShelterDetail(shelter),
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
