import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard_screen.dart';
import 'barcode_scanner_screen.dart';
import 'check_in_out.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agni Warsha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image with reduced opacity
            Opacity(
              opacity: 0.3, // Adjust opacity (0.0 to 1.0)
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/back.jpg'), // Your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
      
            // Content
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      'images/logo.png',
                      height: 300,
                      width: 900,
                    ),
                    const SizedBox(height: 80),
      
                    // Attractive Scan Ticket Button
                    _buildCustomButton(
                      context,
                      'Scan Ticket',
                      Icons.qr_code_scanner,
                      Colors.blueAccent,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
                      ),
                    ),
      
                    const SizedBox(height: 25),
      
                    // Attractive Admin Access Button
                    _buildCustomButton(
                      context,
                      'Admin Access',
                      Icons.admin_panel_settings,
                      Colors.deepPurple,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                      ),
                    ),
      
                    const SizedBox(height: 25),
      
                    // Attractive Check Out Button
                    _buildCustomButton(
                      context,
                      'Check Out',
                      Icons.logout,
                      Colors.orange,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketScanScreen()),
                      ),
                    ),
      
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context,
      String text,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.9),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}