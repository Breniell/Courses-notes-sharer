import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String content;
  final double rating;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.content,
    required this.rating,
    required this.timestamp,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Vérifie si 'timestamp' est un Timestamp ou un DateTime
    var timestampData = data['timestamp'];
    DateTime timestamp;
    if (timestampData is Timestamp) {
      timestamp = timestampData.toDate();
    } else if (timestampData is DateTime) {
      timestamp = timestampData; // Si c'est déjà un DateTime
    } else {
      timestamp = DateTime.now(); // Valeur par défaut
    }

    return Comment(
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
