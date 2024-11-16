// lib/data_classes/user_data.dart
class UserData {

  String? email;
  String name;
  String aboutMe;
  String preferences;
  String favoriteIngredients;
  String experience;
  String password;

  // Private constructor to prevent direct instantiation
  UserData._privateConstructor({
    required this.email,
    required this.name,
    required this.aboutMe,
    required this.preferences,
    required this.favoriteIngredients,
    required this.experience,
    required this.password
  });


  // TODO warning: the user class will only be a singleton for now

  // Static instance for the singleton
  static UserData? _instance;

  // Public getter for the singleton instance
  static UserData get instance {
    _instance ??= UserData._privateConstructor(
      email: null,
      name: '',
      aboutMe: "Write about yourself...",
      preferences: "Write your preferences...",
      favoriteIngredients: "Tell us your favorite ingredients...",
      experience: "Insert your experience...", password: '',
    );
    return _instance!;
  }

  // Method to initialize UserData
  void initialize({
    required String email,
    required String name,
    String? aboutMe,
    String? preferences,
    String? favoriteIngredients,
    String? experience,
    required String password
  }) {
    _instance = UserData._privateConstructor(
        email: email,
        name: name,
        aboutMe: aboutMe ?? "Write about yourself...",
        preferences: preferences ?? "Write your preferences...",
        favoriteIngredients: favoriteIngredients ?? "Tell us your favorite ingredients...",
        experience: experience ?? "Insert your experience...",
        password: password
      );
  }

  // Method to reset the UserData
  void clear() {
    _instance = null;
  }

  bool isLoggedIn() {
    return email != null;
  }

  String getUserInfo() {
    return 'Email: $email, Name: $name';
  }
}
