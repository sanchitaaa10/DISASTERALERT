import '../models/survival_item.dart';

final List<SurvivalItem> kDefaultSurvivalItems = [
  // Water & Food
  SurvivalItem(
    id: 'surv_1',
    title: '3-Day Water Ration',
    description: 'At least 3 litres per person per day for drinking and sanitation.',
    category: SurvivalCategory.waterAndFood,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_2',
    title: 'Non-Perishable Ready Food',
    description: 'High-calorie energy bars, dried fruits, canned meals, or trail mix.',
    category: SurvivalCategory.waterAndFood,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_3',
    title: 'Water Purification Tablets',
    description: 'Chlorine-dioxide tablets or portable micro-filter straw for contaminated water.',
    category: SurvivalCategory.waterAndFood,
    isEssential: true,
  ),

  // Medical
  SurvivalItem(
    id: 'surv_4',
    title: 'Comprehensive First Aid Kit',
    description: 'Sterile gauze rolls, bandage tape, antiseptic wash, burn cream, trauma scissors.',
    category: SurvivalCategory.medical,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_5',
    title: 'Prescription Medication (7 Days)',
    description: 'Personal maintenance medications, inhalers, insulin with cold pouch if applicable.',
    category: SurvivalCategory.medical,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_6',
    title: 'N95 Respirator Masks',
    description: 'Protects airway from airborne ash, debris, smoke, and industrial particulate.',
    category: SurvivalCategory.medical,
    isEssential: false,
  ),

  // Tools & Signaling
  SurvivalItem(
    id: 'surv_7',
    title: 'High-Lumen Tactical Flashlight',
    description: 'Waterproof LED torch with at least 2 sets of spare alkaline batteries.',
    category: SurvivalCategory.toolsAndSignaling,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_8',
    title: 'Emergency Signaling Whistle',
    description: 'High-decibel (120dB) pealess whistle for signalling search & rescue teams.',
    category: SurvivalCategory.toolsAndSignaling,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_9',
    title: 'Multi-Tool / Heavy Duty Knife',
    description: 'Pliers, wire cutters, blade, and can opener for makeshift emergency repairs.',
    category: SurvivalCategory.toolsAndSignaling,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_10',
    title: 'Waterproof Matches & Lighter',
    description: 'Sealed storm-proof matches and magnesium fire striker.',
    category: SurvivalCategory.toolsAndSignaling,
    isEssential: false,
  ),

  // Power & Documents
  SurvivalItem(
    id: 'surv_11',
    title: '20,000mAh Power Bank & Cable',
    description: 'Fully charged external battery backup with braided multi-charging cable.',
    category: SurvivalCategory.powerAndDocuments,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_12',
    title: 'Battery-Operated FM Radio',
    description: 'Receives AIR / All India Radio emergency frequency broadcasts during cellular blackouts.',
    category: SurvivalCategory.powerAndDocuments,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_13',
    title: 'Waterproof Document Pouch',
    description: 'Aadhaar / ID cards, insurance policies, property papers, bank cards, emergency cash.',
    category: SurvivalCategory.powerAndDocuments,
    isEssential: true,
  ),
  SurvivalItem(
    id: 'surv_14',
    title: 'Emergency Mylar Thermal Blanket',
    description: 'Reflective silver space blanket to prevent shock and hypothermia during wet nights.',
    category: SurvivalCategory.powerAndDocuments,
    isEssential: false,
  ),
];
