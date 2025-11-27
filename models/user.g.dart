// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String?,
  username: json['username'] as String,
  fullName: json['fullName'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'fullName': instance.fullName,
  'email': instance.email,
};

UserRating _$UserRatingFromJson(Map<String, dynamic> json) => UserRating(
  movieTitle: json['movieTitle'] as String,
  score: (json['score'] as num).toDouble(),
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$UserRatingToJson(UserRating instance) =>
    <String, dynamic>{
      'movieTitle': instance.movieTitle,
      'score': instance.score,
      'timestamp': instance.timestamp,
    };

UserComment _$UserCommentFromJson(Map<String, dynamic> json) => UserComment(
  movieTitle: json['movieTitle'] as String,
  content: json['content'] as String,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$UserCommentToJson(UserComment instance) =>
    <String, dynamic>{
      'movieTitle': instance.movieTitle,
      'content': instance.content,
      'timestamp': instance.timestamp,
    };

UserFavorite _$UserFavoriteFromJson(Map<String, dynamic> json) => UserFavorite(
  movieTitle: json['movieTitle'] as String,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$UserFavoriteToJson(UserFavorite instance) =>
    <String, dynamic>{
      'movieTitle': instance.movieTitle,
      'timestamp': instance.timestamp,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'fullName': instance.fullName,
      'email': instance.email,
    };

RatingRequest _$RatingRequestFromJson(Map<String, dynamic> json) =>
    RatingRequest(
      movieTitle: json['movieTitle'] as String,
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$RatingRequestToJson(RatingRequest instance) =>
    <String, dynamic>{
      'movieTitle': instance.movieTitle,
      'score': instance.score,
    };

CommentRequest _$CommentRequestFromJson(Map<String, dynamic> json) =>
    CommentRequest(
      movieTitle: json['movieTitle'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CommentRequestToJson(CommentRequest instance) =>
    <String, dynamic>{
      'movieTitle': instance.movieTitle,
      'content': instance.content,
    };

