// Show filter dialog with all tags sorted by frequency
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data_classes/recipe.dart';
import '../../../../data_classes/recipe_data.dart';
import '../common/navigateToSearch.dart';

final Set<String> _selectedTags = {}; // Stores selected tags for filtering

// Function to handle filter confirmation
void _applyFilters(BuildContext context) {
  final List<Recipe> filteredRecipes = _selectedTags.isEmpty
      ? RecipeData.recipes
      : RecipeData.recipes
      .where((recipe) =>
      _selectedTags.every((tag) => recipe.tags.contains(tag)))
      .toList();

  navigateToSearchResults(context, "Filtered", filteredRecipes);

  // Clear selected tags after search
  _selectedTags.clear();
}

void _clearFilters(StateSetter setState) {
  setState(() {
    _selectedTags.clear(); // Clear selected tags
  });
}

void showFilterDialog(BuildContext context, List<String> sortedTags) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.orange.withOpacity(0.1),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter by Tags',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF885B0E)
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing between tags
                      runSpacing: 8.0, // Vertical spacing between lines
                      children: sortedTags.map((tag) {
                        return FilterChip(
                          selectedColor: Colors.orange.withOpacity(0.3),
                          checkmarkColor: Colors.orange,
                          side: const BorderSide(
                              color: Colors.transparent
                          ),
                          label: Text(tag),
                          selected: _selectedTags.contains(tag),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _clearFilters(setState);
                        Navigator.pop(context); // Close the filter dialog
                      },
                      child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Color(0xFFC08019),
                          )
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog first
                        _applyFilters(context); // Apply filters after dialog is closed
                      },
                      child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Color(0xFFC08019),
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}