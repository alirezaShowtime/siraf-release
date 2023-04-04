import 'dart:async';

import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/group.dart';

class GetGroupsEvent {}

class GetGroupsState {}

class GetGroupsInitState extends GetGroupsState {}

class GetGroupsLoadingState extends GetGroupsState {}

class GetGroupsLoadedState extends GetGroupsState {
  List<Group> groups;

  GetGroupsLoadedState({required this.groups});
}

class GetGroupsErrorState extends GetGroupsState {
  Response response;

  GetGroupsErrorState({required this.response});
}

class GetGroupsBloc extends Bloc<GetGroupsEvent, GetGroupsState> {
  GetGroupsBloc() : super(GetGroupsInitState()) {
    on(_onEvent);
  }

  _onEvent(GetGroupsEvent event, Emitter<GetGroupsState> emit) async {
    emit(GetGroupsLoadingState());

    // var response = await http2.get(getTicketUrl("group/groups/"));

    // if (isResponseOk(response)) {
    //   var json = jDecode(response.body);
    //   emit(
    //     GetGroupsLoadedState(
    //       groups: Group.fromList(json['data']),
    //     ),
    //   );
    // } else {
    //   emit(GetGroupsErrorState(response: response));
    // }

    emit(
      GetGroupsLoadedState(groups: await Group.getList()),
    );
  }
}
