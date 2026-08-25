import 'dart:io';

abstract class LibraryItem {
  void borrowItem();
  void returnItem();
  void displayInfo();
}

class Book extends LibraryItem {
  String _id;
  String _title;
  String _author;
  int _year;
  bool _isAvailable;

  Book(
    this._id,
    this._title,
    this._author,
    this._year, {
    bool isAvailable = true,
  }) : _isAvailable = isAvailable;

  String get id => _id;
  String get title => _title;
  String get author => _author;
  int get year => _year;
  bool get isAvailable => _isAvailable;

  set title(String value) {
    if (value.trim().isNotEmpty) _title = value.trim();
  }

  set author(String value) {
    if (value.trim().isNotEmpty) _author = value.trim();
  }

  set year(int value) {
    if (value > 0) _year = value;
  }

  @override
  void borrowItem() => _isAvailable = false;

  @override
  void returnItem() => _isAvailable = true;

  @override
  void displayInfo() {
    String status = _isAvailable ? 'Available' : 'Borrowed';
    print('ID: $_id | $_title by $_author ($_year) | $status');
  }
}

class Library {
  final List<Book> _books = [];

  void addBook(Book book) => _books.add(book);

  Book? _findBook(String id) {
    for (Book book in _books) {
      if (book.id.toLowerCase() == id.toLowerCase()) return book;
    }
    return null;
  }

  void showBooks({bool? available}) {
    List<Book> result = _books
        .where((book) => available == null || book.isAvailable == available)
        .toList();
    if (result.isEmpty) {
      print('No books found.');
      return;
    }
    for (Book book in result) {
      book.displayInfo();
    }
  }

  void borrowBook(String id) {
    Book? book = _findBook(id);
    if (book == null) {
      print('Book ID not found.');
    } else if (!book.isAvailable) {
      print('This book is already borrowed.');
    } else {
      book.borrowItem();
      print('You borrowed "${book.title}".');
    }
  }

  void returnBook(String id) {
    Book? book = _findBook(id);
    if (book == null) {
      print('Book ID not found.');
    } else if (book.isAvailable) {
      print('This book was not borrowed.');
    } else {
      book.returnItem();
      print('You returned "${book.title}".');
    }
  }

  void searchByTitle(String text) {
    List<Book> result = _books
        .where((book) => book.title.toLowerCase().contains(text.toLowerCase()))
        .toList();
    if (result.isEmpty) {
      print('No matching books found.');
    } else {
      for (Book book in result) {
        book.displayInfo();
      }
    }
  }

  void showStatistics() {
    int available = _books.where((book) => book.isAvailable).length;
    int total = _books.length;
    double percentage = total == 0 ? 0 : available * 100 / total;
    print('Total books: $total');
    print('Available: $available');
    print('Borrowed: ${total - available}');
    print('Availability: ${percentage.toStringAsFixed(1)}%');
  }
}

class LibraryApp {
  final Library library = Library();

  LibraryApp() {
    library.addBook(
      Book('B001', 'The Great Gatsby', 'F. Scott Fitzgerald', 1925),
    );
    library.addBook(Book('B002', '1984', 'George Orwell', 1949));
    library.addBook(Book('B003', 'To Kill a Mockingbird', 'Harper Lee', 1960));
    library.addBook(Book('B004', 'The Hobbit', 'J.R.R. Tolkien', 1937));
    library.addBook(Book('B005', 'Pride and Prejudice', 'Jane Austen', 1813));
  }

  String _input(String message) {
    stdout.write(message);
    return stdin.readLineSync()?.trim() ?? '';
  }

  void start() {
    print('Welcome to the Library Management System');
    while (true) {
      print('\n1. View all books');
      print('2. View available books');
      print('3. View borrowed books');
      print('4. Add a new book');
      print('5. Borrow a book');
      print('6. Return a book');
      print('7. Search by title');
      print('8. View statistics');
      print('9. Exit');

      switch (_input('Choose (1-9): ')) {
        case '1':
          library.showBooks();
          break;
        case '2':
          library.showBooks(available: true);
          break;
        case '3':
          library.showBooks(available: false);
          break;
        case '4':
          _addBook();
          break;
        case '5':
          library.borrowBook(_input('Book ID: '));
          break;
        case '6':
          library.returnBook(_input('Book ID: '));
          break;
        case '7':
          String title = _input('Title to search: ');
          title.isEmpty
              ? print('Please enter a title.')
              : library.searchByTitle(title);
          break;
        case '8':
          library.showStatistics();
          break;
        case '9':
          print('Goodbye!');
          return;
        default:
          print('Invalid choice. Please enter 1 to 9.');
      }
    }
  }

  void _addBook() {
    String id = _input('ID: ');
    String title = _input('Title: ');
    String author = _input('Author: ');
    int? year = int.tryParse(_input('Year: '));
    if (id.isEmpty ||
        title.isEmpty ||
        author.isEmpty ||
        year == null ||
        year <= 0) {
      print('Invalid book details. All fields are required.');
      return;
    }
    library.addBook(Book(id, title, author, year));
    print('Book added successfully.');
  }
}

void main() {
  LibraryApp().start();
}
