import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/post.dart';
import 'package:http/http.dart';

class PostsEvent {
  String? search;
  String? sort;
  int? lastId;

  PostsEvent({this.search, this.sort, this.lastId});
}

class PostsState {}

class PostsInitState extends PostsState {}

class PostsLoadingState extends PostsState {}

class PostsLoadedState extends PostsState {
  int? lastId;
  List<Post> posts;

  PostsLoadedState({required this.posts, this.lastId});
}

class PostsErrorState extends PostsState {
  Response response;

  PostsErrorState({required this.response});
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitState()) {
    on(_onEvent);
  }

  _onEvent(PostsEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoadingState());

    var endPoint = "content/contents/";

    endPoint += getUrlDelimiter(endPoint) + "userType=1";

    if (event.search.isFill()) {
      endPoint += getUrlDelimiter(endPoint) + "key=${event.search}";
    }
    if (event.sort.isFill()) {
      endPoint += getUrlDelimiter(endPoint) + "sort=${event.sort}";
    }

    var lastId = event.lastId != null ? "last_id=${(event.lastId ?? 0)}" : "";

    endPoint += getUrlDelimiter(endPoint) + lastId;

    var response = await http2.getWithToken(getContentUrl(endPoint));

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var posts = Post.fromList(json['data']);

      emit(
        PostsLoadedState(
          posts: posts,
          lastId: posts.length > 0 ? posts.last.id : null,
        ),
      );
    } else {
      emit(PostsErrorState(response: response));
    }
  }
}
