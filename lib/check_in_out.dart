import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TicketScanScreen extends StatefulWidget {
  const TicketScanScreen({super.key});

  @override
  State<TicketScanScreen> createState() => _TicketScanScreenState();
}

class _TicketScanScreenState extends State<TicketScanScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentTicketId;
  bool? _isCheckedIn;
  bool _isProcessing = false;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Scanner'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isProcessing) return;

              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _processScannedTicket(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // Status Display with Toggle Button
          if (_currentTicketId != null) Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ticket: $_currentTicketId',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isCheckedIn == true ? 'CURRENTLY CHECKED IN' : 'CURRENTLY CHECKED OUT',
                      style: TextStyle(
                        color: _isCheckedIn == true ? Colors.green : Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dynamic Toggle Button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _toggleStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCheckedIn == true ? Colors.orange : Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          _isCheckedIn == true ? 'CHECK OUT' : 'CHECK IN',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Camera controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () => cameraController.toggleTorch(),
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: () => cameraController.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processScannedTicket(String ticketId) async {
    setState(() {
      _isProcessing = true;
      _currentTicketId = ticketId;
    });

    try {
      final doc = await _firestore.collection('tickets').doc(ticketId).get();

      if (!doc.exists) {
        _showStatusMessage('Ticket not found', isError: true);
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      setState(() => _isCheckedIn = data['isCheckedIn'] == true);

    } catch (e) {
      _showStatusMessage('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _toggleStatus() async {
    if (_currentTicketId == null || _isCheckedIn == null) return;

    setState(() => _isProcessing = true);
    try {
      final newStatus = !_isCheckedIn!;

      await _firestore.collection('tickets').doc(_currentTicketId).update({
        'isCheckedIn': newStatus,
        'isCheckedOut': !newStatus,
        if (newStatus) 'lastCheckInTime': FieldValue.serverTimestamp(),
        if (!newStatus) 'lastCheckOutTime': FieldValue.serverTimestamp(),
      });

      setState(() => _isCheckedIn = newStatus);
      _showStatusMessage(
          newStatus ? 'Checked In Successfully' : 'Checked Out Successfully',
          isError: false
      );

    } catch (e) {
      _showStatusMessage('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showStatusMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}