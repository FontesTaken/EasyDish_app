import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter_app_test/data_classes/user_data.dart';
import 'package:flutter_app_test/screens/profile/profile_page.dart';

import '../home/home_screen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Local variables to hold form values
  String userName = UserData.instance.name ?? '';
  String userEmail = UserData.instance.email ?? '';
  String description = UserData.instance.aboutMe ?? '';
  String experienceLevel = UserData.instance.experience ?? '';
  File? backgroundImage;
  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  // List of experience level options
  final List<String> experienceOptions = [
    'Undisclosed', 'Low', 'Medium', 'High', 'Experienced'
  ];

  // Function to select an image from gallery or camera
  Future<void> _pickImage(ImageSource source, bool isBackground) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isBackground) {
          backgroundImage = File(pickedFile.path);
        } else {
          profileImage = File(pickedFile.path);
        }
      });
    }
  }

  // Save changes to the singleton
  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        UserData.instance.name = userName;
        UserData.instance.email = userEmail;
        UserData.instance.aboutMe = description;
        UserData.instance.experience = experienceLevel;

        // Save the images in the UserData class if needed
        if (backgroundImage != null) {
          UserData.instance.backgroundImage = backgroundImage!.path;
        }
        if (profileImage != null) {
          UserData.instance.profileImage = profileImage!.path;
        }
      });

      // Navigate to ProfileScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Color(0xA8820A00),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.orangeAccent.withOpacity(0.9),
            iconTheme: const IconThemeData(color: Color(0xA8820A00)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Background Image Section
                  const Text(
                    'Background Image',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery, true),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.19),
                        borderRadius: BorderRadius.circular(12),
                        image: backgroundImage != null
                            ? DecorationImage(
                          image: FileImage(backgroundImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: backgroundImage == null
                          ? const Center(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.orangeAccent,
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile Picture Section
                  const Text(
                    'Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery, false),
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.19),
                        borderRadius: BorderRadius.circular(12),
                        image: profileImage != null
                            ? DecorationImage(
                          image: FileImage(profileImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: profileImage == null
                          ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.orangeAccent,
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Section
                  _buildInputSection(
                    label: 'Name',
                    initialValue: userName,
                    onSaved: (value) => userName = value!,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Section
                  _buildInputSection(
                    label: 'Email',
                    initialValue: userEmail,
                    onSaved: (value) => userEmail = value!,
                    validator: (value) =>
                    value == null || !value.contains('@') ? 'Invalid email' : null,
                  ),
                  const SizedBox(height: 16),

                  // Description Section
                  _buildInputSection(
                    label: 'Description',
                    initialValue: description,
                    onSaved: (value) => description = value!,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Experience Level Section (Dropdown)
                  const Text(
                    'Experience Level',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: experienceLevel.isEmpty ? experienceOptions[0] : experienceLevel,
                    onChanged: (newValue) {
                      setState(() {
                        experienceLevel = newValue!;
                      });
                    },
                    onSaved: (newValue) => experienceLevel = newValue!,
                    items: experienceOptions
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                        .toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Changes Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title displayed above the input field
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Input field without repeating the label
          TextFormField(
            initialValue: initialValue,
            decoration: const InputDecoration(
              border: InputBorder.none, // Removes extra border inside the box
            ),
            validator: validator,
            onSaved: onSaved,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
