import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/estate_profile.dart';

part 'estate_profile_event.dart';
part 'estate_profile_state.dart';

class EstateProfileBloc extends Bloc<EstateProfileEvent, EstateProfileState> {
  EstateProfileBloc() : super(EstateProfileInitial()) {
    on<EstateProfileRequestEvent>(_request);
  }

  _request(EstateProfileRequestEvent event, Emitter<EstateProfileState> emit) async {
    if (state is EstateProfileSuccessState) return;
    emit(EstateProfileLoading());

    var res = await http2.get(Uri.parse("https://estate.siraf.app/api/estate/estate/${event.estateId}"));

    if (!isResponseOk(res)) {
      return emit(EstateProfileErrorState(res));
    }
    return emit(EstateProfileSuccessState(EstateProfile.fromJson(jDecode(res.body)["data"])));
  }
}
