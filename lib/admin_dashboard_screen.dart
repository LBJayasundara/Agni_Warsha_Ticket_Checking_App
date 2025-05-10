import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final ticketIdController = TextEditingController();
              final eventIdController = TextEditingController();

              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add Ticket'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: ticketIdController,
                          decoration: InputDecoration(labelText: 'Ticket ID'),
                        ),
                        TextField(
                          controller: eventIdController,
                          decoration: InputDecoration(labelText: 'Event ID'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final ticketId = ticketIdController.text.trim();
                          final eventId = eventIdController.text.trim();

                          if (ticketId.isNotEmpty && eventId.isNotEmpty) {
                            await _firestore.collection('tickets').doc(ticketId).set({
                              'isUsed': false,
                              'eventId': eventId,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ticket $ticketId added!')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields!')),
                            );
                          }
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Add Ticket'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('tickets').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final tickets = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return ListTile(
                      title: Text('Ticket ID: ${ticket.id}'),
                      subtitle: Text('Used: ${ticket['isUsed']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}