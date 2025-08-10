Ticket Scanning and Management System (Agni warsha live concert)

A Flutter application for scanning and managing event tickets with Firebase Firestore backend.
Features

    Ticket Scanning: Scan QR/barcode tickets using mobile camera

    Check-In/Check-Out: Track attendee status with timestamp recording

    Admin Dashboard: View all tickets and add new tickets manually

    Bulk Upload: Upload large quantities of tickets at once

    Ticket Validation: Verify ticket authenticity and usage status

Screens

    Home Screen: Main navigation with buttons for scanning, admin access, and check-out

    Scanner Screen: QR/barcode scanning interface

    Check-In/Out Screen: Detailed ticket status with toggle functionality

    Admin Dashboard: Ticket management interface

Firebase Collections

    tickets: Stores all ticket data with fields:

        isUsed: Boolean for initial usage status

        isCheckedIn: Boolean for current check-in status

        isCheckedOut: Boolean for check-out status

        eventId: Associated event identifier

        lastCheckInTime: Timestamp of last check-in

        lastCheckOutTime: Timestamp of last check-out

Setup Instructions

    Firebase Configuration:

        Create a Firebase project

        Add Firestore database

        Add your Firebase configuration to lib/firebase_options.dart

    Dependencies:
    yaml

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.15.1
  cloud_firestore: ^4.9.1
  mobile_scanner: ^3.0.0

Running the App:
bash

    flutter pub get
    flutter run

    Bulk Upload:

        Run the bulk.dart file to upload sample tickets

        Or use the generate_csv.dart script to create a CSV for import

Usage

    Attendee Flow:

        Scan ticket QR code

        View current status

        Toggle check-in/check-out status

    Admin Flow:

        View all tickets and their statuses

        Add individual tickets manually

        Monitor event attendance

File Structure
text

lib/
├── admin_dashboard_screen.dart   # Admin management interface
├── barcode_scanner_screen.dart   # Ticket scanning screen
├── check_in_out.dart             # Check-in/out functionality
├── custom_button.dart            # Reusable button component
├── firebase_service.dart         # Firebase operations
├── generate_csv.dart             # CSV generator for bulk upload
├── main.dart                     # Main application entry
bulk.dart                         # Bulk ticket upload utility

License

This project is open-source and available under the MIT License.