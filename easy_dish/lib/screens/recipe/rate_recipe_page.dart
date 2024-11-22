// rate_recipe_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_test/data_classes/user_data.dart';
import '../../data_classes/comment.dart';
import '../../data_classes/recipe.dart';

class RateRecipePage extends StatefulWidget {
  final Recipe recipe;
  final Function(Comment) onSubmit;

  const RateRecipePage({
    super.key,
    required this.recipe,
    required this.onSubmit,
  });

  @override
  State<RateRecipePage> createState() => _RateRecipePageState();
}

class _RateRecipePageState extends State<RateRecipePage> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  void submitReview() {
    if (selectedRating > 0) {
      final newComment = Comment(
        username: UserData.instance.isLoggedIn ? UserData.instance.name : "Anonymous",
        rating: selectedRating,
        text: commentController.text,
      );
      widget.onSubmit(newComment);
      Navigator.pop(context); // Close the rating page after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Base color to prevent blending issues
        child:  Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          resizeToAvoidBottomInset: true, // Adjust layout when keyboard is visible
          appBar: AppBar(
            backgroundColor: Colors.orange.withOpacity(0.01),
            scrolledUnderElevation: 0,
            title: Text("How was your experience?",
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
              color: Color(0xFFC08019),
            ),
          ),
          body: SingleChildScrollView( // Makes the content scrollable
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Center(
                    child: Image.network(
                      widget.recipe.imageUrl,
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(widget.recipe.name,
                    style: TextStyle(
                      color: Color(0xFFC08019),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < selectedRating ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Your opinion...',
                    labelStyle: TextStyle(
                      color: Color(0xFFC08019),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    hintText: '(optional)',
                    hintStyle: TextStyle(
                      color: Color(0xFFC08019),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFD095),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.orange, // Color when TextField is focused
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFE0BC91), // Border color when enabled
                        width: 3,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFFFDAB0),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD095),
                    elevation: 4
                  ),
                  child: const Text(
                      'Send Review',
                      style: TextStyle(
                        color: Color(0xFF885B0E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  )
                ),
              ],
            ),
          ),
        )
    );
  }
}
