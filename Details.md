# Medication Tracker - Project Documentation

## 1. Application Overview

The application is a Flutter-based medication tracker designed to help users manage their medications effectively. It allows users to schedule medication intake, track doses, and view their medication history. The app also provides local notifications to remind users to take their medications, ensuring they stay on track with their treatment plans.

## 2. Project Structure

The project follows a feature-driven directory structure, which promotes modularity and maintainability. Below is a detailed breakdown of the project's structure:

```
lib/
├── main.dart
├── l10n/
│   ├── app_ar.arb
│   ├── app_en.arb
│   ├── app_es.arb
│   ├── app_localizations.dart
│   ├── app_localizations_ar.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_es.dart
└── src/
    ├── database/
    │   └── database_helper.dart
    ├── features/
    │   ├── add_medicine/
    │   │   ├── presentation/
    │   │   │   ├── screens/ 
    │   │   │   │   └── add_medicine_screen.dart
    │   │   │   └── widgets/
    │   │   │       ├── add_medicine_form.dart
    │   │   │       ├── frequency_selector.dart
    │   │   │       └── start_date_selector.dart
    │   ├── doses/
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   ├── dose.dart
    │   │   │   │   └── dose_schedule.dart
    │   │   │   └── repositories/
    │   │   │       ├── dose_repository.dart
    │   │   │       └── dose_schedule_repository.dart
    │   │   └── presentation/
    │   │       └── providers/
    │   │           └── dose_provider.dart
    │   ├── history/
    │   │   ├── data/
    │   │   │   └── models/
    │   │   │       └── dose_history_model.dart
    │   │   └── presentation/
    │   │       ├── screens/
    │   │       │   └── history_screen.dart
    │   │       └── widgets/
    │   │           └── history_list.dart
    │   ├── home/
    │   │   └── presentation/
    │   │       ├── screens/
    │   │       │   └── home_screen.dart
    │   │       └── widgets/
    │   │           ├── daily_stats_card.dart
    │   │           ├── header_section.dart
    │   │           ├── medicine_cards.dart
    │   │           ├── next_dose_card.dart
    │   │           ├── quick_actions.dart
    │   │           ├── smart_alerts.dart
    │   │           └── timeline.dart
    │   ├── main/
    │   │   └── presentation/
    │   │       └── screens/
    │   │           └── main_screen.dart
    │   ├── medication/
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   ├── day_of_week.dart
    │   │   │   │   ├── medication.dart
    │   │   │   │   └── medication_schedule.dart
    │   │   │   └── repositories/
    │   │   │       ├── medication_repository.dart
    │   │   │       └── repositories.dart
    │   │   ├── presentation/
    │   │   │   ├── providers/
    │   │   │   │   └── medication_provider.dart
    │   │   │   ├── screens/
    │   │   │   │   ├── add_edit_medication_screen.dart
    │   │   │   │   ├── history_screen.dart
    │   │   │   │   ├── home_screen.dart
    │   │   │   │   └── medication_details_screen.dart
    │   │   │   ├── services/
    │   │   │   │   ├── daily_reset_service.dart
    │   │   │   │   ├── dose_service.dart
    │   │   │   │   ├── medication_service.dart
    │   │   │   │   └── notification_service.dart
    │   │   │   └── widgets/
    │   │   │       ├── day_of_week_selector.dart
    │   │   │       ├── dose_history_list.dart
    │   │   │       ├── interval_selector.dart
    │   │   │       ├── medication_form_field.dart
    │   │   │       ├── medication_list_item.dart
    │   │   │       └── time_selector.dart
    │   │   └── scheduling_service.dart
    │   ├── medicine/ **(Duplicated)**
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   └── medicine_model.dart
    │   │   │   └── medicine_service.dart
    │   │   └── presentation/
    │   │       └── screens/
    │   │           └── add_edit_medicine_screen.dart
    │   ├── settings/
    │   │   ├── data/
    │   │   │   └── models/
    │   │   │       └── profile_model.dart
    │   │   └── presentation/
    │   │       ├── providers/
    │   │       │   ├── locale_provider.dart
    │   │       │   └── settings_provider.dart
    │   │       ├── screens/
    │   │       │   └── settings_screen.dart
    │   │       └── widgets/
    │   │           ├── settings_row.dart
    │   │           └── user_profile_header.dart
    │   └── statistics/
    │       └── presentation/
    │           ├── screens/
    │           │   └── statistics_screen.dart
    │           └── widgets/
    │               ├── monthly_overview.dart
    │               └── most_skipped.dart
    ├── providers/
    │   └── locale_provider.dart
    ├── services/
    │   └── database_service.dart
    └── theme_provider.dart
```

