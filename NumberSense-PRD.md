# Product Requirements Document (PRD)

**Product Name** NumberSense (working title)  
**Prepared By** Product Management – Non‑Profit Software Lab  
**Prepared For** wizit.org  
**Date** 2025-04-24

---

## 0\. Executive Summary

A mobile‑first Flutter application that helps intellectually disabled learners (10 y/o \+) master foundational numeric concepts – reading multi‑digit numbers (up to 9 999 with optional centimes) and judging relative magnitude – by practising with abstract numbers and photo‑based grocery prices. The app is multilingual (FR • EN • DE • IT), runs fully offline, and syncs optional learner progress via Google One‑Tap sign‑in. No backend dependency; all data lives on‑device, with import/export via JSON.

Success is measured by sustained learner mastery (≥ 90 % accuracy across two consecutive exercise series) and observed transfer to real‑life tasks such as price comparison while shopping. A pilot with FOVAHM & ART21 will validate outcomes before public launch.

---

## 1\. Objectives & Success Metrics

|  \#  | Objective | Metric | Target  |
| :---- | :---- | :---- | :---- |
|  O1  | Empower learners to read & compare up to 4‑digit numbers in the context of shopping | Mastery score per concept (see §4) | ≥ 90 % after 4 weeks use |
|  O2  | Maintain high engagement with \<5‑min micro‑sessions | Median daily session length | 3–5 min |
|  O3  | Offer inclusive, accessible UX  | WCAG 2.2 AA pass on colour contrast; TTS for all text | 100 % screens |
|  O4  | Operate offline, with optional sync | Crash‑free sessions | ≥ 99.5 % |

---

## 2\. Personas

### Learner – “Élise”, 12 yo

- Mild intellectual disability; reads simple words & 2‑digit numbers.  
- Owns a 2018 Android phone.  
- Motivated by positive visual feedback & badges.

### Caregiver/Facilitator – “Marc”, 35 yo

- Special‑ed teacher; manages class tablets.  
- Needs easy import/export of custom grocery photos & prices.  
- Checks progress locally on device before weekly report.

### Stakeholder – “Anne”, 42 yo

- Programme director at ART21.  
- Defines curriculum goals; expects re‑usable architecture for future learning apps (sign‑reading, etc.).

---

## 3\. Learning Model

| Stage | Number Range | Concept | Exercise Type | Difficulty Trigger | Promotion Rule |
| :---- | :---- | :---- | :---- | :---- | :---- |
|  L1  | 0‑99 | Read aloud; bigger/smaller (2 options) | Tap‑to‑match | Start level | n/a |
|  L2  | 0‑999 | Read & compare (2 options); ordering (=) | ≥ 90 % accuracy over 2 series | advance |  |
|  L3  | 0‑9 999 | Compare \+ 3‑option ordering | ≥ 90 % (same rule) | advance |  |
|  L4  | 0‑9 999 \+ centimes\* | Compare ignoring grayed‑out centimes | ≥ 90 % | mastery |  |

\*Centimes are shown faded at 60 % opacity; TTS omits them.

**Series definition** \= 10 exercises. Learner must clear **two consecutive series** at ≥ 9/10 to move up.

On error ≥ 3 within one exercise, show hint overlay (e.g., highlight highest digit). Unlimited retries.

---

## 4\. Content Architecture

lessonpack/               \# top‑level directory per language

  grocery.json            \# array\<Item\>

  images/                 \# 512×512 pngs referenced by id

learner\_progress.json     \# local only

### JSON Schema (excerpt)

{

  "id": "bananas",

  "name": {

    "fr": "Bananes (kg)",

    "en": "Bananas (kg)"

  },

  "prices": \[1.80, 2.10, 2.45\],

  "image": "images/bananas.png"

}

Start‑up bundle: **40 items** (dairy, fruit, veg, pantry). Caregivers may import additional items via in‑app “Admin \> Import” (JSON or ZIP with same structure).

---

## 5\. Gameplay & Progression Logic

- **Session flow**: Home ▶️ “Play 3‑min round” → series of 10 tasks → celebratory animation → badge/unlock check.  
- **Task templates**  
  1. **Compare Numbers (abstract)**  
     UI shows two/three numbers; prompt via TTS: “Quel nombre est plus grand ?”  → learner taps choice.  
  2. **Compare Prices (photo)**  
     UI shows two photos with price tags; same interaction.  
- **Hints**: After **3rd incorrect tap** in same task, overlay appears showing digits aligned, most‑significant digit circled.  
- **Badges**: award after 5, 30, 55, 80 … total correct answers (sequence \+25). Badge sprite & name stored locally.  
- **Unlocks**: Completing all tasks in current level unlocks next grocery “aisle” (visual theme change \+ new photos).

