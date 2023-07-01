import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/themes.dart';

import 'my_audio_wave.dart';

class ChatSendingVoiceMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatSendingVoiceMessageWidgetState();

  String voicePath;
  ChatMessage? replyMessage;
  MessageUploadController controller;
  void Function(ChatMessage replyMessage)? onClickReplyMessage;

  ChatSendingVoiceMessageWidget({
    super.key,
    required this.voicePath,
    required this.controller,
    this.replyMessage,
    this.onClickReplyMessage,
  });
}

class ChatSendingVoiceMessageWidgetState extends State<ChatSendingVoiceMessageWidget> with SingleTickerProviderStateMixin {
  late AnimationController loadingController;

  late ChatMessageConfig messageConfig;
  final DateTime now = DateTime.now();
  late File file;
  late bool hasFile;
  AudioPlayer player = AudioPlayer();
  Duration? voiceDuration;

  MessageState _messageState = MessageState.Uploading;

  MessageState get messageState => _messageState;

  void set messageState(MessageState messageState) {
    _messageState = messageState;
    setState(() {});
  }

  double nowUploadingProgress = 0;
  double countUploadingProgress = 0.1;

  double get percentUploading => (nowUploadingProgress / countUploadingProgress);

  void setUploadingProgress(double nowUploadingProgress, double countUploadingProgress) {
    this.nowUploadingProgress = nowUploadingProgress;
    this.countUploadingProgress = countUploadingProgress;
  }

  @override
  void initState() {
    super.initState();

    player.setSource(UrlSource(widget.voicePath));

    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayRegisterPlayerEvent(player));


    loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

    messageConfig = _getConfig();

    widget.controller.setChatSendingVoiceMessageWidgetState(this);
  }

  @override
  void dispose() {
    loadingController.dispose();
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageConfig.alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: messageConfig.background,
              borderRadius: messageConfig.borderRadius,
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.60, minWidth: 100),
            margin: EdgeInsets.only(bottom: 3, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                replyWidget(widget.replyMessage),
                voiceWidget(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (messageState == MessageState.Uploading)
                      Icon(
                        Icons.access_time_rounded,
                        color: messageConfig.secondTextColor,
                        size: 13,
                      ),
                    if (messageState == MessageState.ErrorUpload)
                      Icon(
                        Icons.error_outline_rounded,
                        color: messageConfig.secondTextColor,
                        size: 13,
                      ),
                    SizedBox(width: 2),
                    Text(
                      "${now.hour}:${now.minute}",
                      style: TextStyle(
                        color: messageConfig.secondTextColor,
                        fontSize: 9,
                        height: 1,
                        fontFamily: "sans-serif",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget voiceWidget() {
    return Container(
      padding: EdgeInsets.only(top: widget.replyMessage != null ? 0 : 9, left: 9, right: 9, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              StreamBuilder<Duration?>(
                stream: player.onPositionChanged,
                builder: (context, snapshot) {
                  if ((voiceDuration?.inSeconds ?? 0) == 0 || (snapshot.data?.inSeconds ?? 0) == 0) {
                    return MyAudioWave(
                      progress: 0,
                      barColor: messageConfig.secondTextColor,
                      activeBarColor: messageConfig.primaryColor,
                    );
                  }
                  double percent = (snapshot.data!.inSeconds / voiceDuration!.inSeconds);
                  return MyAudioWave(
                    progress: percent,
                    barColor: messageConfig.secondTextColor,
                    activeBarColor: messageConfig.primaryColor,
                  );
                },
              ),
              SizedBox(height: 5),
              StreamBuilder<Duration?>(
                stream: player.onPositionChanged,
                builder: (context, snapshot) {
                  var time = "00:00";
                  if ((voiceDuration?.inSeconds ?? 0) != 0 && (snapshot.data?.inSeconds ?? 0) != 0) {
                    time = timeFormatter(voiceDuration!.inSeconds - snapshot.data!.inSeconds);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 7, color: messageConfig.primaryColor),
                      SizedBox(width: 2),
                      Text(
                        time,
                        style: TextStyle(
                          height: 1,
                          fontSize: 10,
                          fontFamily: "sans-serif",
                          fontWeight: FontWeight.w500,
                          color: messageConfig.secondTextColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          InkWell(
            onTap: playVoice,
            child: Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.only(right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: messageConfig.primaryColor,
              ),
              child: StreamBuilder<PlayerState>(
                stream: player.onPlayerStateChanged,
                builder: (_, snapshot) {
                  return Icon(
                    color: Themes.primary,
                    snapshot.data == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ChatMessageConfig _getConfig() {
    return ChatMessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 18,
      brRadius: 0,
      fileNameColor: Colors.white,
      background: Themes.primary.withOpacity(0.9),
      textColor: Colors.white,
      primaryColor: Colors.white,
      secondTextColor: Colors.white60,
      textDirection: TextDirection.ltr,
    );
  }

  Widget replyWidget(ChatMessage? replyMessage) {
    if (replyMessage == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onClickReplyMessage?.call(replyMessage),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      replyMessage.forMe ? "خودم" : "مشاور",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 10,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    Text(
                      replyMessage.message!,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void playVoice() async {
    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayPlayOrStop(player));

    if (voiceDuration == null) {
      voiceDuration = await player.getDuration();
    }
  }
}
