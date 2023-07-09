import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/estate_profile.dart';

part 'agency_profile_event.dart';
part 'agency_profile_state.dart';

class EstateProfileBloc extends Bloc<EstateProfileEvent, EstateProfileState> {
  EstateProfileBloc() : super(EstateProfileInitial()) {
    on<EstateProfileLoadingEvent>(_onLoading);
    on<EstateProfileLoadEvent>(_onLoad);
  }

  _onLoad(EstateProfileLoadEvent event, Emitter<EstateProfileState> emit) async {
    if (state is EstateProfileSuccessState) return;

    var res = await http2.get(Uri.parse("https://estate.siraf.app/api/estate/estate/${event.estateId}"));

    if (!isResponseOk(res)) {
      return emit(EstateProfileErrorState(res));
    }
    emit(EstateProfileSuccessState(EstateProfile.fromJson(jDecode(res.body)["data"])));
  }

  _onLoading(EstateProfileLoadingEvent event, Emitter<EstateProfileState> emit) async {
    emit(EstateProfileInitial());
    add(EstateProfileLoadEvent(event.estateId));
  }
}
