import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/consultant_info.dart';

part 'consultant_profile_event.dart';
part 'consultant_profile_state.dart';

class ConsultantProfileBloc extends Bloc<ConsultantProfileEvent, ConsultantProfileState> {
  ConsultantProfileBloc() : super(ConsultantProfileInitState()) {
    on<ConsultantProfileRequestEvent>(_request);
  }

  _request(ConsultantProfileRequestEvent event, Emitter<ConsultantProfileState> emit) async {
    if (state is ConsultantProfileSuccessState) return;

    var res = await http2.get(getEstateUrl("consultant/consultantInfo?consultantId=${event.consultantId}"));

    if (!isResponseOk(res)) return emit(ConsultantProfileErrorState(res));

    var json = jDecode(res.body);

    print(json);
    emit(ConsultantProfileSuccessState(ConsultantInfo.fromJson(json["data"])));
  }
}
