import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/group.dart';

part 'get_groups_event.dart';

part 'get_groups_state.dart';

class GetGroupsBloc extends Bloc<GetGroupsEvent, GetGroupsState> {
  GetGroupsBloc() : super(GetGroupsInitState()) {
    on<GetGroupsRequestEvent>(_request);
  }

  FutureOr<void> _request(GetGroupsRequestEvent event, Emitter<GetGroupsState> emit) async {
    emit(GetGroupsLoading());

    emit(GetGroupsSuccess(groups: await GroupModel.getList()));
  }
}
