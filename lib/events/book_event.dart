// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

// class BookUsernameChanged extends BookEvent {
//   const BookUsernameChanged(this.username);

//   final String username;

//   @override
//   List<Object> get props => [username];
// }

// class BookPasswordChanged extends BookEvent {
//   const BookPasswordChanged(this.password);

//   final String password;

//   @override
//   List<Object> get props => [password];
// }

class BookSubmitted extends BookEvent {
  const BookSubmitted(this.password, this.username);
  final String password;
  final String username;

  @override
  List<Object> get props => [password, username];
}

class GetBooks extends BookEvent {
  final String? CategoryId;

  const GetBooks(this.CategoryId);
}

class GetCategories extends BookEvent {}

class CreateBook extends BookEvent {
  final String title;
  final String description;
  final String author;
  final String? location;
  final String latitude;
  final String? longitude;
  final String image;

  const CreateBook(
      {required this.title,
      required this.description,
      required this.author,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.image});
}
