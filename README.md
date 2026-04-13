# myapp

A new Flutter project.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
*   Dart SDK: Included with Flutter

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username_/your_project_name.git
    ```
2.  Install packages
    ```sh
    flutter pub get
    ```
3.  Run the app
    ```sh
    flutter run
    ```

## Features

*   **Medication Tracking:** Add and manage your medications.
*   **Scheduling:** Set up reminders for when to take your medicine.
*   **History:** View a history of taken and skipped doses.
*   **Reports:** Get reports on your medication adherence.
*   **Customizable Settings:** Personalize the app with theme and language settings.

## Project Structure

The project follows a feature-first structure:

```
lib/
└── src/
    ├── features/
    │   ├── add_medicine/
    │   ├── history/
    │   ├── home/
    │   ├── report/
    │   └── settings/
    ├── core/
    │   ├── database/
    │   ├── notifications/
    │   └── theme/
    └── l10n/
```

## Dependencies

This project uses several key dependencies, including:

*   [go_router](https://pub.dev/packages/go_router): For navigation.
*   [provider](https://pub.dev/packages/provider): For state management.
*   [sqflite](https://pub.dev/packages/sqflite): For local database storage.
*   [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications): For scheduling notifications.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
