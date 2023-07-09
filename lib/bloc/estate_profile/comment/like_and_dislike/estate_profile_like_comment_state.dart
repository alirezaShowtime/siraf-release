part of 'estate_profile_like_comment_bloc.dart';

@immutable
abstract class EstateProfileLikeCommentState {}

class EstateProfileLikeCommentInitial extends EstateProfileLikeCommentState {}

class EstateProfileLikeCommentLoading extends EstateProfileLikeCommentState {}

class EstateProfileLikeCommentError extends EstateProfileLikeCommentState {}

class EstateProfileLikeCommentSuccess extends EstateProfileLikeCommentState {
  CommentAction action;

  EstateProfileLikeCommentSuccess(this.action);
}