---

## 6\. User Experience (UX)

### 6.1 Information Architecture

| Bottom‑Nav | Purpose |
| :---- | :---- |
| **Learn** (🏠) | Launch next session, show current level |
| **Badges** (⭐) | Gallery of earned badges & unlocked aisles |
| **Settings** (⚙️) | Language, TTS voice, Admin import/export, Sign‑in status |

### 6.2 Key Screens (wireframe description)

1. **Onboarding & Google One‑Tap**  
   - Splash logo \#DA291C background → consent screen (GDPR \+ FADP summary) → Google One‑Tap → local‑only fallback.  
2. **Home / Learn**  
   - Progress ring (concept completion) • “Play” CTA • Last score summary.  
3. **Task – Compare Numbers**  
   - Large numbers/cards (min 56 dp height)  
   - Speaker button top‑right; play/pause/replay only on tap.  
   - Centimes faded (opacity 60%).  
4. **Celebration**  
   - 1‑sec confetti animation; gentle pop sound (device setting‑respecting).  
   - Badge modal if threshold met.  
5. **Badges**  
   - Grid of earned icons; locked aisles greyed.  
6. **Settings / Admin**  
   - Language dropdown • TTS voice picker (device voices) • Import/Export JSON • Reset progress.  
7. **Progress** (sub‑screen)  
   - Horizontal bar chart per concept (read, compare, order).  
   - "Mastered" tag once ≥ 90 %.

### 6.3 Visual Design

| Token | Value |
| :---- | :---- |
| Primary 500 | **\#DA291C** |
| Primary 700 | \#B52017 |
| Accent Success | \#4CAF50 (TBC) |
| Accent Error | \#F44336 (TBC) |
| Background | \#FFFFFF |
| Font | system default (Roboto / SF) |
| All tappable elements ≥ 48 × 48 dp; font scale via OS respected. |  |

### 6.4 Accessibility

- Full keyboard & switch accessibility (FocusTree defined).  
- Dynamic Type; min text size 16 sp.  
- Screen‑reader labels on every control.  
- Colour contrast ≥ 4.5:1.

---

## 7\. Technical Requirements

| Area | Spec |
| :---- | :---- |
| Framework | **Flutter 3.x** (stable) |
| Platforms | Android 8.0 (Oreo) \+ • iOS 13 \+ |
| Devices | Phone min 5" / 2 GB RAM |
| Storage | ≤ 100 MB incl. starter pack |
| Offline | Full functionality; JSON exports via SAF (Android) / Files (iOS) |
| Sync | Google One‑Tap \+ Firebase Auth (no DB) • progress JSON stored in Google Drive app folder |
| Build | CI pipeline → Play Store & App Store; optional APK sideload |
| No‑backend rule | Any future AI/service calls must use API keys stored in secure storage and be strictly optional |

---

## 8\. Data & Privacy

- Local data only (JSON, images).  
- Optional Google account stores encrypted JSON in Drive; user can revoke.  
- No analytics sent remotely; simple event counts kept locally.  
- GDPR \+ Swiss FADP compliant consent flow.

---

## 9\. Admin & Content Management

- **Import**: Pick JSON/ZIP → validate schema → copy into lessonpack dir → regenerate thumb cache.  
- **Export**: Zip current lessonpack \+ progress JSON → share sheet.  
- Admin codepath protected behind long‑press on Settings icon (5 sec).

---

## 10\. Non‑Functional Requirements

| Category | Requirement |
| :---- | :---- |
| Performance | \< 200 ms app cold‑start on 2018 low‑end device |
| Resilience | Recover from interrupted import/export without data loss |
| Security | Secure Storage for auth tokens • AES‑256 encryption for Drive upload |
| QA | 95 % unit‑test coverage core logic; golden‑image testing on critical UI |

---

## 11\. Release Plan

1. **Alpha (internal)** – core gameplay, FR only, dummy photos.  
2. **Beta (pilot)** – full FR \+ EN, admin import, progress screen – deploy to FOVAHM tablets.  
3. **v1.0 GA** – DE \+ IT, badges/unlocks, Drive sync, App Store & Play Store listings.  
   Timeline TBD post‑estimation.

---

## 12\. Future‑Proofing & Next Apps

Modular architecture: `core_engine` package (sessions, scoring, TTS) \+ `lessonpack_*` plugins. Next topics (text reading, airport signs, train schedules) can share 80 % code; only lessonpack JSON & task widgets vary.

---

## 13\. Definition of Done

- ✅ All functional & non‑functional requirements met.  
- ✅ WCAG AA audit pass.  
- ✅ 5‑day pilot shows ≥ 80 % learner satisfaction & zero blocking issues.  
- ✅ PRD sign‑off by stakeholders.
