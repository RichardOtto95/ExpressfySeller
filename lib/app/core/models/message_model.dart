import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String author;
  final Timestamp? createdAt;
  final String? file;
  final String? fileType;
  final String? id;
  final String? text;
  final String? title;
  final String? userType;

  Message({
    this.title,
    this.file,
    this.fileType,
    this.createdAt,
    required this.author,
    required this.text,
    this.id,
    this.userType,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    String? _userType;
    try {
      _userType = doc["user_type"];
    } catch (e) {

    }
    Message _message = Message(
      author: doc["author"],
      createdAt: doc["created_at"],
      text: doc["text"],
      id: doc["id"],
      file: doc["file"],
      fileType: doc["file_type"],
      userType: _userType
    );
    return _message;
  }

  Map<String, dynamic> toJson() => {
        "author": author,
        "created_at": createdAt,
        "text": text,
        "id": id,
        "type": file,
        "file_type": fileType,
        "user_type": userType,
      };
}

class SearchMessage {
  final Message message;
  final String title;
  final String receiverId;
  final String receiverCollection;

  SearchMessage(
    this.message,
    this.title,
    this.receiverId,
    this.receiverCollection,
  );
}
