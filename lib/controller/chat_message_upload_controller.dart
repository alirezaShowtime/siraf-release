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
  StreamController<MessageState> messageSate = StreamController.broadcast();
  StreamController<UploadingDetail> uploading = StreamController.broadcast();

  void setOnCancelUpload(Function()? onCancelUpload) {
    this.onCancelUpload = onCancelUpload;
  }

  void cancelUpload() {
    messageSate.add(MessageState.Init);
    this.onCancelUpload?.call();
  }
}
