import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  static const String collectionName = 'books';

  final String? id;
  final String title;
  final String author;
  final String writers;
  final String category;
  final int numberOfPages;
  final int yearOfPublication;
  final bool isPublished;

  const Book({
    this.id,
    required this.title,
    required this.author,
    required this.writers,
    required this.category,
    required this.numberOfPages,
    required this.yearOfPublication,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'author': author,
      'writers': writers,
      'category': category,
      'numberOfPages': numberOfPages,
      'yearOfPublication': yearOfPublication,
      'isPublished': isPublished,
    };
  }

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      writers: map['writers'],
      category: map['category'],
      numberOfPages: map['numberOfPages'],
      yearOfPublication: map['yearOfPublication'],
      isPublished: map['isPublished'],
    );
  }

  static Future<List<Book>> get() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('isPublished', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((e) => Book.fromJson(e.data()..['id'] = e.id))
        .toList();
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .delete();
  }

  Future<void> update() async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .update(toMap());
  }

  Future<DocumentReference<Map<String, dynamic>>> push() async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .add(toMap());
  }
}
