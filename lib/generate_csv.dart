import 'dart:io';

void main() {
  // Create a new CSV file
  final file = File('tickets.csv');

  // Write the header row
  file.writeAsStringSync('ticketId,isUsed,eventId\n');

  // Generate 600 tickets
  for (var i = 1; i <= 600; i++) {
    final ticketId = 'ticket$i';
    final isUsed = 'false';
    final eventId = 'concert123';

    // Write the ticket data to the CSV file
    file.writeAsStringSync('$ticketId,$isUsed,$eventId\n', mode: FileMode.append);
  }

  print('CSV file created successfully: tickets.csv');
}