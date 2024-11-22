// search_results_page.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data_classes/recipe.dart';
import '../recipe/recipe_detail_page.dart';
import '../auxiliary/tag_widget.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Recipe> filteredRecipes;
  final String searchQuery;

  const SearchResultsPage({
    super.key,
    required this.filteredRecipes,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Base color to prevent blending issues
        child:  Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          appBar: AppBar(
            backgroundColor: Colors.orange.withOpacity(0.01),
            title: Text(
                'Search results for "$searchQuery"',
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecipes.isEmpty ? 1 : filteredRecipes.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredRecipes.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No more results found!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF885B0E),
                              ),
                            ),
                          ),
                        );
                      }

                      final recipe = filteredRecipes[index];
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
                ),
              ],
            ),
          ),
        )
    );
  }
}
