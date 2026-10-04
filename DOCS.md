# DISASTERALERT — Technical Project Documentation

**Project Application Number:** 24  
**Problem Statement ID:** 74  
**Project Category:** B.Tech Capstone / University Demonstration  
**Platform:** Flutter Cross-Platform (iOS, Android, macOS, Web)  

---

## 1. Problem Statement
Natural and anthropogenic emergencies—such as seismic tremors, monsoonal flash flooding, cyclonic storms, building fires, and chemical hazardous material leaks—frequently compromise traditional municipal communication infrastructure. During crises, affected populations struggle with:
- Fragmented or conflicting situational updates.
- Inability to quickly locate operational relief camps with remaining bed/ration capacity.
- Panic and delays when attempting to contact law enforcement or ambulances.
- A lack of immediate, offline-accessible medical instructions during trauma.
- Disconnected family members unable to verify whether loved ones are safe.

## 2. Proposed Solution
**DisasterAlert** is an integrated emergency response and disaster mitigation mobile platform. Built as a high-contrast, offline-first application, DisasterAlert provides:
1. An early-warning radar dashboard tuned to regional geographic sectors (Kharghar and Navi Mumbai).
2. A single-tap SOS distress beacon broadcasting GPS coordinates to trusted contacts and the unified 112 helpline.
3. Live shelter capacity mapping featuring a tactical radar display and turn-by-turn navigation.
4. Offline triage guides for 10 common trauma and environmental emergencies.
5. Persistent personal contact circles with local device storage.

## 3. Project Objectives
- **Zero-Latency Alert Dissemination**: Deliver immediate, color-coded emergency bulletins with verified safety instructions.
- **Fail-Safe Offline Utility**: Ensure medical first aid, shelter directories, and emergency helplines function regardless of internet availability.
- **Accessible & High-Contrast Design**: Eliminate complex navigation trees so stressed users can reach help within two taps.
- **Simulated Demonstration Readiness**: Include a real-time event generator enabling viva examiners to trigger dynamic alerts on demand.

## 4. Functional Requirements
- **FR1 (Alert Feed)**: Filter alerts by severity (`Critical`, `High`, `Medium`, `Low`) and search by keyword or location.
- **FR2 (SOS Dispatch)**: Pulsating SOS trigger with 2-step confirmation to broadcast GPS telemetry (`19.0473° N, 73.0699° E`).
- **FR3 (Shelter Locator)**: Display shelters on a custom interactive radar sweep canvas and sort list by distance via Haversine calculations.
- **FR4 (First-Aid Database)**: 10 structured medical articles detailing symptoms, action steps, contraindications, and 108 direct dialer.
- **FR5 (Contact Persistence)**: Full CRUD operations for trusted contacts stored via `SharedPreferences`.
- **FR6 (Notification Center)**: Track emergency broadcasts with unread counters, mark-as-read, and clearing capabilities.
- **FR7 (Tactical Night Mode HUD)**: Full high-contrast dark theme mode with OLED black palette, glowing neon threat badges, and instant AppBar/Profile toggling.
- **FR8 ("I Am Safe" Family Broadcast)**: Single-tap safety check-in broadcasting GPS telemetry via WhatsApp/SMS with persistent status timeline.
- **FR9 (Evacuation "Go-Bag" Survival Kit)**: Offline packing checklist with 4 emergency categories, percentage readiness gauge, and custom gear creation.
- **FR10 (Tactical Rescue Tools)**: Full-screen optical rescue strobe (Torch, 5Hz Strobe, SOS Morse `... --- ...`), authentic looping 110 dB audible emergency distress siren (`assets/audio/emergency_siren.wav`) via `audioplayers` with live soundwave canvas, synchronized tactical haptic vibration pulses, and compass telemetry HUD.
- **FR11 (Micro-Climate Telemetry)**: Real-time environmental monitoring widget tracking rain rate (mm/h), flood basin stage, wind velocity, and air quality index.
- **FR12 (Citizen Hazard Reporting)**: Community incident submission for waterlogged roads, fallen trees, and fire hazards with geo-tagged verification.

