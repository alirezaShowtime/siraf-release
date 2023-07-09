import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'consultant_profile_comment_rate_event.dart';

part 'consultant_profile_comment_rate_state.dart';

class ConsultantProfileCommentRateBloc extends Bloc<ConsultantProfileCommentRateEvent, ConsultantProfileCommentRateState> {
  ConsultantProfileCommentRateBloc() : super(ConsultantProfileCommentRateInitialState()) {
    on<ConsultantProfileCommentRateSendCommentEvent>(_onSendComment);
    on<ConsultantProfileCommentRateSendRateEvent>(_onSendRate);
    on<ConsultantProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(ConsultantProfileCommentRateSendCommentEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSendingState) return;

    emit(ConsultantProfileCommentRateSendingState());
    var body = {"comment": event.message, "estate_id": event.consultantId.toString()};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentConsultant/"), body: body, headers: headers);
    if (!isResponseOk(res)) {
      print(res.body);
      return emit(ConsultantProfileCommentRateErrorState());
    }

    emit(ConsultantProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(res.body)["data"])));
  }

  _onSendRate(ConsultantProfileCommentRateSendRateEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSendingState) return;

    emit(ConsultantProfileCommentRateSendingState());

    var body = {"rate": event.rate, "estate_id": event.consultantId};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/rate/consultantRate/"), body: body, headers: headers);
    print(jDecode(res.body));

    if (!isResponseOk(res)) {
      return emit(ConsultantProfileCommentRateErrorState());
    }

    emit(ConsultantProfileCommentRateSuccessState());
  }

  _onSendCommentAndRate(ConsultantProfileCommentRateSendCommentAndRateEvent event, Emitter<ConsultantProfileCommentRateState> emit) async {
    if (state is ConsultantProfileCommentRateSendingState) return;

    emit(ConsultantProfileCommentRateSendingState());
    var commentBody = {"comment": event.message, "estate_id": event.consultantId};

    var commentHeaders = {
      "Authorization": await User.getBearerToken(),
    };

    var rateBody = {"rate": event.rate, "estate_id": event.consultantId};

    var rateHeaders = {
      "Authorization": await User.getBearerToken(),
    };

    var commentRes = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentConsultant/"), body: commentBody, headers: commentHeaders);
    var rateRes = await http2.post(Uri.parse("https://rate.siraf.app/api/rate/consultantRate/"), body: rateBody, headers: rateHeaders);

    if (!isResponseOk(rateRes) || !isResponseOk(commentRes)) {
      return emit(ConsultantProfileCommentRateErrorState());
    }

    emit(ConsultantProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(commentRes.body)["data"])));
  }
}
