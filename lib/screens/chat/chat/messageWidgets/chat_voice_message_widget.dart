import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/screens/chat/chat/my_audio_wave.dart';
import 'package:siraf3/themes.dart';

import 'chat_message_widget.dart';

class ChatVoiceMessageWidgetState extends ChatMessageWidgetState {
  late ChatMessageConfig messageConfig;
  late bool hasFile;
  Duration? voiceDuration;
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    messageConfig = getConfig();

    setSourcePlayer();

    player.onPlayerComplete.listen((state) async {
      await setSourcePlayer();
    });

    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayRegisterPlayerEvent(player));
  }

  Widget voiceWidget() {
    return Container(
      padding: EdgeInsets.only(top: widget.message.replyMessage != null ? 0 : 9, left: 9, right: 9, bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              StreamBuilder<Duration>(
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
                stream: getCurrentDurationVoice(),
                builder: (context, snapshot) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 7, color: messageConfig.primaryColor),
                      SizedBox(width: 2),
                      Text(
                        timeFormatter(snapshot.data?.inSeconds ?? 0),
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
                color: isForMe() ? Colors.white : Themes.primary,
              ),
              child: StreamBuilder<PlayerState>(
                stream: player.onPlayerStateChanged,
                builder: (context, snapshot) {
                  return Icon(
                    snapshot.data == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: isForMe() ? Themes.primary : Colors.white,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void playVoice() async {
    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayPlayOrStop(player));
  }

  @override
  Widget content() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            replyWidget(widget.message.replyMessage, widget.onClickReplyMessage),
            voiceWidget(),
          ],
        ),
        Positioned(bottom: 0, right: 0, child: footerWidget(widget.message.isSeen, widget.message.createTime!)),
      ],
    );
  }

  Future<void> setSourcePlayer() async {
    if (player.source != null) return;
    try {
      if (widget.files.isFill()) {
        await player.setSourceDeviceFile(widget.files!.first.path);
      } else {
        await player.setSourceUrl(widget.fileMessages[0].path!);
      }
      voiceDuration = await player.onDurationChanged.first;
    } catch (e) {}
  }

  Stream<Duration> getCurrentDurationVoice() async* {
    try {
      if (player.source == null) yield Duration(seconds: 0);
      var count = await player.onDurationChanged.first;

      yield count;

      yield* player.onPositionChanged.asyncExpand((position) async* {
        yield Duration(seconds: count.inSeconds - position.inSeconds);
      });
    } catch (e) {}
  }
}
