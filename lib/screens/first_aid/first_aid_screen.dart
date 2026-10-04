import 'package:flutter/material.dart';
import '../../data/mock_first_aid.dart';
import '../../models/first_aid.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_filter_chip.dart';
import '../../widgets/first_aid_card.dart';
import '../../widgets/search_field.dart';
import 'first_aid_detail_screen.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  String _searchQuery = '';
  FirstAidCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final filtered = kMockFirstAidGuides.where((guide) {
      if (_selectedCategory != null && guide.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = guide.title.toLowerCase().contains(q);
        final matchesDesc = guide.shortDescription.toLowerCase().contains(q);
        final matchesCat = guide.categoryName.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesCat) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('First-Aid Protocol Guides'),
      ),
      body: Column(
        children: [
          // Emergency Medical Banner
          Container(
            color: AppColors.emergencyRedSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.medical_services_rounded,
                    color: AppColors.emergencyRed, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'For life-threatening cardiac or trauma cases, immediately call 108.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.emergencyRedDark,
                    ),
                  ),
                ),
                FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.emergencyRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => AppHelpers.makePhoneCall(context, '108'),
                  child: const Text('DIAL 108', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchField(
              hintText: 'Search injury or condition (burns, bleeding, CPR)...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                CustomFilterChip(
                  label: 'All (${kMockFirstAidGuides.length})',
                  isSelected: _selectedCategory == null,
                  onSelected: (_) => setState(() => _selectedCategory = null),
                  activeColor: AppColors.infoBlue,
                ),
                CustomFilterChip(
                  label: 'Trauma & Wounds',
                  isSelected: _selectedCategory == FirstAidCategory.trauma,
                  onSelected: (val) => setState(() =>
                      _selectedCategory = val ? FirstAidCategory.trauma : null),
                  activeColor: AppColors.emergencyRed,
                ),
                CustomFilterChip(
                  label: 'Environmental Hazards',
                  isSelected: _selectedCategory == FirstAidCategory.environmental,
                  onSelected: (val) => setState(() => _selectedCategory =
                      val ? FirstAidCategory.environmental : null),
                  activeColor: AppColors.warningOrange,
                ),
                CustomFilterChip(
                  label: 'Cardiac & CPR',
                  isSelected: _selectedCategory == FirstAidCategory.cardiac,
                  onSelected: (val) => setState(() => _selectedCategory =
                      val ? FirstAidCategory.cardiac : null),
                  activeColor: const Color(0xFF880E4F),
                ),
                CustomFilterChip(
                  label: 'Airway & Choking',
                  isSelected: _selectedCategory == FirstAidCategory.respiratory,
                  onSelected: (val) => setState(() => _selectedCategory =
                      val ? FirstAidCategory.respiratory : null),
                  activeColor: const Color(0xFF0277BD),
                ),
                CustomFilterChip(
                  label: 'Burns & Toxins',
                  isSelected: _selectedCategory == FirstAidCategory.burnsPoisons,
                  onSelected: (val) => setState(() => _selectedCategory =
                      val ? FirstAidCategory.burnsPoisons : null),
                  activeColor: const Color(0xFF6A1B9A),
                ),
              ],
            ),
          ),
          const Divider(height: 12),
          // Guides List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final guide = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FirstAidCard(
                    guide: guide,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FirstAidDetailScreen(guide: guide),
                        ),
                      );
                    },
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
