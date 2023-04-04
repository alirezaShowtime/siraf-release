import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/user.dart';

part 'agent_profile_event.dart';
part 'agent_profile_state.dart';

class AgentProfileBloc extends Bloc<AgentProfileEvent, AgentProfileState> {
  AgentProfileBloc() : super(AgentProfileInitState()) {
    on<AgentProfileLoad>(_onLoadAgentProfile);
    on<AgentProfileSendComment>(_onSendCommentAgentProfile);
    on<AgentProfileSendRate>(_onSendRateAgentProfile);
  }

  _onLoadAgentProfile(AgentProfileLoad event, Emitter<AgentProfileState> emit) async {
    if (state is AgentProfileSuccessState) return;

    var res = await http2.get(getEstateUrl("consultant/consultantInfo?consultantId=${event.consultantId}"));

    if (!isResponseOk(res)) return emit(AgentProfileErrorState(res));

    var json = jDecode(res.body);

    print(json);
    emit(AgentProfileSuccessState(ConsultantInfo.fromJson(json["data"])));
  }

  _onSendRateAgentProfile(AgentProfileSendRate event, Emitter<AgentProfileState> emit) async {
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
      return emit(AgentProfileErrorState(res));
    }
    //todo: emit
  }

  _onSendCommentAgentProfile(AgentProfileSendComment event, Emitter<AgentProfileState> emit) {}
}
