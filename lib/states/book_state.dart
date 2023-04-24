import 'package:diplom/blocs/book.bloc.dart';
import 'package:equatable/equatable.dart';

class BookState extends Equatable {
  const BookState({
    this.status = BookStatus.loading,
    this.books = const [],
    this.categories = const [],
  });
  final BookStatus status;
  final List books;
  final List categories;

  BookState copyWith({
    BookStatus? status,
    List? books,
    List? categories,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [status, books, categories];
}