## 3. Screens

The application is composed of several screens, each responsible for a specific feature:

- **Add/Edit Medicine Screen**: Allows users to add a new medication or edit an existing one.
- **History Screen**: Displays the history of medication doses taken by the user.
- **Home Screen**: The main dashboard of the application, providing an overview of the user's medication schedule.
- **Main Screen**: Acts as the main container for the application, hosting a bottom navigation bar to switch between different screens.
- **Medication Details Screen**: Displays detailed information about a specific medication.
- **Settings Screen**: Allows users to configure application settings, such as theme and language.
- **Statistics Screen**: Provides a visual representation of the user's medication adherence.

## 4. Architecture

### 4.1. Navigation

The application uses the `go_router` package for navigation, but the implementation is not optimal. Instead of a centralized routing configuration, it relies on imperative navigation (`Navigator.push()`), which makes the navigation flow difficult to manage and scale.

**Recommendation**: Implement a centralized routing system with `go_router` to create a more predictable and maintainable navigation structure.

### 4.2. State Management

The application uses the `provider` package for state management. This approach is simple and effective for a small application, but it can become challenging to manage as the application grows.

**Recommendation**: For a more scalable and robust state management solution, consider migrating to `Riverpod` or `Bloc`.

### 4.3. Database

The application uses an `sqflite` database for local data persistence. The database consists of three tables:

- **`medications`**: Stores information about each medication.
- **`dose_schedules`**: Stores the scheduled doses for each medication.
- **`doses`**: Stores the history of taken doses.

## 5. Code Quality

### 5.1. Code Duplication

The most significant issue in the project is the code duplication between the `medication` and `medicine` features. This duplication includes models, services, and screens, which increases the maintenance burden and the risk of inconsistencies.

**Refactoring Strategy**:

1.  **Consolidate Models**: Merge `MedicineModel` into `Medication` and remove the duplicate file.
2.  **Consolidate Services**: Merge `MedicineService` into `MedicationService` and remove the duplicate file.
3.  **Consolidate Screens**: Merge the `add_edit_medicine_screen.dart` from the `medicine` feature into the `add_edit_medication_screen.dart` in the `medication` feature.
4.  **Remove Duplicated Feature**: Once all the duplicated code has been consolidated, the `medicine` feature can be safely removed.

### 5.2. Testing

The project includes a `test` directory with some unit and widget tests, but the test coverage is low. A robust testing strategy is crucial for ensuring the application's quality and stability.

**Recommendation**:

- Write unit tests for all services and providers.
- Write widget tests for all screens.
- Use a code coverage tool to measure test coverage and identify areas that need more testing.

## 6. Final Summary and Recommendations

The application has a solid foundation with a feature-driven architecture and a good set of features. However, it suffers from significant code duplication, a poorly structured navigation system, and low test coverage. By addressing these issues, the application can be made more robust, maintainable, and scalable.

**Prioritized Recommendations**:

1.  **Refactor Duplicated Code**: This is the most critical issue and should be addressed first.
2.  **Improve Navigation**: Implement a centralized routing system with `go_router`.
3.  **Increase Test Coverage**: Write more unit and widget tests to ensure the application's quality.
4.  **Enhance State Management**: Consider migrating to a more advanced state management solution like `Riverpod` or `Bloc`.
