import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'consultant_profile_event.dart';

part 'consultant_profile_state.dart';

class ConsultantProfileBloc extends Bloc<ConsultantProfileEvent, ConsultantProfileState> {
  ConsultantProfileBloc() : super(ConsultantProfileInitState()) {
    on<ConsultantProfileLoad>(_onLoadConsultantProfile);
    on<ConsultantProfileSendComment>(_onSendCommentConsultantProfile);
    on<ConsultantProfileSendRate>(_onSendRateConsultantProfile);
  }

  _onLoadConsultantProfile(ConsultantProfileLoad event, Emitter<ConsultantProfileState> emit) async {
    if (state is ConsultantProfileSuccessState) return;

    var res = await http2.get(getEstateUrl("consultant/consultantInfo?consultantId=${event.consultantId}"));

    if (!isResponseOk(res)) return emit(ConsultantProfileErrorState(res));

    var json = jDecode(res.body);

    print(json);
    emit(ConsultantProfileSuccessState(ConsultantInfo.fromJson(json["data"])));
  }

  _onSendRateConsultantProfile(ConsultantProfileSendRate event, Emitter<ConsultantProfileState> emit) async {
    Object body = {
      "rate": event.rate,
      "consultants_id": event.consultantId,
    };

    Map<String, String> headers = {
      "Authorization": await User.getBearerToken(),
    };

    var res = await http2.post(
      Uri.parse("https://rate.siraf.app/api/rate/addRateConsultant/"),
      body: body,
      headers: headers,
    );

    if (!isResponseOk(res)) {
      if (res.statusCode == 401) {
        //todo: navigate to login page
      }
      return emit(ConsultantProfileErrorState(res));
    }
    //todo: emit
  }

  _onSendCommentConsultantProfile(ConsultantProfileSendComment event, Emitter<ConsultantProfileState> emit) {}
}
