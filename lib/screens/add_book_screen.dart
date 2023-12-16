import 'package:flutter/material.dart';
import 'package:odev/models/book_model.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key, this.book});

  final Book? book;

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController authorTextController = TextEditingController();
  final TextEditingController writersTextController = TextEditingController();
  final TextEditingController categoryTextController = TextEditingController();
  final TextEditingController numberOfPagesTextController =
      TextEditingController();
  final TextEditingController yearOfPublicationTextController =
      TextEditingController();
  bool isPublished = false;

  @override
  void initState() {
    super.initState();

    var book = widget.book;

    if (book != null) {
      titleTextController.value = TextEditingValue(text: book.title);
      authorTextController.value = TextEditingValue(text: book.author);
      writersTextController.value = TextEditingValue(text: book.writers);
      categoryTextController.value = TextEditingValue(text: book.category);
      numberOfPagesTextController.value =
          TextEditingValue(text: book.numberOfPages.toString());
      yearOfPublicationTextController.value =
          TextEditingValue(text: book.yearOfPublication.toString());
      isPublished = book.isPublished;
    } else {
      categoryTextController.value =
          TextEditingValue(text: categories[0].label);
    }
  }

  final List<DropdownMenuEntry> categories = [
    const DropdownMenuEntry(
      label: 'Roman',
      value: 'Roman',
    ),
    const DropdownMenuEntry(
      label: 'Tarih',
      value: 'Tarih',
    ),
    const DropdownMenuEntry(
      label: 'Edebiyat',
      value: 'Edebiyat',
    ),
    const DropdownMenuEntry(
      label: 'Şiir',
      value: 'Şiir',
    ),
    const DropdownMenuEntry(
      label: 'Ansiklopedi',
      value: 'Ansiklopedi',
    ),
  ];

  @override
  void dispose() {
    titleTextController.dispose();
    authorTextController.dispose();
    writersTextController.dispose();
    categoryTextController.dispose();
    numberOfPagesTextController.dispose();
    yearOfPublicationTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kitap Ekle'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Kitap adı',
                ),
                controller: titleTextController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Yayınevi',
                ),
                controller: authorTextController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Yazarlar',
                ),
                controller: writersTextController,
              ),
              DropdownMenu(
                width: MediaQuery.of(context).size.width - 32,
                dropdownMenuEntries: categories,
                label: const Text('Kategori'),
                inputDecorationTheme: const InputDecorationTheme(
                  border: UnderlineInputBorder(),
                ),
                controller: categoryTextController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Sayfa sayısı',
                ),
                keyboardType: TextInputType.number,
                controller: numberOfPagesTextController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Basım yılı',
                ),
                keyboardType: TextInputType.number,
                controller: yearOfPublicationTextController,
              ),
              CheckboxListTile(
                  value: isPublished,
                  onChanged: (value) {
                    setState(() {
                      isPublished = value!;
                    });
                  },
                  title: const Text('Listede yayınlanacak mı?')),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    var book = Book(
                      id: widget.book?.id,
                      title: titleTextController.text,
                      author: authorTextController.text,
                      category: categoryTextController.text,
                      numberOfPages:
                          int.parse(numberOfPagesTextController.text),
                      writers: writersTextController.text,
                      yearOfPublication:
                          int.parse(yearOfPublicationTextController.text),
                      isPublished: isPublished,
                    );

                    if (widget.book != null) {
                      await book.update();
                    } else {
                      await book.push();
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Kaydet"),
                ),
              )
            ],
          ),
        ));
  }
}
