import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/enums/comment_action.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'consultant_like_comment_event.dart';

part 'consultant_like_comment_state.dart';

class ConsultantLikeCommentBloc extends Bloc<ConsultantLikeCommentEvent, ConsultantLikeCommentState> {
  ConsultantLikeCommentBloc() : super(ConsultantLikeCommentInitial()) {
    on<ConsultantLikeCommentRequestEvent>(_request);
  }

  FutureOr<void> _request(ConsultantLikeCommentRequestEvent event, Emitter<ConsultantLikeCommentState> emit) async {
    if (state is ConsultantLikeCommentLoading) return;
    emit(ConsultantLikeCommentLoading());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/likeComment/likeCommentConsultant"),
      body: {
        "commentConsultant_id": event.commentId,
        "status": event.action == CommentAction.Like ? 1 : 0,
      },
    );

    if (!isResponseOk(res)) {
      return emit(ConsultantLikeCommentError());
    }

    return emit(ConsultantLikeCommentSuccess(event.action));
  }
}
