// comments_page.dart
import 'package:flutter/material.dart';
import 'comment.dart'; // Import the Comment class from comment.dart

class CommentsPage extends StatelessWidget {
  final List<Comment> comments;

  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: comments.isEmpty
          ? const Center(
              child: Text(
                'No comments yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Row(
                      children: [
                        Text(comment.username, style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              color: i < comment.rating ? Colors.amber : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(comment.text),
                  ),
                );
              },
            ),
    );
  }
}
