# pneu - Smart Cycling Navigation App (Flutter + Supabase + PostGIS/pgRouting + Mapbox)

> A mobile navigation app designed for cyclists in Bucharest.  
> Built with **Flutter**, **Supabase/PostgreSQL**, **PostGIS/pgRouting**, and **Mapbox SDK**.

---

## 🚀 Overview

**pneu** (personal project / bachelor's thesis project) is a **real-time cycling navigation application** focused on safer & more efficient routing for cycling in Bucharest.

Unlike Google Maps in Bucharest, the app integrates:

- dedicated cycling infrastructure (bike lanes, shared lanes, pedestrian-friendly shortcuts),
- bike-specific routing algorithms,
- road safety metadata.

---

## Features

| Category | Feature | Status |
|----------|---------|--------|
| 🗺️ Map & Navigation | Mapbox integration (vector tiles, gestures, camera position syncing) | ✅ |
| | Custom Mapbox styling (custom style hosted on Mapbox Studio) | ✅ |
| | Camera animations (smooth transitions on routing / centering map) | ✅ |
| | Tap / long-press on map to drop marker & start routing | ✅ |
| | Live event rendering | ✅ |
| 📍 Geolocation | Real-time GPS tracking | ✅ |
| | Reverse geocoding → convert coordinates to human-friendly address | ✅ |
| | Auto-center user location toggle (lock / unlock camera) | ✅ |
| 🚴 Routing Engine | Live route computation using **pgRouting (Dijkstra)** | ✅ |
| | Multiple route options (alternative routes) | ✅ |
| | Draw route on the map (polyline layer + animation) | ✅ |
| | Support for cycling-specific routing (towards bike lanes) | ✅ |
| | Multi-stop routing (waypoints) | In progress |
| 📊 Data / Backend | PostGIS spatial indexing for performance | ✅ |
| | pgRouting server-side routing computation | ✅ |
| | Filtering events based on viewport bounding box | ✅ |
| | Crowdsource events (user can submit events regarding infrastructure/safety) | ✅ |

### Authentication / Security
- Supabase Auth
- JWT tokens handled automatically on client
- Role-based access control (`admin`, `user`, `guest`)
- Secure API endpoints + Postgres RLS
- Protected admin-only actions (moderate events, delete, publish)

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter (Dart), Hooks, Provider state management |
| Backend | Supabase (Postgres + authentication + REST API) |
| GIS engine | PostGIS + pgRouting |
| Mapping | Mapbox Maps SDK |
| Deployment | Android APK / AppBundle |

---

## 📱 Demo

📲 **Download APK (Android):**
https://github.com/alexandruvasu69/pneu/releases/tag/v1.0.0

You can either install the APK on a real Android device (for this you might need to be located in Bucharest though or override your location settings) or run it in an emulator (guide below).

---

## Running the Demo using Android Emulator

If you do not want to use a physical device, run the APK in an Android Emulator.

### Requirements
- Android Studio installed
- Android Virtual Device configured (e.g., Pixel 7, Android 14)

### Installation steps
1. Open **Android Studio**
2. Go to: `More Actions → Virtual Device Manager`
3. Create a new virtual device (e.g., *Pixel 7*)
4. Start the emulator
5. Drag and drop the downloaded APK file into the emulator window

### Important — Set GPS location to Bucharest 📍 

The routing system uses your GPS location.  
To make the demo meaningful, set the emulator location to Bucharest:

1. Open emulator → press **More (…)**
2. Go to **Location**
3. Enter the coordinates in the search bar: 44.447686, 26.096564
4. Save point
5. Press  **Save Location**

---

🔗 **Live Web Demo (emulated Android device):**
https://appetize.io/app/b_d3nxiipnwz33qlqys7zczc2qgy

> In the web demo you'll see a virtual Android phone running the app.

### For this, the GPS location needs to be set to Bucharest as well.

1. Press on **Location**

<img width="475" height="307" alt="Screenshot 2025-11-11 at 19 10 37" src="https://github.com/user-attachments/assets/ce9b6ece-bf66-4d7d-a017-d505cab2ebb5" />

2. Set the coordinates (44.447686, 26.096564)

<img width="475" height="307" alt="Screenshot 2025-11-11 at 19 12 10" src="https://github.com/user-attachments/assets/9435c570-6e84-42f5-8178-6c3b2e3d3731" />

3. Press **Change Location**
