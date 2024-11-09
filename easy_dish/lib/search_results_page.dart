// search_results_page.dart
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail_page.dart';
import 'tag_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Search results for "$searchQuery"'),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  final recipe = filteredRecipes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        recipe.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Wrap(
                        spacing: 8.0,
                        children: recipe.tags.map((tag) => TagWidget(text: tag)).toList(),
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
    );
  }
}
