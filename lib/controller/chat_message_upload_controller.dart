import 'dart:async';

import 'package:siraf3/enums/message_state.dart';

class UploadingDetail {
  int uploaded;
  int count;
  late double percent;
  late String percentStr;

  UploadingDetail(this.uploaded, this.count) {
    percent = uploaded == 0 || count == 0 ? 0 : uploaded / count;
    percentStr = "${percent.toInt()}%";
  }
}

class ChatMessageUploadController {
  void Function()? onCancelUpload;
  StreamController<MessageState> messageSate = StreamController();
  StreamController<UploadingDetail> uploading = StreamController();
  String? _createTime;

  void setOnCancelUpload(Function()? onCancelUpload) {
    this.onCancelUpload = onCancelUpload;
  }

  String? getCreateTime() {
    return _createTime;
  }

  String setCreateTime(DateTime time) {
    return "${time.hour}:${time.minute}";
  }

  void cancelUpload() {
    messageSate.add(MessageState.Init);
    this.onCancelUpload?.call();
  }
}
