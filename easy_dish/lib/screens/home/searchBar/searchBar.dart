import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data_classes/recipe.dart';
import '../../../data_classes/recipe_data.dart';
import '../common/navigateToSearch.dart';

final TextEditingController _searchController = TextEditingController();

// Function to handle search when the Enter key is pressed in the search bar
void _handleSearch(BuildContext context, String query) {
  final List<Recipe> filteredRecipes = RecipeData.recipes
      .where(
          (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  navigateToSearchResults(context, query, filteredRecipes);

  // Clear the search box after search
  _searchController.clear();
}

Expanded searchBar(BuildContext context) {
  return
      Expanded(
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIconColor: Colors.deepOrange,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.deepOrange,
                  width: 2.0,
                )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.deepOrange,
                width: 2.0,
              ),
            ),
            hintText: 'Search...',
            hintStyle: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            prefixIcon: const Icon(Icons.search),
          ),
          onSubmitted: (query) => _handleSearch(context, query), // Call _handleSearch on Enter
        ),
      );
}