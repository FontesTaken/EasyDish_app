// cart_page.dart
import 'package:flutter/material.dart';
import '../../data_classes/ingredients.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Map to keep track of selected ingredients and their quantities
  Map<String, int> shoppingList = {};

  // Function to show the dialog with available ingredients
  void _showAddIngredientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Ingredient'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: IngredientsData.instance.availableIngredients
                  .map((ingredient) {
                return ListTile(
                  title: Text('${ingredient.name} (${ingredient.unit})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add ingredient to the shopping list with quantity of 1 if not already added
                      setState(() {
                        if (!shoppingList.containsKey(ingredient.name)) {
                          shoppingList[ingredient.name] = 1;
                        }
                      });
                      Navigator.pop(context); // Close the dialog after adding
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Function to increment the quantity of an ingredient
  void _incrementQuantity(String ingredientName) {
    setState(() {
      shoppingList[ingredientName] = (shoppingList[ingredientName] ?? 0) + 1;
    });
  }

  // Function to decrement the quantity of an ingredient
  void _decrementQuantity(String ingredientName) {
    setState(() {
      if ((shoppingList[ingredientName] ?? 0) > 1) {
        shoppingList[ingredientName] = (shoppingList[ingredientName] ?? 0) - 1;
      } else {
        shoppingList
            .remove(ingredientName); // Remove from list if quantity is zero
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        automaticallyImplyLeading: false, // Remove the back arrow
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Display the shopping list items
            Expanded(
              child: shoppingList.isEmpty
                  ? const Center(
                      child: Text('No ingredients in the shopping list.'))
                  : ListView.builder(
                      itemCount: shoppingList.keys.length,
                      itemBuilder: (context, index) {
                        String ingredientName =
                            shoppingList.keys.elementAt(index);
                        int quantity = shoppingList[ingredientName]!;
                        Ingredient ingredient = IngredientsData
                            .instance.availableIngredients
                            .firstWhere((item) => item.name == ingredientName);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Ingredient name and unit
                              Text(
                                '$ingredientName (${ingredient.unit})',
                                style: const TextStyle(fontSize: 20),
                              ),

                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () =>
                                        _decrementQuantity(ingredientName),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        _incrementQuantity(ingredientName),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating Action Button to add ingredients
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIngredientDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
