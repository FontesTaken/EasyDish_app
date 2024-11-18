import 'package:flutter/material.dart';
import 'package:flutter_app_test/screens/guest/enter_app_options.dart';
import 'package:flutter_app_test/screens/bookmark/bookmark_page.dart';

import '../cart/cart_page.dart';
import '../../data_classes/user_data.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Default to Home tab

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = UserData.instance.isLoggedIn;

    // Define the pages and their corresponding BottomNavigationBarItems
    final List<Widget> pages = [
      const BookmarkPage(), // Bookmark Page
      const HomePage(), // Home Page
      const CartPage(), // Cart Page (Shopping List)
      if (isLoggedIn)
        const ProfilePage() // Profile Page (only if logged in)
      else
        const SizedBox(), // Placeholder page when "Login" is clicked
    ];

    final List<BottomNavigationBarItem> navBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
        label: 'Bookmark',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      if (isLoggedIn)
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        )
      else
        const BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Login',
        ),
    ];

    // Ensure the current index is valid in case the Profile/Login tab changes dynamically
    if (_currentIndex >= pages.length) {
      _currentIndex = pages.length - 1;
    }

    return Scaffold(
      body: pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (!isLoggedIn && index == pages.length - 1) {
            // If the "Login" tab is clicked
            _showLoginPopup(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: navBarItems,
        selectedItemColor:  const Color(0xFF885B0E), // Active icon color
        unselectedItemColor: Colors.white, // Inactive icon color
        backgroundColor:  const Color(0xFFEAAD4F), // Background color
        type: BottomNavigationBarType.fixed, // Keeps all icons visible
        selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login"),
          content: const Text("Would you like to log in?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepOrange, // Text color for the button
              ),
              child: const Text("NO"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToWelcomeScreen(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text("YES"),
            ),
          ],
        );
      },
    );
  }


  // Navigate to the WelcomeScreen without the BottomNavigationBar
  void _navigateToWelcomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
}
