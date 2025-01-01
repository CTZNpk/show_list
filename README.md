# Show List App

## Overview
The Show List app is a Flutter project that allows users to browse and manage lists of movies, TV shows, and anime. The app integrates Firebase for backend services, such as user authentication and database storage, and fetches data from remote APIs, including TMDb (The Movie Database), OMDb (Open Movie Database), and MyAnimeList (MAL) API. Additionally, users can follow other users and receive notifications when they rate movies or series. This project demonstrates advanced Flutter concepts like API integration, state management using Riverpod, and user authentication.

---

## Features
- **User Authentication**: Secure sign-in and sign-out using Firebase Authentication.
- **Dynamic Content Fetching**:
  - Fetch movie details from TMDb.
  - Fetch TV show information from OMDb.
  - Retrieve anime data from MAL API.
- **Favorites Management**: Allow users to save their favorite items to a personalized list.
- **Search Functionality**: Search for movies, TV shows, or anime using the respective APIs.
- **Detailed Item View**: Display detailed information for selected movies, TV shows, or anime.
- **User Following**: Follow other users and get notifications when they rate movies or series.
- **Offline Support**: Cache user data for offline access.
- **State Management**: Efficient state management implemented using Riverpod.

---

## Prerequisites
- **Flutter SDK**: Ensure Flutter is installed on your system. You can download it from [flutter.dev](https://flutter.dev/docs/get-started/install).
- **Firebase Project**: Set up a Firebase project and configure it for your app.
- **API Keys**: Obtain API keys for TMDb, OMDb, and MAL.
- **IDE**: Recommended IDEs are Visual Studio Code or Android Studio.

---

## Installation

### Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/CTZNpk/show_list.git
    cd show_list
    ```

2. Get the dependencies:
    ```bash
    flutter pub get
    ```

3. Configure Firebase:
    - Download the `google-services.json` file for Android and place it in the `android/app` directory.
    - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner` directory.

4. Add API keys:
    - Open `lib/shared/constants.dart` (or similar configuration file) and add your TMDb, OMDb, and MAL API keys.

5. Run the application:
    ```bash
    flutter run
    ```

---

## How It Works
- **Firebase Authentication**: Allows users to sign in securely, with session management.
- **API Integration**:
  - TMDb API: Fetches detailed movie information, including ratings, cast, and poster images.
  - OMDb API: Retrieves TV show metadata, including synopsis and reviews.
  - MAL API: Fetches anime information, including genre and popularity stats.
- **User Following and Notifications**:
  - Users can follow other users.
  - Notifications are sent when followed users rate movies or series.
- **State Management**:
  - The app uses Riverpod for efficient and reactive state management.
  - Riverpod helps manage global states, such as authentication and API data, in a scalable and testable way.
- **Caching**: Saves user preferences and favorite lists locally for offline access.

---

