import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';

part 'estate_profile_comment_rate_event.dart';
part 'estate_profile_comment_rate_state.dart';

class EstateProfileCommentRateBloc extends Bloc<EstateProfileCommentRateEvent, EstateProfileCommentRateState> {
  EstateProfileCommentRateBloc() : super(EstateProfileCommentRateInitial()) {
    on<EstateProfileCommentRateSendCommentEvent>(_onSendComment);
    on<EstateProfileCommentRateSendRateEvent>(_onSendRate);
    on<EstateProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(EstateProfileCommentRateSendCommentEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSending) return;
    emit(EstateProfileCommentRateSending());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"),
      body: {
        "comment": event.message,
        "estate_id": event.estateId,
        if (event.replyId != null) "reply_id": event.replyId,
      },
    );

    if (!isResponseOk(res)) {
      return emit(EstateProfileCommentRateError());
    }

    emit(EstateProfileCommentRateSuccess(comment: Comment.fromJson(jDecode(res.body)["data"])));
  }

  _onSendRate(EstateProfileCommentRateSendRateEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSending) return;
    emit(EstateProfileCommentRateSending());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/rate/addRateEstate/"),
      body: {
        "rate": event.rate,
        "estate_id": event.estateId,
      },
    );

    if (!isResponseOk(res)) {
      return emit(EstateProfileCommentRateError());
    }

    emit(EstateProfileCommentRateSuccess());
  }

  _onSendCommentAndRate(EstateProfileCommentRateSendCommentAndRateEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSending) return;

    emit(EstateProfileCommentRateSending());

    var commentRes = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"),
      body: {
        "comment": event.message,
        "estate_id": event.estateId,
      },
    );
    var rateRes = await http2.postJsonWithToken(
      Uri.parse("https://rate.siraf.app/api/rate/addRateEstate/"),
      body: {
        "rate": event.rate,
        "estate_id": event.estateId,
      },
    );

    if (!isResponseOk(rateRes) || !isResponseOk(commentRes)) {
      return emit(EstateProfileCommentRateError());
    }

    emit(EstateProfileCommentRateSuccess(comment: Comment.fromJson(jDecode(commentRes.body)["data"])));
  }
}
