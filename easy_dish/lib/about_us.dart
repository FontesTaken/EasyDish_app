// about_us.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/100'), // Replace with your logo URL
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Center(
              child: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'We are dedicated to providing the best recipes and cooking experiences for our users. '
              'Our app makes it easy to find, create, and share amazing dishes with loved ones. Whether you are a beginner '
              'or an experienced chef, we have something for everyone!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Contact Information
            const Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: info@yourapp.com',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Phone: +123 456 7890',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Social Media Links
            const Text(
              'Follow Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                SizedBox(width: 16),
                Icon(FontAwesomeIcons.twitter, color: Colors.lightBlue),
                SizedBox(width: 16),
                Icon(FontAwesomeIcons.instagram, color: Colors.pink),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
