import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/themes.dart';

import '../my_audio_wave.dart';
import 'chat_sending_message_widget.dart';

class ChatSendingVoiceMessageWidgetState extends ChatSendingMessageWidgetState {
  late AnimationController loadingController;

  AudioPlayer player = AudioPlayer();
  Duration? voiceDuration;
  late ChatMessageConfig messageConfig;

  @override
  void initState() {
    super.initState();

    messageConfig = getConfig();

    try {
      setSourcePlayer();
    } catch (e) {}

    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayRegisterPlayerEvent(player));

    loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    loadingController.dispose();
    player.stop();
    super.dispose();
  }

  void _playVoice() async {
    BlocProvider.of<VoiceMessagePlayBloc>(context).add(VoiceMessagePlayPlayOrStop(player));
  }

  Widget _voiceWidget() {
    return Container(
      padding: EdgeInsets.only(top: widget.replyMessage != null ? 0 : 9, left: 9, right: 9, bottom: 9),
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
            onTap: _playVoice,
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

  @override
  Widget content() {
    return _onlyVoice();
  }

  Widget _onlyVoice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        Stack(
          children: [
            _voiceWidget(),
            Positioned(
              bottom: 0,
              right: 0,
              child: footer(),
            ),
          ],
        ),
      ],
    );
  }

  Widget footer() {
    return StreamBuilder<MessageState>(
      initialData: MessageState.Uploading,
      stream: widget.controller.messageSate.stream,
      builder: (_, snapshot) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (snapshot.data == MessageState.Uploading)
              Icon(
                Icons.access_time_rounded,
                color: messageConfig.secondTextColor,
                size: 13,
              ),
            if (snapshot.data == MessageState.ErrorUpload)
              Icon(
                Icons.error_outline_rounded,
                color: messageConfig.secondTextColor,
                size: 13,
              ),
            SizedBox(width: 2),
            Text(
              createTime ?? "",
              style: TextStyle(
                color: messageConfig.secondTextColor,
                fontSize: 9,
                height: 1,
                fontFamily: "sans-serif",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  void setSourcePlayer() async {
    player.setSource(DeviceFileSource(widget.files!.first.path));

    voiceDuration = await player.onDurationChanged.first;
  }

  Stream<Duration> getCurrentDurationVoice() async* {
    var count = await player.onDurationChanged.first;

    yield count;

    yield* player.onPositionChanged.asyncExpand((position) async* {
      yield Duration(seconds: count.inSeconds - position.inSeconds);
    });
  }
}
