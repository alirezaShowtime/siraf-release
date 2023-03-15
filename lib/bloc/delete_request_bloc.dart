import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

class DeleteRequestEvent {
  List<int> ids;

  DeleteRequestEvent({required this.ids});
}

class DeleteRequestState {}

class DeleteRequestInitState extends DeleteRequestState {}

class DeleteRequestLoadingState extends DeleteRequestState {}

class DeleteRequestSuccessState extends DeleteRequestState {
  DeleteRequestEvent event;

  DeleteRequestSuccessState({required this.event});
}

class DeleteRequestErrorState extends DeleteRequestState {
  Response response;
  DeleteRequestEvent event;

  DeleteRequestErrorState({required this.response, required this.event});
}

class DeleteRequestBloc extends Bloc<DeleteRequestEvent, DeleteRequestState> {
  DeleteRequestBloc() : super(DeleteRequestInitState()) {
    on(_onEvent);
  }

  _onEvent(DeleteRequestEvent event, Emitter<DeleteRequestState> emit) async {
    emit(DeleteRequestLoadingState());

    var response = await http2.postJsonWithToken(
      getEstateUrl("requestFile/deleteRequestFiles/"),
      body: {
        "requestIds": event.ids,
      },
    );

    if (isResponseOk(response)) {
      emit(DeleteRequestSuccessState(event: event));
    } else {
      emit(DeleteRequestErrorState(
        response: response,
        event: event,
      ));
    }
  }
}