## 5. Non-Functional Requirements
- **Performance**: Instantaneous screen transitions with 60 FPS animations.
- **Reliability**: Graceful fallback for phone dialers, SMS messengers, and location services without application crashes.
- **Accessibility**: High contrast (WCAG AA compliant), distinct typography, large touch targets (minimum 48dp), and dual-channel status indicators (icon + text).
- **Maintainability**: Clear separation of concerns following clean architectural patterns and Provider state management.

## 6. User Flow
```
Launch Application
       │
       ▼
SplashScreen ────(First Time?)────► OnboardingScreen (3 Steps)
       │                                     │
       ▼                                     ▼
Main Navigation Shell (IndexedStack with Material 3 NavigationBar)
       ├── Home Dashboard
       │      ├── Tactical Dark/Light Mode Switcher & Simulate Alert
       │      ├── Regional Threat Level Indicator
       │      ├── "I Am Safe" Safety Check-In Hub (One-Tap WhatsApp/SMS Broadcast)
       │      ├── SOS Distress Dispatch Modal (GPS Telemetry to 112)
       │      ├── Environmental Sensor Telemetry Card (Rain, Flood, Wind, AQI)
       │      ├── Quick Actions Grid (Helplines, First Aid, Shelters, Alerts, Go-Bag, Rescue)
       │      ├── Citizen Hazard Report Banner (Community Incident Dispatch)
       │      ├── Latest Active Disaster Preview Card
       │      ├── Top 3 Nearby Shelters
       │      └── Auto-rotating Educational Safety Tip Card
       │
       ├── Alert Feed
       │      ├── Search & Severity Filter Chips
       │      ├── Active Emergencies Toggle
       │      ├── "Report Hazard" Floating Action Button
       │      └── Alert Details (Overview, Radius, Numbered Safety Rules, Share)
       │
       ├── Shelter Locator
       │      ├── Tactical Radar Sweep Canvas (Zoom, Recenter, Clickable Pins)
       │      ├── List View Switcher (Occupancy Bar, Distance, Facility Tags)
       │      └── Shelter Details (Address, GPS coords, Directions, Call Desk)
       │
       ├── First-Aid Guide
       │      ├── Medical Search & Category Filter (Trauma, Burns, Cardiac, Airway)
       │      └── Protocol Details (Steps, Warnings, Red Flags, Dial 108)
       │
       ├── Crisis Utilities
       │      ├── Evacuation "Go-Bag" Survival Kit (Readiness Gauge & Categorized Gear)
       │      ├── Tactical Rescue Tools (Screen Optical Strobe, Siren Synthesizer, Compass HUD)
       │      └── Citizen Hazard & Incident Report Screen
       │
       └── Profile & Settings
              ├── Name & Phone Profile Editing
              ├── Tactical Display HUD Theme Mode (Light / Tactical Dark / System)
              ├── Crisis Utilities & Tools Shortcuts
              ├── Audio Siren & Haptic Vibration Toggles
              ├── Trusted Contacts Shortcut
              └── Academic Project Specifications (App 24 / Problem 74)
```

## 7. UI/UX Design System
- **Color Palette**:
  - `Emergency Red` (`#D32F2F` / Dark `#FF4D4F`): Critical alerts, SOS trigger, urgent hospital dialers.
  - `Warning Orange` (`#F57C00` / Dark `#FB923C`): High-priority threats, active storm advisories.
  - `Caution Amber` (`#C79200` / Dark `#FACC15`): Medium advisories, geological watches, optical torch.
  - `Safe Green` (`#2E7D32` / Dark `#22C55E`): Safe status, available shelters, "I Am Safe" check-in.
  - `Information Blue` (`#1565C0` / Dark `#38BDF8`): Navigation, helplines, micro-climate metrics.
  - `Slate Surface` (`#F8FAFC` background, `#FFFFFF` cards) & `Tactical OLED Dark` (`#090D16` background, `#111827` surface, `#1E293B` borders).
- **Typography**: Google Fonts *Inter* with strict hierarchy (`DisplayLarge` 32sp, `HeadlineMedium` 18sp, `BodyMedium` 14sp).
- **Tactical Canvas**: 360-degree radar beam sweep, range rings (2km, 4km, 6km, 8km), glowing user pin at Kharghar center, animated sinusoidal siren soundwave painter.

