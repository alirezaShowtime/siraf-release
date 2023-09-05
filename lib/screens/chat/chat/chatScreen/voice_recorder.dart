part of 'chat_screen.dart';

extension VoiceRecorder on _ChatScreen {
  Future<void> startRecording() async {
    if (!await recordPermissionsRequest()) return;
    Directory appFolder = await getTemporaryDirectory();
    bool appFolderExists = await appFolder.exists();
    if (!appFolderExists) {
      await appFolder.create(recursive: true);
    }

    final filepath = appFolder.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + ".mp3";

    await _audioRecorder.start(path: filepath);
  }

  Future<String?> stopRecording() async {
    if (!await _audioRecorder.isRecording()) return null;

    String? path = await _audioRecorder.stop();
    _audioRecorder.dispose();

    return path;
  }

  Future<void> cancelRecording() async {
    try {
      if (await _audioRecorder.isRecording()) {
        String? path = await _audioRecorder.stop();

        await File(path!).delete();
      }
    } catch (e) {}
  }

  Future<bool> recordPermissionsRequest() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    return permissions[Permission.storage]!.isGranted && permissions[Permission.microphone]!.isGranted;
  }

  Widget VoiceRecorderWidget() {
    return Stack(
      children: [
        BlocBuilder(
          bloc: recordingVoiceBloc,
          builder: (context, state) {
            if (state != RecordingVoiceState.Recording) return Container();
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.7)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, -3),
                      spreadRadius: -3,
                      blurRadius: 1,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedBuilder(animation: voiceAnim, builder: (_, __) => SizedBox(width: 50 - voiceAnim.value * 3)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "برای لغو بکشید",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "IranSansBold",
                              fontSize: 10,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<int>(
                        initialData: 0,
                        stream: recordTimeStream.stream,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: 50,
                            child: Text(
                              timeFormatter(snapshot.data!),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Themes.text,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans-serif",
                                fontSize: 11,
                              ),
                            ),
                          );
                        }),
                    SizedBox(width: 5),
                    AnimatedBuilder(
                      animation: recordIconAnim,
                      builder: (_, __) {
                        return Icon(Icons.circle, size: 8, color: Colors.red.withOpacity(recordIconAnim.value));
                      },
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            );
          },
        ),
        BlocBuilder(
          bloc: recordingVoiceBloc,
          builder: (context, state) {
            if (state != RecordingVoiceState.Recording) return Container();
            return Positioned(
              bottom: -20,
              right: -20,
              child: AnimatedBuilder(
                animation: voiceAnim,
                builder: (_, __) {
                  return Material(
                    color: Themes.primary,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 95,
                      width: 95,
                      margin: EdgeInsets.only(top: voiceAnim.value, left: voiceAnim.value),
                      child: Icon(Icons.keyboard_voice_outlined, color: Colors.white),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void startTimer() {
    recordTime = 0;
    recordTimeStream.add(recordTime++);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordTimeStream.add(recordTime++);
    });
  }

  void endTimer() {
    timer?.cancel();
    timer = null;
    recordTime = 0;
    recordTimeStream.add(0);
  }
}
