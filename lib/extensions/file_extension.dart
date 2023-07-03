import 'dart:io';

import 'package:siraf3/extensions/int_extension.dart';

extension File2 on File {
  String get fileName => this.path.split('/').last;

  String get extension => fileName.split(".").last.toUpperCase();

  bool get isVideo => ["mp4", "mkv"].contains(extension.toLowerCase());

  bool get isImage => ["png", "jpg"].contains(extension.toLowerCase());

  //todo voice
  bool get isVoice => false;

  String lengthStr() => this.lengthSync().toFileSize();
}
