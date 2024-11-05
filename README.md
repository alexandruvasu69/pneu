# pneu 🚴🌍

pneu is an app designed for bikers that crave safe and optimised navigation routes in Bucharest. It offers information about bicycle lanes, parking spaces and friendly spots for people that enjoy this way of transitting the city.

---

## Description

This app proposes a navigation experience similar to Waze, but specially adapted for bikers. Users can access safe routes and discover useful locations around Bucharest, including repair shops, rental stations and parking spots.

---

## Functionalities

- **Real time navigation** with optimised routes for bicycles.
- **Interactive map** with bike lanes and friendly spots for comuters.
- **Safety and traffic alerts** (eg. busy roads, unsafe zones).
- **User feedback** for marking obstacles and route problems.
- **Social media integration** for route sharing.

---

## Technologies

- **Frontend**: [Flutter](https://flutter.dev/) - cross-platform UI framework 
- **Backend**: [Firebase](https://firebase.google.com/) - autentification, database and analytics
- **Maps and routing**: [Google Maps API](https://cloud.google.com/maps-platform) for routing and navigation

---

## Initial Setup

### Prerequisites

- **Flutter SDK**: make sure it is installed [Flutter SDK](https://flutter.dev/docs/get-started/install).
- **Android Studio / Xcode**: required for emulators and debugging.
- **Google Cloud Account**: for configuring and using Google Maps API.
- **Firebase Account**: for autentification and database.

### Instalation and configuration

1. **Clone the repo**:

   ```bash
   git clone https://github.com/alexandruvasu69/pneu.git
   cd pneu

2. **Install necessary packages**:
   
   flutter pub get

3. **Set up Google Maps API**:

    - Create a project on Google Cloud Console.
    - Enable Maps SDK for Android and Maps SDK for iOS.
    - Get an API key and add it to the .env file (make sure to exclude this file from git):
        
        GOOGLE_MAPS_API_KEY=your_api_key_here

4. **Set up Firebase**:
    - Create a project on Firebase Console.
    - Add the app for Android and iOS, download the configuration files (google-services.json for Android and GoogleService-Info.plist for iOS), and place them in the appropriate directories.

5. **Run the app**:

    flutter run