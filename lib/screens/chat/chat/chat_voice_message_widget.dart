import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/screens/chat/chat/my_audio_wave.dart';
import 'package:siraf3/themes.dart';

class ChatVoiceMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatVoiceMessageWidget();

  Key? key;
  ChatMessage message;
  late File? voice;
  bool isSeen;
  StreamController? onSeenMessageStream;
  void Function(ChatMessage? replyMessage)? onClickReplyMessage;

  ChatVoiceMessageWidget({
    this.key,
    required this.message,
    this.voice,
    this.isSeen = false,
    this.onClickReplyMessage,
  });
}

class _ChatVoiceMessageWidget extends State<ChatVoiceMessageWidget> {
  late ChatMessageConfig messageConfig;
  late bool hasFile;
  Duration? voiceDuration;
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    messageConfig = _getConfig();

    if (widget.voice?.path != null) {
      player.setSource(DeviceFileSource(widget.voice!.path));
    } else {
      player.setSource(UrlSource(widget.message.fileMessages![0].path!));
    }

    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayRegisterPlayerEvent(player));
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageConfig.alignment,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: widget.message.forMe ? TextDirection.rtl : TextDirection.ltr,
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
                replyWidget(widget.message.replyMessage),
                voiceWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.message.forMe)
                        Icon(
                          widget.isSeen ? Icons.done_all_rounded : Icons.check_rounded,
                          color: widget.isSeen ? Colors.white : Colors.white60,
                          size: 12,
                        ),
                      if (widget.message.forMe) SizedBox(width: 2),
                      Text(
                        widget.message.createDate ?? "",
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                BlocProvider.of<ChatReplyBloc>(context).add(ChatReplyEvent(widget.message));
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: icon(Icons.reply_rounded, size: 18, color: Themes.text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget voiceWidget() {
    return Container(
      padding: EdgeInsets.only(top: widget.message.replyMessage != null ? 0 : 9, left: 9, right: 9, bottom: 0),
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
                color: widget.message.forMe ? Colors.white : Themes.primary.withOpacity(.85),
              ),
              child: StreamBuilder<PlayerState>(
                stream: player.onPlayerStateChanged,
                builder: (context, snapshot) {
                  return Icon(
                    snapshot.data == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: widget.message.forMe ? Themes.primary : Colors.white,
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
    return widget.message.forMe ? _forMeConfig() : _forHerConfig();
  }

  ChatMessageConfig _forMeConfig() {
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

  ChatMessageConfig _forHerConfig() {
    return ChatMessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 0,
      brRadius: 18,
      fileNameColor: Colors.black,
      background: Color(0xfff0f0f0),
      textColor: Colors.black,
      primaryColor: Themes.primary,
      secondTextColor: Color(0xffb9c0c6),
      textDirection: TextDirection.rtl,
    );
  }

  Widget replyWidget(ChatMessage? replyMessage) {
    if (replyMessage == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onClickReplyMessage?.call(widget.message.replyMessage),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2.3,
                  decoration: BoxDecoration(
                    color: widget.message.forMe ? Colors.white : messageConfig.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      replyMessage.forMe ? "خودم" : "مشاور",
                      style: TextStyle(
                        color: widget.message.forMe ? Colors.white.withOpacity(0.85) : messageConfig.primaryColor,
                        fontSize: 10,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    Text(
                      replyMessage.message ?? "فایل",
                      style: TextStyle(
                        color: widget.message.forMe ? Colors.white60 : messageConfig.textColor,
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
