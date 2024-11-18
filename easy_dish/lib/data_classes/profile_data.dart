// profile_data.dart

class ProfileData {
  // Singleton instance
  static final ProfileData _instance = ProfileData._internal();

  // Private constructor
  ProfileData._internal();

  // Singleton accessor
  static ProfileData get instance => _instance;

  // Data fields
  String name = 'João';
  String aboutMe = 'Write about yourself...';
  String preferences = 'Your preferences...';
  String favoriteIngredients = 'List your favorite ingredients...';
  String experience = 'Describe your experience...';

  // Method to update profile data
  void update({
    required String name,
    required String aboutMe,
    required String preferences,
    required String favoriteIngredients,
    required String experience,
  }) {
    this.name = name;
    this.aboutMe = aboutMe;
    this.preferences = preferences;
    this.favoriteIngredients = favoriteIngredients;
    this.experience = experience;
  }
}
