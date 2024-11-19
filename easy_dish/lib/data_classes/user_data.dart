// lib/data_classes/user_data.dart
class UserData {

  String? email;
  String name;
  String aboutMe;
  String preferences;
  String favoriteIngredients;
  String experience;
  String password;
  bool isLoggedIn;

  String? profileImage;
  String? backgroundImage;

  // TODO recipe list, bookmark list, shopping list ?

  // Private constructor to prevent direct instantiation
  UserData._privateConstructor({
    required this.email,
    required this.name,
    required this.aboutMe,
    required this.preferences,
    required this.favoriteIngredients,
    required this.experience,
    required this.password,
    required this.isLoggedIn,
    required this.backgroundImage,
    required this.profileImage,
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
      experience: "Undisclosed", password: '',
      isLoggedIn: false,
      profileImage: null,
      backgroundImage: null,
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
    required String password,
    String? profileImage,
    String? backgroundImage,

  }) {
    _instance = UserData._privateConstructor(
        email: email,
        name: name,
        aboutMe: aboutMe ?? "Write about yourself...",
        preferences: preferences ?? "Write your preferences...",
        favoriteIngredients: favoriteIngredients ?? "Tell us your favorite ingredients...",
        experience: experience ?? "Undisclosed",
        password: password, isLoggedIn: true,
        profileImage: profileImage ?? null,
        backgroundImage: backgroundImage ?? null,

      );
  }

  // Method to reset the UserData
  void clear() {
    _instance = null;
  }

  String getUserInfo() {
    return 'Email: $email, Name: $name';
  }
}
