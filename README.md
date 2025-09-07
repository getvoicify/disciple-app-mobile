# Disciple Mobile

[![Build & Deploy](https://github.com/thompsonedolo/disciple_mobile/workflows/Build%20%26%20Deploy/badge.svg)](https://github.com/thompsonedolo/disciple_mobile/actions/workflows/build-deploy.yml)
[![PR Checks](https://github.com/thompsonedolo/disciple_mobile/workflows/PR%20Checks/badge.svg)](https://github.com/thompsonedolo/disciple_mobile/actions/workflows/pr-checks.yml)
[![codecov](https://codecov.io/gh/thompsonedolo/disciple_mobile/branch/main/graph/badge.svg?token=YOUR_TOKEN)](https://codecov.io/gh/thompsonedolo/disciple_mobile)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.19.0-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Christian companion app

## CI/CD Status

| Workflow | Status | Description |
|----------|--------|-------------|
| PR Checks | ![PR Checks](https://github.com/thompsonedolo/disciple_mobile/workflows/PR%20Checks/badge.svg) | Linting, tests, and code quality |
| Build & Deploy | ![Build & Deploy](https://github.com/thompsonedolo/disciple_mobile/workflows/Build%20%26%20Deploy/badge.svg) | Automated deployment to Play Store |
| Code Coverage | [![codecov](https://codecov.io/gh/thompsonedolo/disciple_mobile/branch/main/graph/badge.svg?token=YOUR_TOKEN)](https://codecov.io/gh/thompsonedolo/disciple_mobile) | Test coverage tracking |

## Getting Started

### Prerequisites

- Flutter 3.19.0 or higher
- Android Studio / VS Code
- Android SDK

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/thompsonedolo/disciple_mobile.git
   cd disciple_mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Development

- **Linting**: `flutter analyze`
- **Format**: `dart format .`
- **Tests**: `flutter test`
- **Build APK**: `flutter build apk`
- **Build AAB**: `flutter build appbundle`

## Deployment

This project uses GitHub Actions for automated deployment:

- **Pull Requests**: Automatic linting and testing
- **Main Branch**: Automatic deployment to Play Store Internal track
- **Production**: Manual promotion through workflow

See [GitHub Actions Setup Guide](docs/GITHUB_ACTIONS_SETUP.md) for detailed configuration.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
