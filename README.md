# DealsDray App

DealsDray is a Flutter application designed to provide users with a seamless experience for browsing and purchasing products. The app features OTP-based authentication, a robust registration process, and a dynamic home screen that displays banners and product listings.

## Features

- **OTP Authentication**: Secure login and registration using OTP verification.
- **Fallback Mode**: Allows testing with mock data when the API is unreachable.
- **Dynamic Home Screen**: Displays banners and product listings fetched from the API.
- **Error Handling**: Robust error handling and retry mechanisms for network requests.

## Getting Started

### Prerequisites

- **Flutter SDK**: Ensure you have Flutter installed on your machine. You can download it from [flutter.dev](https://flutter.dev).
- **Android Studio**: Recommended for running the app on an Android emulator.
- **API Server**: The app connects to a Flask API server running on your host machine.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/dealsdray_app.git
   cd dealsdray_app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   - Ensure your Flask API server is running on `http://127.0.0.1:5000`.
   - Use the following command to run the app on an Android emulator:
     ```bash
     flutter run
     ```

### Configuration

- **API Base URL**: The app is configured to connect to the API using the special IP `10.0.2.2` for Android emulators. Ensure your API server is accessible at this address.

- **Permissions**: The app requires internet permissions, which are configured in `AndroidManifest.xml`.

### Fallback Mode

The app includes a fallback mode that uses mock data for testing when the API is unreachable. This mode is automatically activated if network requests fail.

## Project Structure

- **lib/services/api_service.dart**: Contains the API service class responsible for network requests and handling fallback modes.
- **lib/screens/home_screen.dart**: Defines the home screen UI, including banner and product grid components.
- **android/app/src/main/AndroidManifest.xml**: Configures app permissions and settings for Android.

## Troubleshooting

- **Connection Issues**: Ensure your API server is running and accessible. The app uses `10.0.2.2` to connect to the host machine from an Android emulator.
- **Linter Errors**: Check for missing dependencies or incorrect imports if you encounter linter errors.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
