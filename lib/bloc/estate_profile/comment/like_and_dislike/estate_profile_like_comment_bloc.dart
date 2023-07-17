import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/enums/comment_action.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'estate_profile_like_comment_event.dart';
part 'estate_profile_like_comment_state.dart';

class EstateProfileLikeCommentBloc extends Bloc<EstateProfileLikeCommentEvent, EstateProfileLikeCommentState> {
  EstateProfileLikeCommentBloc() : super(EstateProfileLikeCommentInitial()) {
    on<EstateProfileLikeCommentRequestEvent>(_request);
  }

  FutureOr<void> _request(EstateProfileLikeCommentRequestEvent event, Emitter<EstateProfileLikeCommentState> emit) async {
    if (state is EstateProfileLikeCommentLoading) return;
    if (state is EstateProfileLikeCommentSuccess && (state as EstateProfileLikeCommentSuccess).action == event.action) return;
    emit(EstateProfileLikeCommentLoading());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/likeComment/likeCommentEstate/"),
      body: {
        "commentEstate_id": event.estateId,
        "status": event.action == CommentAction.Like ? 1 : 0,
      },
    );

    if (!isResponseOk(res)) {
      return emit(EstateProfileLikeCommentError());
    }
    return emit(EstateProfileLikeCommentSuccess(event.action));
  }
}
