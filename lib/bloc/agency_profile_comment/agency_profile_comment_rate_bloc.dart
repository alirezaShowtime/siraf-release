import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'agency_profile_comment_rate_event.dart';

part 'agency_profile_comment_rate_state.dart';

class AgencyProfileCommentRateBloc extends Bloc<AgencyProfileCommentRateEvent, AgencyProfileCommentRateState> {
  AgencyProfileCommentRateBloc() : super(AgencyProfileCommentRateInitialState()) {
    on<AgencyProfileCommentRateSendCommentEvent>(_onSendComment);
    on<AgencyProfileCommentRateSendRateEvent>(_onSendRate);
    on<AgencyProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(AgencyProfileCommentRateSendCommentEvent event, Emitter<AgencyProfileCommentRateState> emit) async {
    if (state is AgencyProfileCommentRateSendingState) return;

    emit(AgencyProfileCommentRateSendingState());
    var body = {"comment": event.message, "estate_id": event.estateId.toString()};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"), body: body, headers: headers);
    if (!isResponseOk(res)) {
      print(res.body);
      return emit(AgencyProfileCommentRateErrorState());
    }

    emit(AgencyProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(res.body)["data"])));
  }

  _onSendRate(AgencyProfileCommentRateSendRateEvent event, Emitter<AgencyProfileCommentRateState> emit) async {
    if (state is AgencyProfileCommentRateSendingState) return;

    emit(AgencyProfileCommentRateSendingState());

    var body = {"rate": event.rate, "estate_id": event.estateId};

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.ap/api/rate/addRateEstate/"), body: body, headers: headers);
    print(jDecode(res.body));

    if (!isResponseOk(res)) {
      return emit(AgencyProfileCommentRateErrorState());
    }

    emit(AgencyProfileCommentRateSuccessState());
  }

  _onSendCommentAndRate(AgencyProfileCommentRateSendCommentAndRateEvent event, Emitter<AgencyProfileCommentRateState> emit) async {
    if (state is AgencyProfileCommentRateSendingState) return;

    emit(AgencyProfileCommentRateSendingState());
    var commentBody = {"comment": event.message, "estate_id": event.estateId};

    var commentHeaders = {
      "Authorization": await User.getBearerToken(),
    };

    var rateBody = {"rate": event.rate, "estate_id": event.estateId};

    var rateHeaders = {
      "Authorization": await User.getBearerToken(),
    };

    var commentRes = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"), body: commentBody, headers: commentHeaders);
    var rateRes = await http2.post(Uri.parse("https://rate.siraf.ap/api/rate/addRateEstate/"), body: rateBody, headers: rateHeaders);

    if (!isResponseOk(rateRes) || !isResponseOk(commentRes)) {
      return emit(AgencyProfileCommentRateErrorState());
    }

    emit(AgencyProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(commentRes.body)["data"])));
  }
}
