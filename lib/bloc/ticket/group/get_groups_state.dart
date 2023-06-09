part of 'get_groups_bloc.dart';

@immutable
abstract class GetGroupsState {}

class GetGroupsInitState extends GetGroupsState {}

class GetGroupsLoading extends GetGroupsState {}

class GetGroupsSuccess extends GetGroupsState {
  List<GroupModel> groups;

  GetGroupsSuccess({required this.groups});
}

class GetGroupsError extends GetGroupsState {
  Response response;

  String? message;

  GetGroupsError({required this.response}) {
    message = response.statusCode < 500 ? jDecode(response.body)['message'] : null;
  }
}
