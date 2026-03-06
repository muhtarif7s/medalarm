# Medication Manager App Blueprint

## Overview

The Medication Manager is a Flutter application designed to help users track their medications. It allows users to add medications, schedule doses, and keep a history of their medication intake. The app also provides notifications to remind users to take their medications.

## Features

### Core Features

*   **Medication Management:** Add, edit, and delete medications. Each medication has a name and a dosage.
*   **Dose Tracking:** Schedule doses for each medication. Mark doses as taken, skipped, or missed.
*   **History:** View a history of all medication doses.
*   **Notifications:** Receive notifications for upcoming medication doses.

### Implemented Features

*   **Home Screen:** Displays a list of current medications.
*   **Add/Edit Medication Screen:** A form to add or edit a medication.
*   **History Screen:** Displays a list of all doses, with the ability to mark them as taken or skipped.
*   **Settings Screen:** Allows the user to switch between light, dark, and system default themes.
*   **Navigation:** A bottom navigation bar to switch between the Home, History, and Settings screens.
*   **Theme:** A custom theme with light and dark modes, using the `google_fonts` package for custom fonts.
*   **Persistence:** The app uses an `sqflite` database to persist medication and dose data.
*   **State Management:** The app uses the `provider` package for state management.
*   **Notifications:** The app uses the `flutter_local_notifications` package to schedule and display local notifications for upcoming medication doses. The app requests notification permissions on startup.

## Design

*   **UI:** The app uses the Material Design 3 design system.
*   **Fonts:** The app uses the `google_fonts` package to use the Oswald, Roboto, and Open Sans fonts.
*   **Theme:** The app has a custom theme with a deep purple primary color.

## Project Structure

```
lib
├── src
│   ├── app_router.dart
│   ├── theme_provider.dart
│   └── features
│       └── medication
│           ├── data
│           │   ├── models
│           │   │   ├── dose.dart
│           │   │   └── medication.dart
│           │   └── repositories
│           │       ├── dose_repository.dart
│           │       └── medication_repository.dart
│           └── presentation
│               ├── providers
│               │   ├── dose_provider.dart
│               │   └── medication_provider.dart
│               ├── screens
│               │   ├── add_edit_medication_screen.dart
│               │   ├── history_screen.dart
│               │   ├── home_screen.dart
│               │   └── settings_screen.dart
│               └── services
│                   ├── notification_service.dart
│                   └── scheduling_service.dart
└── main.dart
```
