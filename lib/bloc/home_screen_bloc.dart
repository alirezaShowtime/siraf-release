import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/home_item.dart';
import 'package:siraf3/models/post.dart';
import 'package:siraf3/models/user.dart';

class HSEvent {}

class HSLoadEvent extends HSEvent {
  FilterData filterData;
  int lastId;
  int? contentLastId;

  HSLoadEvent({required this.filterData, this.lastId = 0, this.contentLastId});
}

class HSState {}

class HSInitState extends HSState {}

class HSLoadingState extends HSState {}

class HSLoadedState extends HSState {
  List<HomeItem> homeItems;
  int? lastId;
  int? contentLastId;

  HSLoadedState({required this.homeItems, this.lastId, this.contentLastId});
}

class HSErrorState extends HSState {
  Response? response;

  HSErrorState({required this.response});
}

class HSBloc extends Bloc<HSEvent, HSState> {
  HSBloc() : super(HSInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is HSLoadEvent) {
      emit(HSLoadingState());

      var files = <File>[];
      int filesLength = 0;
      var posts = <Post>[];
      int postsLength = 0;
      int? files_new_last_id;
      int? posts_new_last_id;

      Response responseFiles = await handleFileRequest(event);
      Response responseContent = await handleContentRequest(event);

      if (is401(responseFiles)) {
        User.remove();
        responseFiles = await handleFileRequest(event, withToken: false);
      }
      if (is401(responseContent)) {
        User.remove();
        responseContent = await handleContentRequest(event, withToken: false);
      }

      if (!isResponseOk(responseFiles)) {
        emit(HSErrorState(response: responseFiles));
        return;
      }

      if (isResponseOk(responseFiles)) {
        var json = jDecode(responseFiles.body);
        files = File.fromList(json['data']['files']);
        filesLength = files.length;
        files_new_last_id = json['data']["lastId"] as int?;
      }

      if (isResponseOk(responseContent)) {
        var json = jDecode(responseContent.body);
        posts = Post.fromList(json['data']);
        postsLength = posts.length;
        posts_new_last_id = posts.length > 0 ? posts.last.id : null;
      }

      print("FILES LENGTH : ${files.length}");
      print("POSTS LENGTH : ${posts.length}");

      var items = <HomeItem>[];

      if (filesLength > 0 && postsLength > 0) {
        items = combainFilesWithPosts(files, posts);
      }

      if (postsLength == 0 && filesLength > 0) {
        items = files.map((e) => HomeItem(type: Type.File, file: e)).toList();
      }

      if (filesLength == 0 && postsLength > 0) {
        items = posts.map((e) => HomeItem(type: Type.Post, post: e)).toList();
      }

      emit(HSLoadedState(
        homeItems: items,
        lastId: files_new_last_id,
        contentLastId: posts_new_last_id,
      ));
    }
  }

  List<HomeItem> combainFilesWithPosts(List<File> files, List<Post> posts) {
    List<HomeItem> items = [];

    var pCount = posts.length;

    var count = files.length ~/ pCount;

    if (count == 0)
      return files.map((e) => HomeItem(type: Type.File, file: e)).toList() + posts.map((e) => HomeItem(type: Type.Post, post: e)).toList();

    if (count == 1)
      return files.map((e) => HomeItem(type: Type.File, file: e)).toList() + posts.map((e) => HomeItem(type: Type.Post, post: e)).toList();
      
    if (count == 2)
      return files.map((e) => HomeItem(type: Type.File, file: e)).toList() + posts.map((e) => HomeItem(type: Type.Post, post: e)).toList();

    var random = Random();

    var countFinal = files.length + posts.length;

    for (int o = 0; files.isNotEmpty; o++) {
      var rand = 2 + random.nextInt(count - 2);

      for (int i = 0; i < rand; i++) {
        if (!files.asMap().containsKey(i)) continue;
        if (items.length == countFinal) break;
        items.add(HomeItem(type: Type.File, file: files[i]));
      }
      for (int i = 0; i < rand; i++) {
        if (!files.asMap().containsKey(i)) continue;
        files.removeAt(i);
      }

      if (posts.asMap().containsKey(o)) {
        items.add(HomeItem(type: Type.Post, post: posts[o]));
      }
    }

    print(items);

    return items;
  }

  Future<Response> handleFileRequest(HSLoadEvent event,
      {bool withToken = true}) async {
    var url = getFileUrl('file/files/' +
        event.filterData.toQueryString() +
        '&lastId=' +
        event.lastId.toString() + "&progress=7");

    if (!withToken) {
      return await http2.get(url, timeout: Duration(seconds: 60));
    }

    if (!await User.hasToken()) {
      return await http2.get(url, timeout: Duration(seconds: 60));
    }

    return await http2.getWithToken(url, timeout: Duration(seconds: 60));
  }

  Future<Response> handleContentRequest(HSLoadEvent event,
      {bool withToken = true}) async {
    var contentLastId =
        event.contentLastId != null ? "&last_id=${event.contentLastId}" : "";

    var url = getContentUrl('content/contents/?userType=1&count=3' + contentLastId);

    if (!withToken) {
      return await http2.get(url, timeout: Duration(seconds: 60));
    }

    if (!await User.hasToken()) {
      return await http2.get(url, timeout: Duration(seconds: 60));
    }

    return await http2.getWithToken(url, timeout: Duration(seconds: 60));
  }
}
