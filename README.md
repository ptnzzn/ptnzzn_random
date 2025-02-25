<p align="center">
  <img src="assets/images/app_ico.png" alt="App Logo" width="100" height="100">
</p>
<h1 align="center">ptnzzn_random</h1>

# ptnzzn_random

A random app with two features: Yes or No and Spin Wheel.

## Features

- **Yes or No**: A simple feature to help you make decisions.
- **Spin Wheel**: A fun spin wheel to randomly select an option.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- [Dart](https://dart.dev/get-dart) SDK.

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/ptnzzn_random.git
   cd ptnzzn_random
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

### Running the App
To run the app on an emulator or physical device, use:
```sh
flutter run
```

### Building the APK
To build a release APK, use:
```sh
flutter build apk --release
```
The APK will be generated in the `build/app/outputs/flutter-apk` directory.

### Localization
This project uses the `easy_localization` package for localization. Supported languages:
- English
- Vietnamese

### Dependencies
- `flutter_bloc`
- `go_router`
- `flutter_fortune_wheel`
- `flutter_svg`
- `flutter_launcher_icons`
- `shared_preferences`
- `provider`
- `rxdart`
- `intl`
- `easy_localization`
- `package_info_plus`