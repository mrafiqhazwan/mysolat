# MySolatApp - Islamic Prayer Times App

A React Native application for tracking Islamic prayer times, Qibla direction, and more.

## Features

- **Prayer Times**: Accurate prayer times based on your current location
- **Current & Next Prayer**: Display of current prayer with countdown and next prayer time
- **All Daily Prayers**: List of all prayer times for the current day
- **Qibla Direction**: Compass showing the direction to the Kaaba
- **Customizable Settings**: Prayer calculation methods, notification preferences

## Screenshots

[Screenshots will be added here]

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/MySolatApp.git
   cd MySolatApp
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. For iOS, install CocoaPods (if you haven't already):
   ```bash
   cd ios && pod install && cd ..
   ```

4. Run the app:
   ```bash
   # For Android
   npm run android
   
   # For iOS
   npm run ios
   ```

## Technologies Used

- **React Native**: For cross-platform mobile development
- **React Navigation**: For screen navigation and tabs
- **Adhan.js**: For prayer time calculation
- **React Native Sensors**: For compass functionality
- **React Native Geolocation**: For location services
- **React Native Vector Icons**: For beautiful UI icons

## Project Structure

```
src/
├── assets/           # Images and other static assets
├── components/       # Reusable UI components
├── hooks/            # Custom React hooks
├── navigation/       # Navigation configuration
├── screens/          # App screens
└── utils/            # Utility functions
```

## Dependencies

- react-native: 0.73.2
- @react-navigation/native: ^7.0.0
- @react-navigation/bottom-tabs: ^7.0.0
- adhan: ^4.4.3
- react-native-geolocation-service: ^5.3.1
- react-native-sensors: ^7.3.6
- react-native-vector-icons: ^10.0.0
- date-fns: ^3.0.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The [Adhan.js](https://github.com/batoulapps/adhan-js) library for accurate prayer time calculations
- [React Native](https://reactnative.dev/) community for the amazing tools and libraries 