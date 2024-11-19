import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_test/data_classes/user_data.dart';
import 'package:flutter_app_test/screens/profile/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  final List<String> recipes = [
    "Spaghetti Bolognese",
    "Chicken Alfredo",
    "Vegan Tacos",
    "Chocolate Cake",
    "Grilled Cheese Sandwich",
    "Caesar Salad",
  ];

  String userName = '';
  String userEmail = '';
  String description = '';
  String experienceLevel = '';

  @override
  void initState() {
    super.initState();

    // Load user data from the UserData singleton when the page is loaded
    _loadUserData();
  }

  // Function to load user data from the singleton
  void _loadUserData() {
    setState(() {
      userName = UserData.instance.name ?? 'No Name';
      userEmail = UserData.instance.email ?? 'No Email';
      description = UserData.instance.aboutMe ?? 'No Description';
      experienceLevel = UserData.instance.experience ?? 'No Experience Level';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange.withOpacity(0.19),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image with Edit Button
                  Stack(
                    children: [
                      // Header Image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: UserData.instance.backgroundImage != null
                              ? Image.file(
                            File(UserData.instance.backgroundImage!),
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            "assets/meal_default_img.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Edit Button
                      Positioned(
                        top: 16, // Position from the top
                        right: 16, // Position from the right
                        child: CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          radius: 24,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const EditProfilePage()),
                              );
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),

                  // Profile Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          image: UserData.instance.profileImage != null
                              ? DecorationImage(
                            image: FileImage(File(UserData.instance.profileImage!)),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: UserData.instance.profileImage == null
                            ? const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      // Name, Email, and Experience
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Email
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54, // Slightly grayish color
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Experience Level
                          Text(
                            "Experience: $experienceLevel",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0x7C600700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description Section
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recipes Section
                  const Divider(
                    color: Colors.deepOrange,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Recipes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xA8820A00),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Recipes List (You can keep this static as you mentioned)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recipes[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
