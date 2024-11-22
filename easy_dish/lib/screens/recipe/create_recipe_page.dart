import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'add_steps_page.dart';
import '../../data_classes/recipe.dart';

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
  File? recipeImage; // Store the picked image file
  final ImagePicker _picker = ImagePicker(); // Initialize the ImagePicker

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        recipeImage = File(pickedFile.path);
      });
    }
  }

  // Function to add a tag
  void _addTag() async {
    final tagController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF4E3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          title: const Text(
              "Add Tag",
              style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF885B0E),
          )),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD095),
                  elevation: 4
              ),
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
          backgroundColor: const Color(0xFFFFF4E3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          title: const Text(
            "Add Ingredient",
            style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF885B0E),
          )),
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
                dropdownColor: const Color(0xFFFFF4E3),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD095),
                  elevation: 4
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
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
          recipeImage: recipeImage?.path, // Pass the image file path
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
     return Container(
         color: Colors.white, // Base color to prevent blending issues
         child: Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          appBar: AppBar(
            title: const Text(
                "Create a Recipe",
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )
            ),
            leading: IconButton(
              icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFC08019)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.orange.withOpacity(0.01),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.19),
                      borderRadius: BorderRadius.circular(12),
                      image: recipeImage != null
                          ? DecorationImage(
                              image: FileImage(recipeImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: recipeImage == null
                        ? const Center(
                            child: Icon(Icons.camera_alt, size: 50, color: Colors.orangeAccent),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: recipeNameController,
                  decoration: InputDecoration(
                    labelText: "Recipe Name",
                    labelStyle: const TextStyle(
                      color: Color(0xFF9B7530),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                      borderSide: BorderSide(
                        color: Colors.orange, // Color when TextField is focused
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFE0BC91), // Border color when enabled
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFFFDAB0),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: const TextStyle(
                      color: Color(0xFF9B7530),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                Row(
                  children: [
                    const Text(
                      "Tags:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF754F0D),
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                        onPressed: _addTag,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFD095),
                            elevation: 4
                        ),
                        child: const Text(
                            "Add",
                            style: TextStyle(
                              color: Color(0xFF885B0E),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8.0,
                  children: tags.map((tag) => Chip(label: Text(tag))).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Servings:", style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF754F0D),
                      fontWeight: FontWeight.bold,
                    )),
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
                  children: [
                    const Text("Ingredients:", style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF754F0D),
                      fontWeight: FontWeight.bold,
                    )),
                    const SizedBox(width: 16),
                    if (ingredients.isNotEmpty) ...[
                      ElevatedButton(
                          onPressed: _addIngredient,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFD095),
                              elevation: 4
                          ),
                          child: const Text(
                              "Add",
                              style: TextStyle(
                                color: Color(0xFF885B0E),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ))
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                ingredients.isEmpty
                    ?
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "No ingredients added",
                        style: TextStyle(
                          color: Color(0xFF885B0E),
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _addIngredient,
                        child: const Text(
                          "Add them here!",
                          style: TextStyle(
                            color: Color(0xFF885B0E),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Column(
                  children: ingredients.map((ingredient) {
                    return ListTile(
                      title: Text(
                        ingredient.name,
                        style: TextStyle(
                          color: Color(0xFF885B0E),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      subtitle:
                      Text(
                        "${ingredient.baseQuantity} ${ingredient.unit}",
                        style: TextStyle(
                          color: Color(0xFF885B0E),
                          fontSize: 16
                        )
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD095),
                        elevation: 4
                    ),
                    child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Color(0xFF885B0E),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
     );
  }
}