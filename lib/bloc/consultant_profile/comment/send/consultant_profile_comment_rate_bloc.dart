import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';

part 'consultant_profile_comment_rate_event.dart';
part 'consultant_profile_comment_rate_state.dart';

class ConsultantProfileCommentRateBloc extends Bloc<ConsultantProfileCommentRateEvent, ConsultantProfileCommentRateState> {
  ConsultantProfileCommentRateBloc() : super(ConsultantProfileCommentRateInitial()) {
    on<ConsultantProfileCommentRateSendCommentEvent>(_onSendComment);
    on<ConsultantProfileCommentRateSendRateEvent>(_onSendRate);
    on<ConsultantProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(ConsultantProfileCommentRateSendCommentEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSending) return;

    emit(ConsultantProfileCommentRateSending());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/comment/addCommentConsultant/"),
      body: {
        "comment": event.message,
        "consultant_id": event.consultantId,
        if (event.commentId != null) "reply_id": event.commentId,
      },
    );
    if (!isResponseOk(res)) {
      return emit(ConsultantProfileCommentRateError(res));
    }

    emit(ConsultantProfileCommentRateSuccess(res, event.commentId != null));
  }

  _onSendRate(ConsultantProfileCommentRateSendRateEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSending) return;

    emit(ConsultantProfileCommentRateSending());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/rate/consultantRate/"),
      body: {
        "rate": event.rate,
        "consultants_id": event.consultantId,
      },
    );

    if (!isResponseOk(res)) {
      return emit(ConsultantProfileCommentRateError(res));
    }

    emit(ConsultantProfileCommentRateSuccess(null, false));
  }

  _onSendCommentAndRate(ConsultantProfileCommentRateSendCommentAndRateEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSending) return;

    emit(ConsultantProfileCommentRateSending());

    var commentRes = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/comment/addCommentConsultant/"),
      body: {
        "comment": event.message,
        "consultant_id": event.consultantId,
      },
    );
    var rateRes = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/rate/consultantRate/"),
      body: {
        "rate": event.rate,
        "consultants_id": event.consultantId,
      },
    );

    if (!isResponseOk(rateRes)) {
      return emit(ConsultantProfileCommentRateError(rateRes));
    }

    if (!isResponseOk(commentRes)) {
      return emit(ConsultantProfileCommentRateError(commentRes));
    }

    emit(ConsultantProfileCommentRateSuccess(commentRes, false));
  }
}
