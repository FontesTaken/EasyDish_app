// comments_page.dart
import 'package:flutter/material.dart';
import '../../data_classes/comment.dart'; // Import the Comment class from comment.dart

class CommentsPage extends StatelessWidget {
  final List<Comment> comments;

  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Base color to prevent blending issues
        child: Scaffold(
        backgroundColor: Colors.orange.withOpacity(0.19),
        appBar: AppBar(
          backgroundColor: Colors.orange.withOpacity(0.01),
          title: const Text(
              'Comments',
              style: TextStyle(
                color: Color(0xFFC08019),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              )),
        ),
        body: comments.isEmpty
            ? const Center(
                child: Text(
                  'No comments yet.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF885B0E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    color: const Color(0xFFFFDAB4),
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Icon(Icons.person, size: 40),
                      title: Row(
                        children: [
                          Text(
                              comment.username,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF885B0E),
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
                      subtitle: Text(
                          comment.text,
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF563A0A)
                          )),
                    ),
                  );
                },
              ),
      )
    );
  }
}
