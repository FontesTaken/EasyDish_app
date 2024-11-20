import 'package:flutter/material.dart';
import '../../data_classes/recipe.dart'; // Import your recipe model
import '../../data_classes/recipe_data.dart'; // Import the recipe_data to save the recipe
import 'package:flutter_app_test/data_classes/user_data.dart';
import '../home/home_page.dart'; // Import the screen showing all recipes
import '../../data_classes/user_data.dart';
import '../home/home_screen.dart';

class AddStepsPage extends StatefulWidget {
  final String recipeName;
  final String description;
  final String? recipeImage;
  final List<String> tags;
  final int servings;
  final List<Ingredient> ingredients;

  const AddStepsPage({
    super.key,
    required this.recipeName,
    required this.description,
    this.recipeImage,
    required this.tags,
    required this.servings,
    required this.ingredients,
  });

  @override
  State<AddStepsPage> createState() => _AddStepsPageState();
}

class _AddStepsPageState extends State<AddStepsPage> {
  final List<RecipeStep> steps = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int timer = 0;

  // Add a step to the list
  void _addStep() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter a description for the step")),
      );
      return;
    }

    setState(() {
      steps.add(
        RecipeStep(
          description: descriptionController.text,
          timer: timer > 0 ? timer : null,
        ),
      );

      // Clear fields for the next step
      titleController.clear();
      descriptionController.clear();
      timer = 0;
    });
  }

  // Finish and save the recipe
  void _finishRecipe() {
    if (steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please add at least one step to the recipe")),
      );
      return;
    }

    final newRecipe = Recipe(
      createdBy:
          UserData.instance.isLoggedIn ? UserData.instance.name : "Anonymous",
      name: widget.recipeName,
      description: widget.description,
      tags: widget.tags,
      servings: widget.servings,
      defaultServings: widget.servings,
      ingredients: widget.ingredients,
      steps: steps,
      imageUrl: widget.recipeImage ??
          'https://via.placeholder.com/150', // Placeholder if no image
      comments: [],
    );

    setState(() {
      RecipeData.recipes
          .add(newRecipe); // Add the new recipe to recipe_data.dart
    });

    if (UserData.instance.isLoggedIn) {
      UserData.instance.createdRecipes.add(widget.recipeName);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recipe added successfully!")),
    );

    // Navigate to the page showing all recipes (e.g., HomeScreen)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(), // Navigate to the HomeScreen
      ),
      (route) => false, // Remove all previous routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step ${steps.length + 1}"), // Display current step number
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title input
            const Text("Title:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter step title (optional)",
              ),
            ),
            const SizedBox(height: 16),

            // Description input
            const Text("Description:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter step description",
              ),
            ),
            const SizedBox(height: 16),

            // Timer input
            const Text("Timer:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (timer > 0) {
                      setState(() {
                        timer -= 30; // Decrease by 1 minute (60 seconds)
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  "${(timer ~/ 60).toString().padLeft(2, '0')}:${(timer % 60).toString().padLeft(2, '0')}", // Display as MM:SS
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      timer += 30; // Increase by 1 minute (60 seconds)
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Add step and Finish buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addStep,
                  child: const Text("Add Step"),
                ),
                ElevatedButton(
                  onPressed: _finishRecipe,
                  child: const Text("Finish"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Display added steps
            if (steps.isNotEmpty) ...[
              const Text("Steps Added:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                return ListTile(
                  title: Text("Step ${index + 1}: ${step.description}"),
                  subtitle: step.timer != null
                      ? Text(
                          "Timer: ${(step.timer! ~/ 60).toString().padLeft(2, '0')}:${(step.timer! % 60).toString().padLeft(2, '0')}")
                      : null,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
