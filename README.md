# Smart Garage project 


**Garage_IOT** is a DIY smart garage system built using Arduino (C++) and a Flutter (Dart) mobile app to monitor and control the garage remotely.

---

##  Overview

- **Purpose**: Allow users to open, close, and receive status updates of their garage door via mobile.
- **Core Components**:
  - `Garage_Code.ino`: Arduino firmware handling sensor and actuator control.
  - Flutter app (`.dart` files): User interface and remote interaction logic.
  - `Circuit_Design/`: Hardware schematics and wiring diagrams.
  - `Documents/`: Project Presentation/Report
  - `Video/`: Demo video.

---

##  Getting Started

### Prerequisites
- **Hardware**: Arduino board, motor or actuator for door control, sensors (e.g., limit switch, ultrasonic sensor), wiring, power supply.
- **Software**:
  - [Arduino IDE](https://www.arduino.cc/en/software) (or PlatformIO)
  - Flutter SDK (for building and running the app)
  - Any dependencies listed in `pubspec.yaml`

### Installation & Setup

1. **Arduino Firmware**  
   - Open `Garage_Code.ino` in the Arduino IDE.  
   - Modify pin assignments to match your hardware setup.  
   - Upload to your Arduino board.

2. **Flutter App**  
   - Navigate to the Flutter project (where `.dart` files reside).  
   - Run `flutter pub get` to fetch packages.  
   - Launch using `flutter run` on a connected device or emulator.  
   - Configure any required IP or Bluetooth settings to connect with your Arduino.

3. **Circuit Setup**
   - Build the hardware as per the wiring diagrams in `Circuit_Design/`.

---

##  Usage

- Open the app to monitor the current state of your garage door.
- Tap **Open** or **Close** buttons to control the door remotely.
- The app shows real-time status notifications (e.g., “Opening…”, “Closed”).
