import 'package:diplom/events/book_event.dart';

import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/states/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BookStatus { loading, failure, loaded, success }

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({
    required BookRepository bookRepository,
  })  : _bookRepository = bookRepository,
        super(const BookState()) {
    on<GetBooks>(_onGetBooks);
    on<GetCategories>(_onGetCategories);
    on<CreateBook>(_onCreateBook);
    on<UpdateBook>(_onUpdateBook);
  }

  final BookRepository _bookRepository;

  Future<void> _onGetBooks(
    GetBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      var books = await _bookRepository.getBooks(
        title: event.title,
        userId: event.userId,
        categoryId: event.categoryId,
        latitude: event.latitude,
        longitude: event.longitude,
        page: event.page,
      );
      emit(state.copyWith(status: BookStatus.loaded, books: books));
    } catch (_) {
      emit(state.copyWith(status: BookStatus.failure));
    }
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<BookState> emit,
  ) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      var categories = await _bookRepository.getCategories();

      emit(state.copyWith(status: BookStatus.loaded, categories: categories));
    } catch (_) {
      emit(state.copyWith(
        status: BookStatus.failure,
      ));
    }
  }

  Future<void> _onCreateBook(
    CreateBook event,
    Emitter<BookState> emit,
  ) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      var book = await _bookRepository.createBook(
        title: event.title,
        author: event.author,
        description: event.description,
        location: event.location!,
        latitude: event.latitude,
        longitude: event.longitude!,
        categoryId: event.categoryId,
        image: event.image,
        userId: event.userId,
      );

      emit(state.copyWith(status: BookStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: BookStatus.failure,
      ));
    }
  }

  Future<void> _onUpdateBook(
    UpdateBook event,
    Emitter<BookState> emit,
  ) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      var book = event.image == null
          ? await _bookRepository.updateBook(
              bookId: event.bookId,
              title: event.title!,
              author: event.author!,
              description: event.description!,
              location: event.location!,
              latitude: event.latitude!,
              longitude: event.longitude!,
              categoryId: event.categoryId!,
            )
          : await _bookRepository.updateBook(
              bookId: event.bookId,
              title: event.title!,
              author: event.author!,
              description: event.description!,
              location: event.location!,
              latitude: event.latitude!,
              longitude: event.longitude!,
              categoryId: event.categoryId!,
              image: event.image!,
            );
      emit(state.copyWith(status: BookStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BookStatus.failure));
    }
  }
}
