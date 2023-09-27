import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:http/http.dart';
import 'package:siraf3/models/filter_data.dart';

class TotalFileGetEvent {
  FilterData filterData;
  bool withToken;

  TotalFileGetEvent({required this.filterData, this.withToken = false});
}

class TotalFileState {}

class TotalFileInitState extends TotalFileState {}

class TotalFileLoadingState extends TotalFileState {}

class TotalFileLoadedState extends TotalFileState {
  int totalCount;

  TotalFileLoadedState({required this.totalCount});
}

class TotalFileErrorState extends TotalFileState {
  Response response;

  TotalFileErrorState({required this.response});
}

class TotalFileBloc extends Bloc<TotalFileGetEvent, TotalFileState> {
  String url;
  
  TotalFileBloc({required this.url}) : super(TotalFileInitState()) {
    on(_onEvent);
  }

  _onEvent(TotalFileGetEvent event, emit) async {
    emit(TotalFileLoadingState());

    var newUrl = Uri.parse(url + event.filterData.toQueryString() + "&total=true");

    var response =
        await (event.withToken ? http2.getWithToken(newUrl) : http2.get(newUrl));

    if (isResponseOk(response)) {
      emit(
        TotalFileLoadedState(
          totalCount: jDecode(response.body)['data']['totalCount'] as int,
        ),
      );
    } else {
      emit(TotalFileErrorState(response: response));
    }
  }
}
