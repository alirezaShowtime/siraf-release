import 'package:siraf3/models/user.dart';
import 'package:siraf3/rabbit_mq_data.dart';
import 'package:dart_amqp/dart_amqp.dart';


  consumRabbitMq() async {
    var uid = (await User.fromLocal()).id;

    if (uid == null) {
      return;
    }

    Client client = Client(
        settings: ConnectionSettings(
            host: "188.121.106.229",
            port: 5672,
            authProvider: PlainAuthenticator("admin", "admin")));

    Channel channel = await client.channel();
    var queue_name = uid.toString();
    Queue queue = await channel.queue(queue_name);
    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      print(message.payloadAsJson);
      if (message.payloadAsJson['type'] == "new_message") {
        hasNewMessage = true;
        hasNewMessageStream.add(hasNewMessage);
      }
    });
  }