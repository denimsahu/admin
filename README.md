# Admin Application – Where Is My Bus

## Overview
The Admin App is the control center of the Smart Bus Tracking System.
It is responsible for driver management, route creation, permissions, and live monitoring of all buses.

This application is designed for system administrators / transport authorities and provides full visibility and control over the entire fleet.

This app is part of a larger three-application ecosystem consisting of Admin, Driver, and User apps.

---


## Key Responsibilities
- Secure administrator authentication
- Driver creation and management
- Route creation using Google Maps
- Live monitoring of all buses
- Permission-based visibility control for users
- Administrative override without stopping tracking


---


## Features Breakdown
### Authentication & Security
- Admin logs in using:
  - Username + Password
  - OTP-based verification (Phone Auth)
- Admin accounts are pre-created in Firebase by stakeholders
- Every login requires OTP verification for added security
  
**Why this matters:**

Prevents unauthorized access to fleet-level controls.

### Live Bus Monitoring
- Admin dashboard displays:
  - All buses on Google Maps
  - Current or last known location
- Buses are color-coded:
  - 🟢 Active & visible to users
  - 🔴 Active but hidden from users
  - 🟡 Inactive / stopped
  
Admin always sees all buses, regardless of user visibility status.


---


### Driver Management
- Create new drivers
- Assign:
  - Login credentials
  - Phone number
  - Route
- View driver details and current state
- Modify driver permissions in real time


---


### Permission Control (Critical Feature)
**Admins can enable or disable driver visibility for users:**
- `true` → visible to users  
- `false` → hidden from users, visible only to admin 

Important design choice:
- Driver continues sharing location
- Admin still sees live data
- Users do not see restricted buses

This allows:
- Safety audits
- Soft bans
- Operational reviews

---


### Route Creation
- Admin creates routes by selecting multiple points on Google Maps
- Routes are stored as:
  - List<LatLng> in Firestore
- These routes are:
  - Rendered in Driver App
  - Used by User App for filtering buses
Note:
Current implementation uses polylines (no Google Directions API), making it API-cost-safe.


---


## App Architecture
### State Management
The Admin App uses the BLoC pattern extensively:
BLoCs include:
- LoginBloc
- VerifyOtpBloc
- HomeBloc
- CreateDriverBloc
- AddStopsBloc
- PermissionBloc

Each feature has:
- Event
- State
- Business logic separation
This keeps UI clean and logic testable.


---


### Firebase Integration
Firebase services used:
Firebase Authentication
- Email/password
- Phone OTP

Cloud Firestore
- Drivers collection
- Routes
- Permissions
- Live locations

Firestore acts as the single source of truth across all apps.


---


### Folder Structure (lib)
```
lib/
│
├── global/
│   ├── Widgets/
│   │   ├── CustomBigElevatedButton.dart
│   │   ├── CustomTextFormField.dart
│   │   └── CustomTextFormFieldWithIcon.dart
│   └── Variables.dart
│
├── Home/
│   ├── bloc/
│   │   ├── home_bloc.dart
│   │   ├── home_event.dart
│   │   └── home_state.dart
│   └── View/
│       └── Home.dart
│
├── Login/
│   ├── login/
│   │   ├── bloc/
│   │   │   ├── add_stops_bloc.dart
│   │   │   ├── add_stops_event.dart
│   │   │   └── add_stops_state.dart
│   │   └── View/
│   │       └── login.dart
│   ├── verifyOtp/
│   │   ├── bloc/
│   │   │   ├── verify_otp_bloc.dart
│   │   │   ├── verify_otp_event.dart
│   │   │   └── verify_otp_state.dart
│   │   └── View/
│   │       └── Verify_Otp.dart
│   └── variables.dart
│
├── NewDriver/
│   ├── bloc/
│   │   ├── add_stops_bloc.dart
│   │   ├── add_stops_event.dart
│   │   ├── add_stops_state.dart
│   │   ├── create_driver_bloc.dart
│   │   ├── create_driver_event.dart
│   │   └── create_driver_state.dart
│   └── View/
│       ├── AddStops.dart
│       └── NewDriver.dart
│
├── permission/
│   └── permission.dart
│
├── Splash/
│   └── Splash.dart
│
├── firebase_options.dart
│
└── main.dart
```

---


## Setup Instructions (After Cloning)
### 1️ Firebase Setup
You must provide your own Firebase configuration:
- Add google-services.json (Android)
- Add GoogleService-Info.plist (iOS)
- Generate firebase_options.dart
These files are intentionally excluded from Git.


---


### 2️ Google Maps API Key
Add your API key via Gradle properties:

*android\gradle.properties*
```
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```
The app uses manifestPlaceholders to inject this securely.


----


### 3️ Permissions
Ensure the following permissions exist in AndroidManifest.xml:
- Location access
- Internet access
- Foreground service (required for monitoring)


---


### 4️ Run the App
```
flutter clean
flutter pub get
flutter run
```

---



## Design Decisions Worth Highlighting
Visibility ≠ Tracking
- Admin can hide buses without stopping location collection

BLoC for scalability
- App designed to grow without UI logic leaks

No direct app coupling
- All communication via Firestore

Security first
- OTP enforced on every admin login


---


## Known Limitations
- Routes currently use polylines instead of Google Directions API
- Admin accounts must be manually created in Firebase
- No role-based admin hierarchy (single admin role)


---


## Who Should Use This App
- Transport administrators
- Fleet managers
- Operations monitoring teams


---


## Related Repositories

Driver App – Location broadcasting & route following
- https://github.com/denimsahu/driver23

User App – Bus discovery & live tracking
- https://github.com/denimsahu/user 
