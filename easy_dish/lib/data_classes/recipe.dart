// recipe.dart

import 'comment.dart';


class Recipe {
  final int id;
  final String name;
  final List<String> tags;
  final String imageUrl;
  final String description;
  int servings;
  final int defaultServings;
  final List<RecipeStep> steps;
  final List<Ingredient> ingredients;
  final List<Comment> comments; // Add this field to hold comments
  final String createdBy;

  Recipe({
    required this.id,
    required this.name,
    required this.tags,
    required this.imageUrl,
    required this.description,
    required this.servings,
    required this.defaultServings,
    required this.steps,
    required this.ingredients,
    this.comments = const [], // Default to an empty list if no comments
    required this.createdBy, // Make this required

  });
}

class Ingredient {
  final String name;
  final double baseQuantity; // The base quantity for the default servings
  final String unit;

  Ingredient({
    required this.name,
    required this.baseQuantity,
    required this.unit,
  });

  // Method to calculate quantity based on servings
  double getAdjustedQuantity(int currentServings, int defaultServings) {
    return baseQuantity * (currentServings / defaultServings);
  }
}

class RecipeStep {
  final String description;
  final int? timer; // Timer in minutes, if applicable

  RecipeStep({
    required this.description,
    this.timer,
  });
}
