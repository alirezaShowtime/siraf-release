import 'dart:async';

import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/models/favorite_file.dart';

class BookmarkEvent {
  int? sort;

  BookmarkEvent({this.sort});
}

class BookmarkState {}

class BookmarkInitState extends BookmarkState {}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkLoadedState extends BookmarkState {
  List<FavoriteFile> data;

  BookmarkLoadedState({required this.data});
}

class BookmarkErrorState extends BookmarkState {
  Response response;

  BookmarkErrorState({required this.response});
}

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkInitState()) {
    on(_onEvent);
  }

  _onEvent(BookmarkEvent event, Emitter<BookmarkState> emit) async {
    emit(BookmarkLoadingState());

    var response = await http2.getWithToken(
        getFileUrl("file/getFileFavorite/")); // todo implement sort

    print(response.statusCode);

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      emit(
        BookmarkLoadedState(
          data: FavoriteFile.fromList(json['data']),
        ),
      );
    } else {
      emit(BookmarkErrorState(response: response));
    }
  }
}
