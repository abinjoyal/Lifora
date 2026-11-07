# Lifora — Personal Memory Journal

> A modern, offline-first personal memory journal for Android designed to preserve life's special moments with photos, dates, geographic locations, and stories.

---

## Concept and Philosophy

In a world dominated by cloud subscriptions and data tracking, Lifora takes a fundamentally different path:

- **100% User Data Ownership**: Your memories, photos, and journal entries are stored directly in your chosen folder on your device using Android's Storage Access Framework (SAF).
- **Zero Cloud / No Accounts**: No logins, no Firebase, no cloud sync, and no third-party tracking. Lifora operates 100% offline.
- **Transparent Open Formats**: Memory metadata is preserved as standard, readable JSON files alongside original media files. If you ever uninstall Lifora, your files remain yours forever.
- **Warm and Photo-Focused Design**: Built with a custom "Sunset Orange" design system featuring warm peach tones, soft curves, and typography optimized for reading.

---

## Key Features

### 1. Memories Journal
- Chronological timeline of personal memories.
- Rich storytelling with multi-photo support, cover photo selection, categories, tags, and favorite badges.
- Memory categories: *Travel, Family, Friends, Love, Milestones, Everyday, Special*.

### 2. Interactive Memory Map
- Visual geospatial memory exploration using `flutter_map` (OpenStreetMap) and `latlong2`.
- Custom Sunset Orange pin markers with photo thumbnails and count badges for grouped locations.
- Bottom sheet previews, address lookups, date/category filters, and one-tap current GPS location centering.

### 3. Timeline and Calendar View
- Interactive monthly grid with memory badge indicators.
- Annual matrix view for multi-year memory navigation.
- Accurate multi-year and leap-year calculations with quick jump to "Today".

### 4. Advanced Offline Search
- Instant, debounced local search across titles, descriptions, location names, addresses, tags, and dates.
- Search suggestions, recent queries history (stored locally), and category/favorite filters.
- Full multi-language and Tamil Unicode text query support.

### 5. Local Notifications and Reminders
- Scheduled local notifications powered by `flutter_local_notifications` and timezone scheduling.
- **On This Day**: Relive memories from 1 year ago, 2 years ago, and earlier anniversaries.
- Custom event reminders (birthdays, anniversaries, special occasions).
- Daily reflection prompts and an in-app Notification Inbox with read/unread tracking.

### 6. Settings, Privacy and Data Export
- **Appearance**: Light (Sunset Orange), Dark mode, and System Default theme support.
- **Language**: English and தமிழ் (Tamil) interface support.
- **Storage Management**: SAF folder permissions status, reconnection, and verification tools.
- **Backup and Export**: One-tap local JSON export of your complete memory archive.

---

## Architecture and Tech Stack

Lifora is architected following Clean Architecture with feature-driven modularization:

```
lib/
├── core/                  # Theme, router, services, constants & utilities
├── features/
│   ├── splash/            # App bootstrapper
│   ├── onboarding/        # Welcome carousel & privacy introduction
│   ├── storage/           # SAF folder picker & connection setup
│   ├── home/              # Central dashboard & memory highlights
│   ├── memories/          # Memory CRUD, form validation & media linking
│   ├── photos/            # Native photo picker, album browsing & gallery
│   ├── location/          # GPS, Nominatim geocoding & location picker
│   ├── map/               # Interactive map exploration & clusters
│   ├── calendar/          # Monthly calendar & year matrix
│   ├── search/            # Offline query engine & recent searches
│   ├── notifications/     # Local scheduling & reminder inbox
│   └── settings/          # Preferences, backup, language & storage tools
└── shared/                # Global enums, models, extensions & widgets
```

### Core Technologies

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Android target) |
| **State Management** | Flutter Riverpod 2.x |
| **Navigation** | GoRouter |
| **Storage Engine** | Android Storage Access Framework (SAF) + Native Kotlin Channel |
| **Indexing** | Local JSON manifests + Drift SQLite local cache |
| **Maps and Location** | `flutter_map`, `latlong2`, `geolocator`, `geocoding` |
| **Notifications** | `flutter_local_notifications`, `timezone` |
| **Java Compatibility** | Android Core Library Desugaring (JDK 17) |

---

## Theme and Design System

Lifora adheres to a signature warm aesthetic:

- **Primary Orange**: `#F47B45`
- **Dark Orange**: `#B94E2D`
- **Peach Container**: `#FFE2CC`
- **Warm Background**: `#FFF8F1`
- **Main Text**: `#38251F`
- **Secondary Text**: `#806A60`
- **Typography**: Inter

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.24.0` or higher
- Android SDK 35 (`compileSdk = 35`, `minSdk = 24`)
- Java 17

### Installation and Run

1. Fetch Flutter packages:
   ```powershell
   flutter pub get
   ```

2. Run code analysis:
   ```powershell
   flutter analyze
   ```

3. Launch on an Android emulator or connected device:
   ```powershell
   flutter run
   ```

---

## License

This project is licensed under the MIT License — see the LICENSE file for details.
