
import 'package:equatable/equatable.dart';

class User extends Equatable{
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo
  });
  final String? photo;
  final String? email;
  final String?name;
  final String id;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;
  @override
  List<Object?> get props => [email,name,id,photo];

}