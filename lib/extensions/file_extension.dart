import 'dart:io';

import 'package:siraf3/extensions/int_extension.dart';

extension File2 on File {
  String get fileName => this.path.split('/').last;

  String get extension => fileName.split(".").last.toUpperCase();

  String lengthStr() => this.lengthSync().toFileSize();
}
