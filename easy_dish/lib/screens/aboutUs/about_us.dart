import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Standard AppBar height
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Colors.orange.withOpacity(0.2),
              elevation: 0, // Remove the shadow for a cleaner look
              title: const Text(
                'About Us',
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Color(0xFFC08019), // Set the back arrow color to bright red
                onPressed: () {
                  Navigator.pop(context); // Navigate back when pressed
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Orange background with opacity
          Container(
            color: Colors.orange.withOpacity(0.19),
          ),
          // Main content with white background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image at the top, replaced with a regular square image
                  Center(
                    child: Image.asset(
                      'assets/logo_transp.png', // Displaying the image as a regular square
                      width: 100, // Set width and height for the square image
                      height: 100,
                      fit: BoxFit.cover, // Make sure the image fits nicely
                    ),
                  ),
                  SizedBox(height: 16),

                  // Title
                  Center(
                    child: Text(
                      'The EasyDish Team',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF885B0E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description
                  Text(
                    'We are dedicated to providing the best recipes and cooking experiences for our users. '
                        'Our app makes it easy to find, create, and share amazing dishes with loved ones. Whether you are a beginner '
                        'or an experienced chef, we have something for everyone!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF885B0E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Contact Information
                  Text(
                    'Contact Us:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF885B0E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: info@yourapp.com',
                    style: TextStyle(fontSize: 16, color: Color(0xFF885B0E)),
                  ),
                  Text(
                    'Phone: +123 456 7890',
                    style: TextStyle(fontSize: 16, color: Color(0xFF885B0E)),
                  ),
                  SizedBox(height: 16),

                  // Social Media Links
                  Text(
                    'Follow Us:',
                    style: TextStyle(fontSize: 18, color: Color(0xFF885B0E), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
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
          ),
        ],
      ),
    );
  }
}
