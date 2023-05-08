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
  final int? categoryId;
  final int? userId;
  final String? title;
  final String? latitude;
  final String? longitude;
  final String? page;

  const GetBooks(
      {this.categoryId, this.userId, this.title, this.latitude, this.longitude, this.page});
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
  final String categoryId;
  final String userId;

  const CreateBook({
    required this.title,
    required this.description,
    required this.author,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.categoryId,
    required this.userId,
  });
}
