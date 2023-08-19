import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersionEvent {}

class CheckVersionState {}

class CheckVersionInitState extends CheckVersionState {}

class CheckVersionLoadingState extends CheckVersionState {}

class CheckVersionSuccessState extends CheckVersionState {
  bool hasUpdate;
  String downloadUrl;
  bool isRequired;

  CheckVersionSuccessState({required this.hasUpdate, required this.downloadUrl, required this.isRequired});
}

class CheckVersionErrorState extends CheckVersionState {
  Response response;

  CheckVersionErrorState({required this.response});
}

class CheckVersionBloc extends Bloc<CheckVersionEvent, CheckVersionState> {
  CheckVersionBloc() : super(CheckVersionInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    emit(CheckVersionLoadingState());

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;

    var response = await http2.get(
      Uri.parse(
        "https://auth.siraf.app/api/application/version?type=1&platform=" + (Platform.isAndroid ? "0" : "1"),
      ),
    );

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var appV = int.parse(buildNumber);
      var lastV = int.parse(json['data']['version'].toString());

      print("appV $appV");
      print("lastV $lastV");

      emit(
        CheckVersionSuccessState(
          hasUpdate: lastV > appV,
          downloadUrl: json['data']['path'].toString(),
          isRequired: json['data']['require'],
        ),
      );
    } else {
      emit(CheckVersionErrorState(response: response));
    }
  }
}
