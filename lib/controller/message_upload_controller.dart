import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/screens/ticket/ticket_chat/sending_message_widget.dart';

class MessageUploadController {
  void Function()? onCancelUpload;
  SendingMessageWidgetState? messageWidget;

  MessageUploadController();

  void setSendingMessageWidgetState(SendingMessageWidgetState messageWidget) {
    this.messageWidget = messageWidget;
  }

  void uploading(int now, int count) {
    messageWidget!.setUploadingProgress(now.toDouble(), count.toDouble());
    messageWidget!.messageState = MessageState.Uploading;
  }

  void uploaded() {
    messageWidget!.messageState = MessageState.Uploaded;
  }

  void errorUpload() {
    messageWidget!.messageState = MessageState.ErrorUpload;
  }

  void setOnCancelUpload(Function()? onCancelUpload) {
    this.onCancelUpload = onCancelUpload;
  }

  void cancelUpload() {
    messageWidget!.messageState = MessageState.Init;
    this.onCancelUpload?.call();
  }
}
