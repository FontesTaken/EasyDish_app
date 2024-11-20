import 'package:flutter/material.dart';

import '../../../data_classes/user_data.dart';
import '../../aboutUs/about_us.dart';
import '../../guest/enter_app_options.dart';
import '../../recipe/create_recipe_page.dart';

Drawer menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFEFDCC3),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menu title at the top left
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 40, 16, 20),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Color(0xFF885B0E),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        const Divider(color: Color(0xFF885B0E)), // Optional divider below title
        if (UserData.instance.isLoggedIn) ...[
          const SizedBox(height: 20),
          // Menu items for logged-in users
          ListTile(
            leading: const Icon(
              Icons.bookmark_border,
              size: 30,
              color: Color(0xFF885B0E),
            ),
            title: const Text('Bookmarks',
                style: TextStyle(
                  color: Color(0xFFC28119),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, size: 30, color: Color(0xFF885B0E)),
            title: const Text('Create Recipe',
                style: TextStyle(
                  color: Color(0xFFC28119),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateRecipePage(),
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.list_alt, size: 30, color: Color(0xFF885B0E)),
            title: const Text('My Recipes',
                style: TextStyle(
                  color: Color(0xFFC28119),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Divider(color: Color(0xFF885B0E)),
          ListTile(
            title: const Text('About Us',
                style: TextStyle(
                  color: Color(0xFFC28119),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.logout, size: 30, color: Color(0xFF885B0E)),
            title: const Text('Log Out',
                style: TextStyle(
                  color: Color(0xFFC28119),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            onTap: () {
              Navigator.pop(context);
              UserData.instance.isLoggedIn = false;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ] else ...[
          // Menu for users who are not logged in
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Information'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
        ],
      ],
    ),
  );
}
