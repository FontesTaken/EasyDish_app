import 'dart:io';
import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'package:flutter/material.dart';

import '../../../data_classes/recipe_data.dart';
import '../../auxiliary/tag_widget.dart';
import '../../recipe/recipe_detail_page.dart';

Expanded recipeList() {
  return Expanded(
    child: ListView.builder(
      itemCount: RecipeData.recipes.length,
      itemBuilder: (context, index) {
        final recipe = RecipeData.recipes[index];
        return Card(
          color: const Color(0xFFFFD095),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: kIsWeb
                  ? Image.network(
                      recipe.imageUrl, // Use `imageUrl` for web
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : (recipe.imageUrl.startsWith('http')
                      ? Image.network(
                          recipe.imageUrl, // For non-web with URLs
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(recipe.imageUrl), // For local file paths
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )),
            ),
            title: Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF885B0E),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0), // Add spacing to the top
                Wrap(
                  spacing: 4.0,
                  children:
                      recipe.tags.map((tag) => TagWidget(text: tag)).toList(),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipe: recipe),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
