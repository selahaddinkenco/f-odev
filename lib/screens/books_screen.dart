import 'package:flutter/material.dart';
import 'package:odev/models/book_model.dart';
import 'package:odev/screens/add_book_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  void initState() {
    super.initState();

    fetchBooks();
  }

  late Future<List<Book>> booksData;

  void fetchBooks() {
    booksData = Book.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookScreen(),
            ),
          ).then((value) => setState(() {
                fetchBooks();
              }));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: booksData,
          builder: (context, AsyncSnapshot<List<Book>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasData) {
                  int itemCount = snapshot.data!.length;

                  if (itemCount == 0) {
                    return const Center(
                      child: Text('Kitap bulunamadı.'),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) =>
                        BookWidget(
                            book: snapshot.data![index],
                            fetchBooks: () {
                              setState(() {
                                fetchBooks();
                              });
                            }),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                    itemCount: itemCount,
                  );
                } else {
                  return const Center(
                    child: Text('Oops.'),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

class BookWidget extends StatelessWidget {
  final Book book;

  final Function fetchBooks;

  const BookWidget({super.key, required this.book, required this.fetchBooks});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        book.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle:
          Text("Yazar: ${book.author}, Sayfa sayısı: ${book.numberOfPages}"),
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookScreen(book: book),
                ),
              ).then((value) => fetchBooks());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Kitabı Sil'),
                  content: const Text('Emin misin?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('İptal et'),
                    ),
                    TextButton(
                      onPressed: () {
                        book.delete().then((value) {
                          Navigator.pop(context);

                          fetchBooks();
                        });
                      },
                      child: const Text('Sil'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
