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
      id: RecipeData.recipes.length + 1,
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
    return Container(
        color: Colors.white, // Base color to prevent blending issues
        child: Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          appBar: AppBar(
            backgroundColor: Colors.orange.withOpacity(0.01),
            title: Text(
                "Step ${steps.length + 1}",
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )
            ), // Display current step number
            leading: IconButton(
              icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFC08019)
              ),
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
                const Text(
                    "Title:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF754F0D),
                      fontWeight: FontWeight.bold,
                    )),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color(0xFF9B7530),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    hintText: "Enter step title (optional)",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC08019),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFD095),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.orange, // Color when TextField is focused
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0BC91), // Border color when enabled
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFDAB0),
                  ),
                ),
                const SizedBox(height: 16),

                // Description input
                const Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF754F0D),
                      fontWeight: FontWeight.bold,
                    )),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Enter step description",
                    labelStyle: const TextStyle(
                      color: Color(0xFF9B7530),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    hintStyle: const TextStyle(
                      color: Color(0xFFC08019),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFD095),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.orange, // Color when TextField is focused
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFE0BC91), // Border color when enabled
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFDAB0),
                  ),
                ),
                const SizedBox(height: 16),

                // Timer input
                const Text(
                    "Timer:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF754F0D),
                      fontWeight: FontWeight.bold,
                    )),
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
                      icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xFF79551D)
                      ),
                    ),
                    Text(
                      "${(timer ~/ 60).toString().padLeft(2, '0')}:${(timer % 60).toString().padLeft(2, '0')}", // Display as MM:SS
                      style: const TextStyle(fontSize: 18, color: Color(0xFF79551D)),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          timer += 30; // Increase by 1 minute (60 seconds)
                        });
                      },
                      icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF79551D)
                      ),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD095),
                          elevation: 4
                      ),
                      child: const Text(
                          "Add Step",
                          style: TextStyle(
                            color: Color(0xFF885B0E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _finishRecipe,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD095),
                          elevation: 4
                      ),
                      child: const Text(
                          "Finish",
                          style: TextStyle(
                            color: Color(0xFF885B0E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )
                      ),
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
        )
    );
  }
}
