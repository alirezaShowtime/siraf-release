part of 'consultant_like_comment_bloc.dart';

@immutable
abstract class ConsultantLikeCommentState {}

class ConsultantLikeCommentInitial extends ConsultantLikeCommentState {}

class ConsultantLikeCommentLoading extends ConsultantLikeCommentState {}

class ConsultantLikeCommentError extends ConsultantLikeCommentState {}

class ConsultantLikeCommentSuccess extends ConsultantLikeCommentState {
  CommentAction action;

  ConsultantLikeCommentSuccess(this.action);
}
