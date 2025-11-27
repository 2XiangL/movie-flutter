import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'fullName')
  final String? fullName;
  @JsonKey(name: 'email')
  final String? email;

  User({
    this.id,
    required this.username,
    this.fullName,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
           other.id == id &&
           other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode;
}

@JsonSerializable()
class UserRating {
  @JsonKey(name: 'movieTitle')
  final String movieTitle;
  final double score;
  final String? timestamp;

  UserRating({
    required this.movieTitle,
    required this.score,
    this.timestamp,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) => _$UserRatingFromJson(json);
  Map<String, dynamic> toJson() => _$UserRatingToJson(this);
}

@JsonSerializable()
class UserComment {
  @JsonKey(name: 'movieTitle')
  final String movieTitle;
  final String content;
  final String? timestamp;

  UserComment({
    required this.movieTitle,
    required this.content,
    this.timestamp,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) => _$UserCommentFromJson(json);
  Map<String, dynamic> toJson() => _$UserCommentToJson(this);
}

@JsonSerializable()
class UserFavorite {
  @JsonKey(name: 'movieTitle')
  final String movieTitle;
  final String? timestamp;

  UserFavorite({
    required this.movieTitle,
    this.timestamp,
  });

  factory UserFavorite.fromJson(Map<String, dynamic> json) => _$UserFavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$UserFavoriteToJson(this);
}

// 登录请求模型
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// 注册请求模型
@JsonSerializable()
class RegisterRequest {
  final String username;
  final String password;
  final String? fullName;
  final String? email;

  RegisterRequest({
    required this.username,
    required this.password,
    this.fullName,
    this.email,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// 评分请求模型
@JsonSerializable()
class RatingRequest {
  @JsonKey(name: 'movieTitle')
  final String movieTitle;
  final double score;

  RatingRequest({
    required this.movieTitle,
    required this.score,
  });

  factory RatingRequest.fromJson(Map<String, dynamic> json) => _$RatingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RatingRequestToJson(this);
}

// 评论请求模型
@JsonSerializable()
class CommentRequest {
  @JsonKey(name: 'movieTitle')
  final String movieTitle;
  final String content;

  CommentRequest({
    required this.movieTitle,
    required this.content,
  });

  factory CommentRequest.fromJson(Map<String, dynamic> json) => _$CommentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CommentRequestToJson(this);
}

