import 'package:siraf3/extensions/string_extension.dart';

extension Uri2 on Uri {
  String? getFileName() {
    var regex = RegExp(r"^.*\/(.*)\.(.*)\?.*$");

    if (!regex.hasMatch(this.toString())) return null;

    var name = regex.firstMatch(this.toString())?.group(1);
    var extension = regex.firstMatch(this.toString())?.group(2);

    if (!name.isFill() || !extension.isFill()) return null;

    return "${name}.${extension}";
  }
}
