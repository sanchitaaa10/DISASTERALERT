import '../models/emergency_contact.dart';
import '../models/trusted_contact.dart';

final List<EmergencyContact> kMockEmergencyContacts = [
  const EmergencyContact(
    id: 'emg_001',
    name: 'National Emergency Helpline',
    phone: '112',
    type: EmergencyContactType.disasterManagement,
    description: 'Unified 24/7 single-number response for Police, Fire, and Ambulance.',
  ),
  const EmergencyContact(
    id: 'emg_002',
    name: 'Ambulance & Trauma Services',
    phone: '108',
    type: EmergencyContactType.ambulance,
    description: 'Free emergency medical service with advanced cardiac life support.',
  ),
  const EmergencyContact(
    id: 'emg_003',
    name: 'Police Emergency Response',
    phone: '100',
    type: EmergencyContactType.police,
    description: 'Direct patrol dispatch and neighborhood law enforcement.',
  ),
  const EmergencyContact(
    id: 'emg_004',
    name: 'Fire & Rescue Brigade',
    phone: '101',
    type: EmergencyContactType.fire,
    description: 'Hazardous materials, building fires, and structural extrication.',
  ),
  const EmergencyContact(
    id: 'emg_005',
    name: 'NDRF Control Room (National)',
    phone: '01124363260',
    type: EmergencyContactType.ndrf,
    description: 'Specialized response squads for major earthquakes, floods, and storms.',
  ),
  const EmergencyContact(
    id: 'emg_006',
    name: 'Women in Distress Helpline',
    phone: '1091',
    type: EmergencyContactType.womenHelpline,
    description: 'Dedicated 24/7 immediate assistance, counseling, and rescue.',
  ),
  const EmergencyContact(
    id: 'emg_007',
    name: 'Childline Emergency Care',
    phone: '1098',
    type: EmergencyContactType.childHelpline,
    description: '24-hour toll-free emergency phone outreach service for children.',
  ),
  const EmergencyContact(
    id: 'emg_008',
    name: 'Kharghar Police Station (Local)',
    phone: '02227740100',
    type: EmergencyContactType.police,
    description: 'Local jurisdictional precinct, Sector 12, Kharghar.',
  ),
];

final List<TrustedContact> kInitialTrustedContacts = [
  const TrustedContact(
    id: 'tc_001',
    name: 'Kavita Sharma',
    relationship: 'Mother',
    phone: '+91 98201 12345',
    isPrimary: true,
    notes: 'Home address: Kharghar Sector 10. Aware of medical history.',
  ),
  const TrustedContact(
    id: 'tc_002',
    name: 'Rajesh Sharma',
    relationship: 'Father',
    phone: '+91 98202 67890',
    isPrimary: false,
    notes: 'Office in Vashi Infotech Park.',
  ),
  const TrustedContact(
    id: 'tc_003',
    name: 'Dr. Ananya Joshi',
    relationship: 'College Faculty Mentor',
    phone: '+91 98334 54321',
    isPrimary: false,
    notes: 'Faculty Advisor, Department of Computer Engineering.',
  ),
  const TrustedContact(
    id: 'tc_004',
    name: 'Priya Verma',
    relationship: 'Roommate / Friend',
    phone: '+91 99205 98765',
    isPrimary: false,
    notes: 'Resident in same hostel block.',
  ),
  const TrustedContact(
    id: 'tc_005',
    name: 'Mr. Ramesh Patil',
    relationship: 'Hostel Security Warden',
    phone: '+91 98199 44332',
    isPrimary: false,
    notes: 'On-duty 24/7 campus gate warden.',
  ),
];
