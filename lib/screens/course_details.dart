import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/course.dart';
import '../models/comment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class CourseDetails extends StatefulWidget {
  final Course course;

  CourseDetails({required this.course});

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addComment(BuildContext context) {
    if (_commentController.text.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.id)
        .collection('comments')
        .add({
      'userId': 'currentUserId', // Replace with the current user's ID
      'content': _commentController.text,
      'rating': 5, // Replace with the actual rating given by the user
      'timestamp': Timestamp.now(),
    });

    _commentController.clear();
    Navigator.of(context).pop();
  }

  Future<void> _downloadDocument(String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('course_documents').child(fileName);
      final url = await ref.getDownloadURL();
      // Open the URL to download the file
      Fluttertoast.showToast(msg: 'Downloading $fileName...');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to download document: $e');
    }
  }

  Future<void> _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      try {
        await FirebaseStorage.instance
            .ref('course_documents/${file.name}')
            .putData(file.bytes!);
        Fluttertoast.showToast(msg: 'Uploaded ${file.name}');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to upload document: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          widget.course.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Add to favorites functionality
              Fluttertoast.showToast(msg: 'Added to favorites');
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share course functionality
              Fluttertoast.showToast(msg: 'Share functionality not implemented');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  widget.course.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.course.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.course.id)
                    .collection('comments')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  int commentCount = snapshot.data!.docs.length;

                  return Text(
                    '$commentCount Commentaire${commentCount > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.course.id)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    var comment = Comment.fromFirestore(snapshot.data!.docs[index]);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Text(
                                    comment.userId,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                comment.content,
                                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Text(
                                        comment.rating.toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    (comment.timestamp as Timestamp).toDate().toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: 10, // Adjust the child count as needed
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // Replace with your document fetching logic
                var documents = ['document1.pdf', 'document2.pdf', 'document3.pdf'];
                return ListTile(
                  leading: Icon(Icons.file_download, color: Colors.teal),
                  title: Text(documents[index]),
                  onTap: () {
                    _downloadDocument(documents[index]);
                  },
                );
              },
              childCount: 3, // Replace with the actual number of documents
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _uploadDocument,
                icon: Icon(Icons.cloud_upload),
                label: Text('Upload Document'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add_comment),
        onPressed: () {
          _showCommentDialog(context);
        },
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Enter your comment'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a comment';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addComment(context);
                }
              },
              child: Text('Add Comment'),
            ),
          ],
        );
      },
    );
  }
}
