import 'dart:convert';

import 'package:siraf3/helpers.dart';
import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';

class PostBookmarkEvent {}

class PostBookmarkAddEvent extends PostBookmarkEvent {
  int id;
  PostBookmarkAddEvent({required this.id});
}

class PostBookmarkRemoveEvent extends PostBookmarkEvent {
  int id;
  PostBookmarkRemoveEvent({required this.id});
}

class PostBookmarkState {}

class PostBookmarkInitState extends PostBookmarkState {}

class PostBookmarkLoadingState extends PostBookmarkState {}

class PostBookmarkSuccessState extends PostBookmarkState {
  bool bookmark;

  PostBookmarkSuccessState({required this.bookmark});
}

class PostBookmarkErrorState extends PostBookmarkState {
  Response response;

  PostBookmarkErrorState({required this.response});
}

class PostBookmarkBloc extends Bloc<PostBookmarkEvent, PostBookmarkState> {
  PostBookmarkBloc() : super(PostBookmarkInitState()) {
    on(_onEvent);
  }

  _onEvent(PostBookmarkEvent event, Emitter<PostBookmarkState> emit) async {
    if (event is PostBookmarkAddEvent) {
      emit(PostBookmarkLoadingState());

      var response = await http2.postJsonWithToken(
        getContentUrl("bookmark/bookmark/"),
        body: {
          "content_id": event.id,
        },
      );

      if (isResponseOk(response)) {
        emit(PostBookmarkSuccessState(bookmark: true));
      } else {
        emit(PostBookmarkErrorState(response: response));
      }
    } else if (event is PostBookmarkRemoveEvent) {
      emit(PostBookmarkLoadingState());

      var response = await http2.deleteWithToken(
        getContentUrl("bookmark/deleteBookmark/?bookmarkIds=[${event.id}]"));

      if (isResponseOk(response)) {
        emit(PostBookmarkSuccessState(bookmark: false));
      } else {
        emit(PostBookmarkErrorState(response: response));
      }
    }
  }
}
