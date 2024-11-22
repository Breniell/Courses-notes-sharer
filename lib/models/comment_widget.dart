import 'package:flutter/material.dart';
import '../models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  CommentWidget({required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(comment.userId[0].toUpperCase()),
      ),
      title: Text(comment.content),
      subtitle: Row(
        children: List.generate(
          5,
              (index) => Icon(
            Icons.star,
            color: index < comment.rating.floor() ? Colors.amber : Colors.grey,
          ),
        ),
      ),
    );
  }
}
