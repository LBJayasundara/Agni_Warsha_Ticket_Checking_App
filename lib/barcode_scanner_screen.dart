import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ticket'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                if (!isScanning) return; // Skip if scanning is paused
                setState(() {
                  isScanning = false; // Disable scanning temporarily
                });

                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? ticketId = barcode.rawValue?.trim();
                  if (ticketId != null) {
                    validateTicket(ticketId);
                    break;
                  }
                }

                // Re-enable scanning after a delay
                Future.delayed(Duration(seconds: 4), () {
                  setState(() {
                    isScanning = true; // Re-enable scanning
                  });
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Scan a ticket barcode',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void validateTicket(String ticketId) async {
    final doc = await FirebaseFirestore.instance.collection('tickets').doc(ticketId).get();

    String message;
    if (doc.exists) {
      if (doc['isUsed'] == true) {
        if (doc['isCheckedOut'] == true) {
          // Ticket has been checked out and can be reused
          await FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
            'isUsed': false,
            'isCheckedOut': false,
          });
          message = 'Ticket $ticketId is valid for re-entry!';
        } else {
          // Ticket is already used and not checked out
          message = 'Ticket $ticketId is already used. Please check out before reusing.';
        }
      } else {
        // Mark ticket as used (first entry)
        await FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
          'isUsed': true,
          'isCheckedOut': false,
        });
        message = 'Ticket $ticketId is valid!';
      }
    } else {
      // Ticket not found in the system
      message = 'Ticket $ticketId is not in the system.';
    }

    // Show a pop-up dialog with the result
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          //content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}