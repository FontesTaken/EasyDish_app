// profile_page.dart
import 'package:flutter/material.dart';
import 'profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers to handle text editing
  late TextEditingController nameController;
  late TextEditingController aboutMeController;
  late TextEditingController preferencesController;
  late TextEditingController favoriteIngredientsController;
  late TextEditingController experienceController;

  bool isEditing = false; // Toggle between view and edit mode

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the data from ProfileData singleton
    nameController = TextEditingController(text: ProfileData.instance.name);
    aboutMeController =
        TextEditingController(text: ProfileData.instance.aboutMe);
    preferencesController =
        TextEditingController(text: ProfileData.instance.preferences);
    favoriteIngredientsController =
        TextEditingController(text: ProfileData.instance.favoriteIngredients);
    experienceController =
        TextEditingController(text: ProfileData.instance.experience);
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    aboutMeController.dispose();
    preferencesController.dispose();
    favoriteIngredientsController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      if (isEditing) {
        // Save changes to ProfileData when exiting edit mode
        ProfileData.instance.update(
          name: nameController.text,
          aboutMe: aboutMeController.text,
          preferences: preferencesController.text,
          favoriteIngredients: favoriteIngredientsController.text,
          experience: experienceController.text,
        );
      }
      // Toggle the editing state
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allows layout to adjust when keyboard opens
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: toggleEditMode,
          ),
        ],
      ),

      body: SingleChildScrollView(
        // Enables scrolling when content overflows
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture and name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isEditing
                      ? TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          ProfileData
                              .instance.name, // Load name from ProfileData
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // "About Me" section
            const Text(
              'About Me:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: aboutMeController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write about yourself...',
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      ProfileData
                          .instance.aboutMe, // Load aboutMe from ProfileData
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
            const SizedBox(height: 16),

            // "Preferences" section
            const Text(
              'Preferences:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: preferencesController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Your preferences...',
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      ProfileData.instance
                          .preferences, // Load preferences from ProfileData
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
            const SizedBox(height: 16),

            // "Favorite Ingredients" section
            const Text(
              'Favorite Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: favoriteIngredientsController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'List your favorite ingredients...',
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      ProfileData.instance
                          .favoriteIngredients, // Load favoriteIngredients from ProfileData
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
            const SizedBox(height: 16),

            // "Experience" section
            const Text(
              'Experience:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: experienceController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe your experience...',
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      ProfileData.instance
                          .experience, // Load experience from ProfileData
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
