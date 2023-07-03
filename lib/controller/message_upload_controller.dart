import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_message_widget.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_voice_message_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/sending_message_widget.dart';

class MessageUploadController {
  void Function()? onCancelUpload;
  var _messageWidget;

  MessageUploadController();

  void setSendingMessageWidgetState(SendingMessageWidgetState messageWidget) {
    this._messageWidget = messageWidget;
  }

  void setChatSendingMessageWidgetState(ChatSendingMessageWidgetState messageWidget) {
    this._messageWidget = messageWidget;
  }

  void setChatSendingVoiceMessageWidgetState(ChatSendingVoiceMessageWidgetState messageWidget) {
    this._messageWidget = messageWidget;
  }

  void uploading(int now, int count) {
    _messageWidget!.setUploadingProgress(now.toDouble(), count.toDouble());
    _messageWidget!.messageState = MessageState.Uploading;
  }

  void uploaded() {
    _messageWidget!.messageState = MessageState.Uploaded;
  }

  void errorUpload() {
    _messageWidget!.messageState = MessageState.ErrorUpload;
  }

  void setOnCancelUpload(Function()? onCancelUpload) {
    this.onCancelUpload = onCancelUpload;
  }

  void cancelUpload() {
    _messageWidget!.messageState = MessageState.Init;
    this.onCancelUpload?.call();
  }
}
