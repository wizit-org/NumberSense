# NumberSense

NumberSense is an educational Flutter application designed to help users develop numerical intuition through interactive number comparison exercises. The app provides a fun and engaging way to practice number comparison skills through various levels of difficulty.

## Features

### Game Modes
- **Number Comparison**: Compare two numbers and select the larger one
- **Price Comparison**: Compare prices of grocery items and select the more expensive one

### Learning Features
- **Detailed Progress Tracking**: Visual representation of correct and incorrect answers
- **Target Thresholds**: Clearly defined success criteria for advancing to the next level
- **Dynamic Difficulty Levels**: Game progresses in difficulty as users improve

### Customizable Settings
- **Questions Per Level**: Adjust the number of questions in each session (default: 3)
- **Target Correct Answers**: Set how many correct answers are needed to pass a level (default: 2)
- **Success Percentage**: Automatically calculated and visualized based on settings

## Screenshots

[Screenshots to be added]

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository
```bash
git clone https://github.com/wizit-org/NumberSense.git
```

2. Navigate to the project directory
```bash
cd NumberSense
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

### Testing

Run tests with:
```bash
flutter test
```

For continuous testing during development, use the included test watcher script:
```bash
./run_tests_loop.sh
```
This script will automatically run tests whenever you make changes to the code.

## Architecture

The app follows a clean architecture approach:
- **Models**: Data structures like `ProgressRecord` and `UserSettings`
- **Controllers**: Game logic in `SessionController`
- **Screens**: UI components for different screens
- **Widgets**: Reusable UI components
- **Engine**: Game mechanics in `LevelManager`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors to the project
