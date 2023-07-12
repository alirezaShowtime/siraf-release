part of 'consultant_like_comment_bloc.dart';

@immutable
abstract class ConsultantLikeCommentEvent {}

class ConsultantLikeCommentRequestEvent extends ConsultantLikeCommentEvent {
  int commentId;
  CommentAction action;

  ConsultantLikeCommentRequestEvent(this.commentId, this.action);
}
