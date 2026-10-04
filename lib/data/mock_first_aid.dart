import '../models/first_aid.dart';

final List<FirstAid> kMockFirstAidGuides = [
  const FirstAid(
    id: 'fa_001',
    title: 'Severe Bleeding & Hemorrhage',
    category: FirstAidCategory.trauma,
    iconKey: 'bleeding',
    shortDescription:
        'Apply firm, continuous direct pressure to the wound with a sterile cloth or bandage to stop life-threatening blood loss.',
    whenItHappens:
        'Occurs during deep lacerations from glass shards, sharp debris, vehicle collisions, or building collapse during earthquakes and industrial accidents.',
    steps: [
      'Ensure personal safety first by wearing disposable gloves or improvised clean barrier if available.',
      'Expose the wound completely to pinpoint the exact site of bleeding.',
      'Place a sterile dressing, clean cotton cloth, or garment directly over the wound and apply firm, continuous pressure with both hands.',
      'Maintain direct pressure for at least 10–15 uninterrupted minutes without lifting the cloth to check.',
      'If the cloth becomes soaked with blood, DO NOT remove it; add another layer on top and continue pressing hard.',
      'If bleeding is on a limb and cannot be controlled with direct pressure, apply an emergency tourniquet 5–7 cm above the wound (never over a joint).',
    ],
    whatNotToDo: [
      'Do not remove the first soaked bandage, as this dislodges forming blood clots.',
      'Do not probe or attempt to clean deep inside a heavily bleeding wound.',
      'Do not remove large deeply embedded objects (e.g., rebar or glass shards); stabilize them in place with rolled dressings instead.',
      'Do not apply direct tourniquets around the neck or directly over knees or elbows.',
    ],
    whenToSeekHelp:
        'Call 108 immediately if bleeding is spurting (arterial), cannot be controlled after 10 minutes of direct pressure, or if the victim shows signs of shock (cold skin, confusion, rapid shallow breathing).',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_002',
    title: 'Burns & Scalds',
    category: FirstAidCategory.burnsPoisons,
    iconKey: 'burns',
    shortDescription:
        'Cool thermal burns immediately under gentle, cool running water for at least 20 minutes to prevent deep tissue damage.',
    whenItHappens:
        'Results from contact with open fire, hot liquids/steam, hot engine parts, electrical flashover, or corrosive chemicals during structural fires or industrial incidents.',
    steps: [
      'Immediately remove the victim from the heat source and ensure the area is safe from toxic fumes.',
      'Cool the burned skin under gentle, clean, cool running tap water for at least 20 minutes (do not use ice or freezing water).',
      'Carefully remove loose clothing and jewelry near the burn before tissue begins swelling, but DO NOT tear away fabric that is stuck directly to the burn.',
      'Cover the cooled burn loosely with sterile cling film (plastic food wrap) or a clean, non-fluffy dressing to prevent infection and air contact pain.',
      'Keep the patient warm with a clean blanket on uninjured body parts to prevent hypothermia.',
    ],
    whatNotToDo: [
      'Do not apply ice, ice water, butter, oil, toothpaste, or turmeric powder to burns.',
      'Do not pop or pierce any blisters that form on the skin.',
      'Do not use cotton wool, fluffy dressings, or adhesive plasters directly on burned flesh.',
      'Do not forcefully peel off melted synthetic clothing stuck to the wound.',
    ],
    whenToSeekHelp:
        'Dial 108 immediately for burns larger than the palm of the victim’s hand, all electrical or chemical burns, burns causing white/charred skin, or burns on the face, hands, feet, or groin.',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_003',
    title: 'Fractures & Broken Bones',
    category: FirstAidCategory.trauma,
    iconKey: 'fractures',
    shortDescription:
        'Immobilize the suspected fracture site in the position found using splints or padding. Avoid moving or realigning deformed limbs.',
    whenItHappens:
        'Triggered by blunt trauma, falls from elevation, tripping on broken pavement, or collapsing masonry during earthquakes and tremors.',
    steps: [
      'Keep the injured person calm and still. Instruct them not to move the damaged limb.',
      'Check for open wounds or bone protrusions. If bleeding, control it with gentle pressure around the bone without pushing on it.',
      'Immobilize the limb in the exact position it was found. Use rolled newspapers, wooden slats, or cardboard folded into a U-shape as a rigid splint.',
      'Secure the splint above and below the fractured joint with bandages, ties, or cloth strips, ensuring it is snug but not cutting off blood circulation.',
      'Check fingers or toes beyond the splint every 10 minutes to verify warmth, color, and pulse.',
      'Elevate the limb gently if comfortable to reduce swelling, provided it causes no extra pain.',
    ],
    whatNotToDo: [
      'Do not attempt to push exposed bone fragments back under the skin.',
      'Do not attempt to straighten, manipulate, or "pop" a visibly crooked or dislocated limb.',
      'Do not tie splint straps directly over the fracture site.',
      'Do not give the person food or drink in case emergency surgery with anesthesia is needed.',
    ],
    whenToSeekHelp:
        'Call 108 immediately if bone is visible through the skin (compound fracture), if the limb looks blue or numb, or if the injury involves the neck, spine, pelvis, or skull.',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_004',
    title: 'CPR & Adult Cardiac Arrest',
    category: FirstAidCategory.cardiac,
    iconKey: 'cpr',
    shortDescription:
        'Perform hands-only chest compressions hard and fast in the center of the chest at 100–120 beats per minute until paramedics arrive.',
    whenItHappens:
        'Occurs when heart rhythm stops abruptly due to electric shock, submersion in floodwater, sudden cardiac arrest, or severe crushing trauma.',
    steps: [
      'Check the scene for hazards (fallen live wires, rising water, falling debris).',
      'Check responsiveness: Tap victim’s shoulders firmly and shout loudly: "Are you okay?".',
      'If unresponsive and not breathing normally (or only gasping), shout for someone nearby to call 108 and fetch an AED (Defibrillator).',
      'Place the heel of one hand in the center of the chest (lower half of sternum), interlock the fingers of your second hand on top, and lock your elbows straight.',
      'Push hard and fast: Compress the chest at least 5 cm deep at a cadence of 100 to 120 compressions per minute (to the rhythm of the song "Stayin\' Alive").',
      'Allow the chest to recoil fully between each compression. Do not stop until emergency medical personnel relieve you or the person begins breathing.',
    ],
    whatNotToDo: [
      'Do not waste time checking for a faint pulse if you are an untrained lay rescuer; look for normal breathing.',
      'Do not pause compressions for more than 10 seconds.',
      'Do not perform chest compressions on a person who is conscious or breathing normally.',
      'Do not bend your elbows; use your upper body weight to drive compressions.',
    ],
    whenToSeekHelp:
        'Cardiac arrest is an absolute emergency. Call 108 the second unresponsiveness and abnormal breathing are identified.',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_005',
    title: 'Fainting & Syncope',
    category: FirstAidCategory.medical,
    iconKey: 'fainting',
    shortDescription:
        'Position the person flat on their back and elevate both legs 30 cm to restore blood flow to the brain.',
    whenItHappens:
        'Caused by sudden drop in blood pressure, prolonged standing in overcrowded queues/shelters, extreme heat, dehydration, or psychological shock.',
    steps: [
      'Catch the person gently if falling to avoid head impact on concrete.',
      'Lay the individual flat on their back in a cool, well-ventilated, shaded area.',
      'Elevate their feet and legs approximately 12 inches (30 cm) above heart level using a backpack, pillow, or folded jacket.',
      'Loosen tight clothing around their neck, chest, and waistline (ties, collars, belts).',
      'Ensure plenty of fresh air circulation; ask onlookers to step back.',
      'If the person vomits or feels nauseous, turn them onto their side into the recovery position to keep airway clear.',
    ],
    whatNotToDo: [
      'Do not force the person to stand up or sit upright too quickly.',
      'Do not splash cold water on their face or slap them.',
      'Do not administer food, water, or medication while they are unconscious or drowsy.',
      'Do not place a pillow underneath their head while lying down as it constricts the windpipe.',
    ],
    whenToSeekHelp:
        'Call 108 if the person remains unconscious for longer than 1 minute, suffered a head injury while collapsing, experienced chest pain or palpitations before fainting, or is pregnant.',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_006',
    title: 'Venomous Snake Bite',
    category: FirstAidCategory.environmental,
    iconKey: 'snakeBite',
    shortDescription:
        'Keep the victim calm, still, and immobilize the bitten limb below heart level. Rapid transport to an antivenom-equipped hospital is vital.',
    whenItHappens:
        'Frequent during monsoon floods and waterlogging when snakes (Russell’s viper, Cobra, Krait) seek dry shelter in human habitations or debris.',
    steps: [
      'Move the victim away from the snake’s strike zone. Do not try to catch or kill the snake.',
      'Reassure the person and keep them strictly calm and immobile; movement accelerates venom circulation through lymphatics.',
      'Gently remove rings, watches, anklets, and tight clothing before swelling begins.',
      'Immobilize the bitten limb with a broad splint and light crepe bandage (firm as for a sprained ankle, but not cutting off arterial pulse).',
      'Keep the bitten area at or slightly below heart level.',
      'Note the snake’s appearance (colors, head shape) if safely visible from a distance to assist doctors with antivenom selection.',
    ],
    whatNotToDo: [
      'Do not cut the bite mark with blades or knives.',
      'Do not attempt to suck out venom with your mouth or suction devices.',
      'Do not apply a tight arterial tourniquet or ice packs.',
      'Do not apply traditional herbs, cow dung, or chemical pastes.',
      'Do not allow the patient to walk or consume caffeine/alcohol.',
    ],
    whenToSeekHelp:
        'Every snake bite in India should be treated as a potential medical emergency. Dial 108 or proceed straight to the nearest district civil hospital stocking Polyvalent Anti-Snake Venom (ASV).',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_007',
    title: 'Electric Shock & Powerline Hazard',
    category: FirstAidCategory.environmental,
    iconKey: 'electricShock',
    shortDescription:
        'Safely disconnect the electrical power source before touching the victim. Never touch someone in direct contact with live current.',
    whenItHappens:
        'Occurs during cyclone windstorms with snapped power cables, flooded streetlights, damaged distribution transformers, or domestic appliance short circuits.',
    steps: [
      'DO NOT touch the victim with bare hands if they remain in contact with the electrical current.',
      'Immediately shut off the main electrical circuit breaker, pull the plug, or flip the master power switch.',
      'If the power source cannot be turned off and the voltage is domestic (under 240V), use a dry non-conductive object (dry wooden broomstick or thick plastic pipe) to push the wire away.',
      'For high-voltage outdoor fallen powerlines, remain at least 10 meters away and call 101/112 immediately.',
      'Once safely isolated from current, check breathing and responsiveness; initiate CPR if unresponsive and not breathing.',
      'Treat electrical entry and exit burns with clean, dry dressings.',
    ],
    whatNotToDo: [
      'Do not approach or touch a victim trapped near downed outdoor high-voltage wires.',
      'Do not use damp or metal objects to push cables away.',
      'Do not touch standing water in puddles near fallen lines.',
    ],
    whenToSeekHelp:
        'Call 108/112 for all victims of electrical shock, as hidden cardiac arrhythmias and deep internal tissue burns often appear hours after the incident.',
    emergencyNumber: '112',
  ),
  const FirstAid(
    id: 'fa_008',
    title: 'Heat Stroke & Hyperthermia',
    category: FirstAidCategory.environmental,
    iconKey: 'heatStroke',
    shortDescription:
        'Rapidly cool the patient using cold water, damp towels, and fanning. Heat stroke is a medical emergency that can damage vital organs.',
    whenItHappens:
        'Occurs during heatwaves with temperatures over 40°C combined with high humidity, strenuous physical exertion, or prolonged exposure without hydration.',
    steps: [
      'Immediately move the person to an air-conditioned room or shaded, breezy location.',
      'Strip off excess layers of heavy outer clothing.',
      'Rapidly cool the body: spray or sponge the entire body with cool water and fan vigorously.',
      'Apply ice packs or cold wet towels to areas with major blood vessels: armpits, groin, neck, and back.',
      'If the person is alert and conscious, provide sips of cool water or oral rehydration solution (ORS).',
      'Monitor body temperature continuously until it drops below 38.5°C (101°F).',
    ],
    whatNotToDo: [
      'Do not administer aspirin or paracetamol; they do not lower environmental heat stroke temperature and can stress liver/kidneys.',
      'Do not force liquids into an unconscious, vomiting, or delirious person.',
      'Do not leave the patient unattended in a hot room.',
    ],
    whenToSeekHelp:
        'Call 108 immediately if the person exhibits confusion, slurred speech, seizures, loss of consciousness, or dry hot skin that has stopped sweating.',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_009',
    title: 'Choking & Airway Obstruction',
    category: FirstAidCategory.respiratory,
    iconKey: 'choking',
    shortDescription:
        'Perform alternating 5 back blows between shoulder blades followed by 5 abdominal thrusts (Heimlich Maneuver) to dislodge obstruction.',
    whenItHappens:
        'Occurs when foreign bodies, large food particles, or small objects become lodged in the larynx or trachea, blocking airflow.',
    steps: [
      'Recognize signs of severe choking: Victim holds hands to throat, cannot speak, cough, or breathe, and faces turning blue.',
      'Stand slightly behind the victim and lean them forward so the head is lower than the chest.',
      'Give 5 firm, distinct back blows between the shoulder blades using the heel of your open hand.',
      'If back blows fail, stand behind the person and wrap both arms around their upper abdomen.',
      'Make a fist with one hand, place the thumb side just above the navel (below the ribcage), grasp the fist with your other hand, and deliver 5 quick upward and inward abdominal thrusts.',
      'Repeat the cycle of 5 back blows and 5 abdominal thrusts until the object pops out or the person becomes unconscious.',
    ],
    whatNotToDo: [
      'Do not perform abdominal thrusts if the person is coughing forcefully; encourage them to cough.',
      'Do not perform blind finger sweeps inside the mouth, which can push foreign objects deeper into the larynx.',
      'Do not use abdominal thrusts on infants under 1 year (use back slaps and gentle chest thrusts instead).',
    ],
    whenToSeekHelp:
        'Call 108 if the object remains stuck after 2 cycles or if the victim loses consciousness (begin CPR chest compressions immediately).',
    emergencyNumber: '108',
  ),
  const FirstAid(
    id: 'fa_010',
    title: 'Severe Dehydration & Electrolyte Depletion',
    category: FirstAidCategory.environmental,
    iconKey: 'dehydration',
    shortDescription:
        'Replenish fluid and essential electrolytes with WHO-formulated ORS, coconut water, or salt-sugar solution in measured frequent sips.',
    whenItHappens:
        'Common during summer heatwaves, disaster relief camps with disrupted potable water, or following acute gastroenteritis and diarrhea.',
    steps: [
      'Move the individual into cool shade and allow them to rest in a recumbent position.',
      'Mix one standard packet of WHO Oral Rehydration Salts (ORS) into 1 liter of clean drinking water.',
      'If ORS packets are unavailable, mix 6 level teaspoons of sugar and half a teaspoon of salt into 1 liter of safe drinking water.',
      'Have the patient drink slowly in small, frequent sips (approx. 200–300 ml every 15–20 minutes) rather than gulping rapidly.',
      'Provide tender coconut water, diluted buttermilk, or rice kanji with a pinch of salt as supplemental fluids.',
    ],
    whatNotToDo: [
      'Do not give undiluted fruit juices, energy drinks, or aerated sodas; high sugar draws water back into the gut.',
      'Do not give caffeine, black tea, or alcohol as they are diuretics.',
      'Do not let the patient engage in further physical work until fully recovered.',
    ],
    whenToSeekHelp:
        'Call 108 or visit an emergency room if the person has sunken eyes, dry tongue, no urination for over 8 hours, extreme lethargy, or inability to keep fluids down.',
    emergencyNumber: '108',
  ),
];
