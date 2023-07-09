part of 'estate_profile_like_comment_bloc.dart';

@immutable
abstract class EstateProfileLikeCommentEvent {}

class EstateProfileLikeCommentRequestEvent extends EstateProfileLikeCommentEvent {
  int estateId;
  CommentAction action;

  EstateProfileLikeCommentRequestEvent(this.estateId, this.action);
}
