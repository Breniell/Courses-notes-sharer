import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/messages.dart';
import '../models/course.dart';
import '../models/comment.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve all courses with optional filtering, sorting, and favorites
  Future<List<Course>> getCourses([String searchQuery = '', String category = 'All', bool sortByName = true, bool showFavorites = false]) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('courses');

      if (searchQuery.isNotEmpty) {
        query = query.where('name', isGreaterThanOrEqualTo: searchQuery).where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff');
      }

      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      if (showFavorites) {
        query = query.where('isFavorite', isEqualTo: true);
      }

      query = query.orderBy('name', descending: !sortByName);

      var querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error retrieving courses: $e");
      return []; // Return an empty list on error
    }
  }

  // Add a message
  Future<void> sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toFirestore());
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Retrieve messages
  Stream<List<Message>> getMessages(String senderId, String receiverId) {
    try {
      return _firestore
          .collection('messages')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
    } catch (e) {
      print("Error retrieving messages: $e");
      return Stream.empty(); // Return an empty stream on error
    }
  }

  // Add a comment
  Future<void> addComment(String courseId, Comment comment) async {
    try {
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('comments')
          .add(comment.toFirestore());
    } catch (e) {
      print("Error adding comment: $e");
    }
  }

  // Retrieve comments for a course
  Stream<List<Comment>> getComments(String courseId) {
    try {
      return _firestore
          .collection('courses')
          .doc(courseId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList());
    } catch (e) {
      print("Error retrieving comments: $e");
      return Stream.empty(); // Return an empty stream on error
    }
  }
}
