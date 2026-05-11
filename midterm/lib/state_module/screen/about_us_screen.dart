import 'package:flutter/material.dart';
import 'package:midterm/state_module/theme_logic.dart';
import 'package:provider/provider.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    Color primaryBrown = Color(0xFF6D4C41);
    Color lightBrown = Color(0xFFD7CCC8);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          // App Logo/Icon Area
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: lightBrown,
              shape: BoxShape.circle,
              border: Border.all(
                color: dark ? Colors.orangeAccent : primaryBrown,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.pets,
              size: 80,
              color: dark ? Colors.orangeAccent : primaryBrown,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "CatScout",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.orangeAccent : primaryBrown,
            ),
          ),
          Text(
            "Version 1.0.0",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 30),
          // App Description Section
          _buildInfoCard(
            dark ? Colors.orangeAccent : primaryBrown,
            "About the App",
            "CatScout is a comprehensive feline encyclopedia designed for cat lovers. Our mission is to provide high-quality information and beautiful imagery for over 100 cat breeds worldwide.",
          ),
          SizedBox(height: 15),
          // Key Features Section
          _buildInfoCard(
            dark ? Colors.orangeAccent : primaryBrown,
            "Key Features",
            "• High-resolution breed gallery\n"
                "• Detailed origin and temperament data\n"
                "• Real-time breed search\n"
                "• Personalized Light & Dark mode support",
          ),
          SizedBox(height: 40),
          Divider(color: Colors.grey),
          Text(
            "© 2026 CatScout Team",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Color color, String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
