import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:flutter_app_test/data_classes/user_data.dart';

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

      Navigator.pop(context, true); // Pass true to indicate changes were saved
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.withOpacity(0.19),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xA8820A00)),
        ),
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Color(0xA8820A00)), // Set arrow color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Background Image',
                style: TextStyle(fontSize: 18, color: Colors.deepOrange),
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

              const Text(
                'Profile Picture',
                style: TextStyle(fontSize: 18, color: Colors.deepOrange),
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

              TextFormField(
                initialValue: userName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Name cannot be empty' : null,
                onSaved: (value) => userName = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: userEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Invalid email'
                    : null,
                onSaved: (value) => userEmail = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
                maxLines: 3,
                onSaved: (value) => description = value!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: experienceLevel,
                decoration: const InputDecoration(
                  labelText: 'Experience Level',
                  labelStyle: TextStyle(color: Colors.deepOrange),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
                onSaved: (value) => experienceLevel = value!,
              ),
              const SizedBox(height: 24),

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
    );
  }
}
