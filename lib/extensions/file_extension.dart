import 'dart:io';

import 'package:siraf3/extensions/int_extension.dart';

extension File2 on File {
  String get fileName => this.path.split('/').last;

  String get extension => fileName.split(".").last.toUpperCase();

  bool get isVideo => ["mp4", "mkv"].contains(extension.toLowerCase());

  bool get isImage => ["png", "jpg"].contains(extension.toLowerCase());

  bool get isVoice => ["mp3"].contains(extension.toLowerCase());

  Future<String> lengthStr() async {
    return (await this.length()).toFileSize();
  }
}
