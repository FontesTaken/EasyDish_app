// rate_recipe_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_test/data_classes/user_data.dart';
import '../../data_classes/comment.dart';

class RateRecipePage extends StatefulWidget {
  final String recipeName;
  final Function(Comment) onSubmit;

  const RateRecipePage({
    super.key,
    required this.recipeName,
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
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust layout when keyboard is visible
      appBar: AppBar(
        title: Text(widget.recipeName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // Makes the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://via.placeholder.com/200', // Replace with actual recipe image if available
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.recipeName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
              decoration: const InputDecoration(
                labelText: 'Your opinion...',
                hintText: '(optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitReview,
              child: const Text('Send Review'),
            ),
          ],
        ),
      ),
    );
  }
}
