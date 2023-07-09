import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'estate_profile_comment_rate_event.dart';

part 'estate_profile_comment_rate_state.dart';

class EstateProfileCommentRateBloc extends Bloc<EstateProfileCommentRateEvent, EstateProfileCommentRateState> {
  EstateProfileCommentRateBloc() : super(EstateProfileCommentRateInitialState()) {
    on<EstateProfileCommentRateSendCommentEvent>(_onSendComment);
    on<EstateProfileCommentRateSendRateEvent>(_onSendRate);
    on<EstateProfileCommentRateSendCommentAndRateEvent>(_onSendCommentAndRate);
  }

  _onSendComment(EstateProfileCommentRateSendCommentEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSendingState) return;

    emit(EstateProfileCommentRateSendingState());
    var body = {"comment": event.message, "estate_id": event.estateId.toString()};

    var headers = {
      "Authorization": await User.getBearerToken(),
      "Content-Type": "application/json",
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"), body: body, headers: headers);
    if (!isResponseOk(res)) {
      print(res.body);
      return emit(EstateProfileCommentRateErrorState());
    }

    emit(EstateProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(res.body)["data"])));
  }

  _onSendRate(EstateProfileCommentRateSendRateEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSendingState) return;

    emit(EstateProfileCommentRateSendingState());

    var body = {"rate": event.rate, "estate_id": event.estateId};

    var headers = {
      "Authorization": await User.getBearerToken(),
      "Content-Type": "application/json",
    };

    var res = await http2.post(Uri.parse("https://rate.siraf.app/api/rate/addRateEstate/"), body: jsonEncode(body), headers: headers);

    if (!isResponseOk(res)) {
      return emit(EstateProfileCommentRateErrorState());
    }

    emit(EstateProfileCommentRateSuccessState());
  }

  _onSendCommentAndRate(EstateProfileCommentRateSendCommentAndRateEvent event, Emitter<EstateProfileCommentRateState> emit) async {
    if (state is EstateProfileCommentRateSendingState) return;

    emit(EstateProfileCommentRateSendingState());
    var commentBody = {"comment": event.message, "estate_id": event.estateId};

    var rateBody = {"rate": event.rate, "estate_id": event.estateId};

    var commentRes = await http2.postJsonWithToken(Uri.parse("https://rate.siraf.app/api/comment/addCommentEstate/"), body: commentBody);
    var rateRes = await http2.postJsonWithToken(Uri.parse("https://rate.siraf.app/api/rate/addRateEstate/"), body: rateBody);

    if (!isResponseOk(rateRes) || !isResponseOk(commentRes)) {
      return emit(EstateProfileCommentRateErrorState());
    }

    emit(EstateProfileCommentRateSuccessState(comment: Comment.fromJson(jDecode(commentRes.body)["data"])));
  }
}
