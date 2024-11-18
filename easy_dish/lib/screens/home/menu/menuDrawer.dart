import 'package:flutter/material.dart';

import '../../../data_classes/user_data.dart';
import '../../aboutUs/about_us.dart';
import '../../guest/enter_app_options.dart';

Drawer menuDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFEFDCC3),
    child: Column(
      children: [
        if (UserData.instance.isLoggedIn) ...[
          const SizedBox(height: 60),
          // Menu items for logged-in users
          ListTile(
            leading: const Icon(
              Icons.bookmark_border,
              size: 30,
              color: Color(0xFF885B0E),
            ),
            title: const Text(
                'Bookmarks',
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
            leading: const Icon(
                Icons.add,
                size: 30,
                color: Color(0xFF885B0E)
            ),
            title: const Text(
                'Create Recipe',
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
            leading: const Icon(
                Icons.list_alt,
                size: 30,
                color: Color(0xFF885B0E)
            ),
            title: const Text(
                'My Recipes',
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
            title: const Text(
                'About Us',
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
            leading: const Icon(
                Icons.logout,
                size: 30,
                color: Color(0xFF885B0E)
            ),
            title: const Text(
                'Log Out',
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
        ] else
          ...[
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