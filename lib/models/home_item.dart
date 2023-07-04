import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/post.dart';

class HomeItem {
  Type type;
  File? file;
  Post? post;

  HomeItem({
    required this.type,
    this.file,
    this.post,
  });
}

enum Type { File, Post }
