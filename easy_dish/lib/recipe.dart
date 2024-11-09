// recipe.dart

class Recipe {
  final String name;
  final List<String> tags; // List of tags (e.g., difficulty, cuisine type, etc.)
  final String imageUrl;

  Recipe({
    required this.name,
    required this.tags,
    required this.imageUrl,
  });
}
