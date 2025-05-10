import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(bulk());
}

class bulk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Bulk Upload Tickets')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await bulkUploadTickets();
            },
            child: Text('Upload Tickets'),
          ),
        ),
      ),
    );
  }
}

Future<void> bulkUploadTickets() async {
  final firestore = FirebaseFirestore.instance;

  // Example list of ticket IDs
  final ticketIds = List.generate(600, (index) => 'ticket${index + 1}');

  // Add tickets to Firestore
  for (final ticketId in ticketIds) {
    await firestore.collection('tickets').doc(ticketId).set({
      'isUsed': false,
      'isCheckedOut': false,
      'eventId': 'Agni Warsha', // Replace with your event ID
    });
    print('Added ticket: $ticketId');
  }

  print('All tickets added successfully!');
}