## 8. Application Architecture
The codebase strictly decouples business logic from presentation:
```
[UI Layer / Screens & Reusable Widgets]
                 ▲
                 │ (Listenable Provider Consumer)
[State Layer / ChangeNotifier Providers]
                 ▲
                 │ (Queries & Mutations)
[Service Layer / Business Logic & Persistence]
                 ▲
                 │ (Encapsulation)
[Data & Models Layer / Immutable Entities & Mock Stores]
```

## 9. Flutter Concepts Used
- `MultiProvider` & `ChangeNotifier` state distribution (AlertProvider, ThemeProvider, LocationProvider, NotificationProvider, ContactProvider, ShelterProvider, SurvivalKitProvider).
- `CustomPainter` with trigonometric canvas rendering (`math.sin`, `math.cos`, `SweepGradient`, `_SirenWavePainter`).
- `AnimationController` and `CurvedAnimation` for pulsating glow effects and soundwave oscillation.
- `IndexedStack` for bottom navigation state preservation.
- `PageView` with synchronized animated dot indicators.
- `Form` validation using `TextFormField` and `GlobalKey<FormState>`.
- `SharedPreferences` asynchronous JSON deserialization.
- `SegmentedButton` for view mode and theme switching.
- `ThemeData` light and tactical dark themes using Material 3 `ColorScheme`.

## 10. Provider State Management
- `AlertProvider`: Disaster catalog, active filters, computed threat levels, simulation dispatch, citizen hazard reports.
- `ContactProvider`: Bridges UI to `ContactService`, managing local JSON storage for trusted relatives.
- `ShelterProvider`: Computes distance-sorted shelters, vacancy calculations, and map selection states.
- `NotificationProvider`: Tracks in-app alerts, unread counts, and cross-screen navigation links.
- `LocationProvider`: Coordinates location telemetry and Haversine distance math.
- `ThemeProvider`: Holds user profile, themeMode (Light/Dark/System), safe check-in timestamps, audio/vibration preferences, and onboarding flags.
- `SurvivalKitProvider`: Evacuation Go-Bag checklist state, category filtering, readiness score computation, and JSON persistence.

## 11. Data Models
- `AlertModel`: ID, Title, DisasterType enum, Description, Severity enum, Location, Radius, SafetyInstructions, Source.
- `EmergencyContact`: ID, Name, Phone, EmergencyContactType enum, Description, CategoryColor.
- `TrustedContact`: ID, Name, Relationship, Phone, isPrimary, Notes.
- `Shelter`: ID, Name, Address, Coordinates, Distance, Capacity, Occupancy, Facilities, Availability, OpeningStatus.
- `FirstAid`: ID, Title, Category enum, ShortDescription, WhenItHappens, Steps, WhatNotToDo, WhenToSeekHelp.
- `NotificationModel`: ID, Title, Description, Type enum, Timestamp, isRead, RelatedEntityId.
- `SurvivalItem`: ID, Title, Description, Category enum, isEssential, isPacked.

## 12. Routing & Navigation
Centralized in `AppRoutes.onGenerateRoute` with strongly-typed arguments for detail views:
- `/`: SplashScreen
- `/onboarding`: Onboarding walkthrough
- `/main`: Main navigation shell with bottom navigation bar
- `/alert-details`: Detailed disaster instruction screen
- `/shelter-details`: Relief camp facility and route guide
- `/first-aid-details`: Medical condition protocol
- `/trusted-contacts`: Personal emergency circle manager
- `/survival-kit`: Evacuation Go-Bag checklist and readiness manager
- `/rescue-beacon`: Tactical rescue tools (strobe, siren, compass HUD)
- `/report-hazard`: Citizen community hazard reporting form

## 13. Verification & Automated Testing
- **28 Automated Unit & Widget Tests**:
  - `test/models_and_services_test.dart`: Validates model integrity, severity colors, distance math, and search filtering.
  - `test/providers_test.dart`: Validates state mutation, unread counters, and alert simulation triggers.
  - `test/widget_test.dart`: Verifies component rendering, tap interactions, and initial splash navigation.
  - `test/improvisation_features_test.dart`: Validates ThemeMode toggles, safe check-in timestamps, survival kit packing/readiness, citizen hazard reporting, and widget trees for all new screens.
- **Zero Static Analyzer Warnings**: Completely verified via `flutter analyze` with 0 errors and 0 lints.

