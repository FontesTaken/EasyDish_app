import 'package:flutter/material.dart';
import '../../data_classes/ingredients.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, int> shoppingList = {};

  void _showAddIngredientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF4E3), // Soft background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          title: const Text(
            'Add Ingredient',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF885B0E),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: IngredientsData.instance.availableIngredients
                  .map((ingredient) {
                return Card(
                  color: const Color(0xFFFFD095),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: const Color(0xFFE3B77B), // Placeholder color
                        child: Center(
                          child: Text(
                            ingredient.unit,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF885B0E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      ingredient.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF885B0E),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      color: const Color(0xFF885B0E),
                      onPressed: () {
                        setState(() {
                          if (!shoppingList.containsKey(ingredient.name)) {
                            shoppingList[ingredient.name] = 1;
                          }
                        });
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _incrementQuantity(String ingredientName) {
    setState(() {
      shoppingList[ingredientName] = (shoppingList[ingredientName] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String ingredientName) {
    setState(() {
      if ((shoppingList[ingredientName] ?? 0) > 1) {
        shoppingList[ingredientName] = (shoppingList[ingredientName] ?? 0) - 1;
      } else {
        shoppingList.remove(ingredientName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.withOpacity(0.19),
      appBar: AppBar(
        backgroundColor: Colors.orange.withOpacity(0.01),
        title: const Text(
          'Shopping List',
          style: TextStyle(
            color: Color(0xFFC08019),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: shoppingList.isEmpty
                  ? const Center(
                child: Text(
                  'No ingredients in the shopping list.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF885B0E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: shoppingList.keys.length,
                itemBuilder: (context, index) {
                  String ingredientName =
                  shoppingList.keys.elementAt(index);
                  int quantity = shoppingList[ingredientName]!;
                  Ingredient ingredient = IngredientsData
                      .instance.availableIngredients
                      .firstWhere((item) => item.name == ingredientName);

                  return Card(
                    color: const Color(0xFFFFD095),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFE3B77B),
                          child: Center(
                            child: Text(
                              ingredient.unit,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF885B0E),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        ingredientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF885B0E),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            color: const Color(0xFF885B0E),
                            onPressed: () =>
                                _decrementQuantity(ingredientName),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF885B0E),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: const Color(0xFF885B0E),
                            onPressed: () =>
                                _incrementQuantity(ingredientName),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC08019),
        onPressed: _showAddIngredientDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
