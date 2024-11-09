// ingredients.dart

class Ingredient {
  final String name;
  final String unit; // "count", "kg", "ml", etc.

  Ingredient(this.name, this.unit);
}

// Singleton class to manage ingredients
class IngredientsData {
  static final IngredientsData _instance = IngredientsData._internal();
  IngredientsData._internal();

  static IngredientsData get instance => _instance;

  // List of available ingredients
  final List<Ingredient> availableIngredients = [
    Ingredient('Eggs', 'count'),
    Ingredient('Milk', 'ml'),
    Ingredient('Chicken', 'kg'),
    Ingredient('Rice', 'kg'),
    Ingredient('Banana', 'count'),
    // Add more ingredients as needed
  ];
}
