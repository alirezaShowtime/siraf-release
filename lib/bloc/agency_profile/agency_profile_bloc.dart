import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/estate_profile.dart';

part 'agency_profile_event.dart';

part 'agency_profile_state.dart';

class AgencyProfileBloc extends Bloc<AgencyProfileEvent, AgencyProfileState> {
  AgencyProfileBloc() : super(AgencyProfileInitial()) {
    on<AgencyProfileLoadingEvent>(_onLoading);
    on<AgencyProfileLoadEvent>(_onLoad);
  }

  _onLoad(AgencyProfileLoadEvent event, Emitter<AgencyProfileState> emit) async {
    if (state is AgencyProfileSuccessState) return;

    var res = await http2.get(Uri.parse("https://estate.siraf.app/api/estate/estate/${event.estateId}"));

    if (!isResponseOk(res)) {
      return emit(AgencyProfileErrorState(res));
    }
    emit(AgencyProfileSuccessState(EstateProfile.fromJson(jDecode(res.body)["data"])));
  }

  _onLoading(AgencyProfileLoadingEvent event, Emitter<AgencyProfileState> emit) async {
    emit(AgencyProfileInitial());
    add(AgencyProfileLoadEvent(event.estateId));
  }
}
