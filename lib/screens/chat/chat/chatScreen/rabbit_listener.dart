part of 'chat_screen.dart';

extension RabbitListener on _ChatScreen {
  listenRabbit() async {
    rabbitClient = Client(
        settings: ConnectionSettings(
      host: "188.121.106.229",
      port: 5672,
      authProvider: PlainAuthenticator("admin", "admin"),
      tuningSettings: TuningSettings(
        heartbeatPeriod: Duration(seconds: 1),
      ),
      reconnectWaitTime: Duration(seconds: 1),
      maxConnectionAttempts: 1000
    ));

    Channel channel = await rabbitClient!.channel();
    var queueName = (await User.fromLocal()).id!.toString();
    Queue queue = await channel.queue(queueName);
    var consumer = await queue.consume(consumerTag: "app__chat_screen");
    consumer.listen((AmqpMessage message) async {
      if (message.payloadAsJson['type'] == "new_message") {
        if (message.payloadAsJson['data']['chat_id'] == widget.chatId) {
          var chatMessage = ChatMessage.fromJson(message.payloadAsJson['data']['message']);
          messageWidgets.add(
            createDate: chatMessage.createDate!,
            widget: ChatMessageWidget(
              messageKey: MessageWidgetKey(chatMessage),
              message: chatMessage,
            ),
          );

          Future.delayed(Duration(milliseconds: 300), () async {
            final player = AudioPlayer();
            await player.play(AssetSource("sounds/message-sent.wav"));
          });

          setState(() {});
        }
      }
      // notify("received");
    });
  }
}
