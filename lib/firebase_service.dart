import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if ticket is valid
  Future<bool> validateTicket(String ticketId) async {
    final doc = await _firestore.collection('tickets').doc(ticketId).get();
    if (doc.exists && doc['isUsed'] == false) {
      await _firestore.collection('tickets').doc(ticketId).update({'isUsed': true});
      return true; // Ticket is valid
    }
    return false; // Ticket is invalid or used
  }

  // Add a new ticket (for admin)
  Future<void> addTicket(String ticketId, String eventId) async {
    await _firestore.collection('tickets').doc(ticketId).set({
      'isUsed': false,
      'eventId': eventId,
    });
  }

  // Get all tickets (for admin)
  Future<QuerySnapshot> getAllTickets() async {
    return await _firestore.collection('tickets').get();
  }
}