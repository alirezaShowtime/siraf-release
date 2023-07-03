import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'agent_profile_comment_rate_event.dart';

part 'agent_profile_comment_rate_state.dart';

class AgentProfileCommentRateBloc extends Bloc<AgentProfileCommentRateEvent, AgentProfileCommentRateState> {
  AgentProfileCommentRateBloc() : super(AgentProfileCommentRateInitialState()) {
    on<AgentProfileCommentRateSendCommentEvent>(_onSendComment);
    on<AgentProfileCommentRateSendRateEvent>(_onSendRate);
    on<AgentProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(AgentProfileCommentRateSendCommentEvent event, Emitter<AgentProfileCommentRateState> emit) async {
    if (state is AgentProfileCommentRateSendingState) return;

    emit(AgentProfileCommentRateSendingState());
    var body = {"comment": event.message, "estate_id": event.consultantId.toString()};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentConsultant/"), body: body, headers: headers);
    if (!isResponseOk(res)) {
      print(res.body);
      return emit(AgentProfileCommentRateErrorState());
    }

    emit(AgentProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(res.body)["data"])));
  }

  _onSendRate(AgentProfileCommentRateSendRateEvent event, Emitter<AgentProfileCommentRateState> emit) async {
    if (state is AgentProfileCommentRateSendingState) return;

    emit(AgentProfileCommentRateSendingState());

    var body = {"rate": event.rate, "estate_id": event.consultantId};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/rate/consultantRate/"), body: body, headers: headers);
    print(jDecode(res.body));

    if (!isResponseOk(res)) {
      return emit(AgentProfileCommentRateErrorState());
    }

    emit(AgentProfileCommentRateSuccessState());
  }

  _onSendCommentAndRate(AgentProfileCommentRateSendCommentAndRateEvent event, Emitter<AgentProfileCommentRateState> emit) async {
    if (state is AgentProfileCommentRateSendingState) return;

    emit(AgentProfileCommentRateSendingState());
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
      return emit(AgentProfileCommentRateErrorState());
    }

    emit(AgentProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(commentRes.body)["data"])));
  }
}
