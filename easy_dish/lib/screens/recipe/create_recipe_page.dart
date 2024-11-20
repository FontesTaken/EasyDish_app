import 'package:flutter/material.dart';
import 'add_steps_page.dart';
import "/../data_classes/recipe.dart";

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> tags = [];
  final List<Ingredient> ingredients = [];
  int servings = 2;
  String? recipeImage; // Placeholder for recipe image

  // Function to add a tag
  void _addTag() async {
    final tagController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Tag"),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(hintText: "Enter tag"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (tagController.text.isNotEmpty) {
                  setState(() {
                    tags.add(tagController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _addIngredient() async {
    final ingredientNameController = TextEditingController();
    final quantityController = TextEditingController();
    String? selectedUnit;

    const units = ['grams', 'tbsp', 'cups', 'ml', 'pieces'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Ingredient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ingredientNameController,
                decoration: const InputDecoration(hintText: "Ingredient name"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(hintText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedUnit = value;
                },
                decoration: const InputDecoration(
                  hintText: "Select unit",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (ingredientNameController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    selectedUnit != null) {
                  setState(() {
                    ingredients.add(
                      Ingredient(
                        name: ingredientNameController.text,
                        baseQuantity:
                            double.tryParse(quantityController.text) ?? 0.0,
                        unit: selectedUnit!,
                      ),
                    );
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill out all fields")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Function to pick an image (dummy for now)
  void _pickImage() {
    // Placeholder for picking an image
    setState(() {
      recipeImage = "https://via.placeholder.com/150"; // Temporary placeholder
    });
  }

  // Navigate to the next page
  void _goToNextPage() {
    if (recipeNameController.text.isEmpty || ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please complete all fields before proceeding")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStepsPage(
          recipeImage: recipeImage,
          recipeName: recipeNameController.text,
          description: descriptionController.text,
          tags: tags,
          servings: servings,
          ingredients: ingredients, // Pass as a List<Ingredient>
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Recipe"),
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
            GestureDetector(
              onTap: _pickImage,
              child: recipeImage == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.camera_alt, size: 50),
                    )
                  : Image.network(recipeImage!,
                      height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: recipeNameController,
              decoration: const InputDecoration(
                labelText: "Recipe Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tags:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: _addTag, child: const Text("Add")),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Servings:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    if (servings > 1) {
                      setState(() {
                        servings--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(servings.toString()),
                IconButton(
                  onPressed: () {
                    setState(() {
                      servings++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ingredients:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: _addIngredient, child: const Text("Add")),
              ],
            ),
            ...ingredients.map((ingredient) {
              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text("${ingredient.baseQuantity} ${ingredient.unit}"),
              );
            }),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _goToNextPage,
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
