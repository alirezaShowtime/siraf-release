import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/dark_theme_provider.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/firebase_options.dart';
import 'package:siraf3/screens/chat/chat_list_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/splash_screens.dart';
import 'package:siraf3/settings.dart';
import 'package:siraf3/themes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    "High Importance Notifications Description",
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  firebaseMessageListener(message);
}

firebaseMessageListener(RemoteMessage message) async {
  if (message.data.isEmpty) return;

  RemoteNotification? notification = message.notification;

  flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onSelectNotification: (_) async {});
  int id;
  String title, body;

  if (notification != null) {
    id = message.notification.hashCode;
    title = notification.title ?? "";
    body = notification.body ?? "";
  } else {
    title = message.data['title'] ?? "";
    body = message.data['body'] ?? "";
    id = Random().nextInt(1000000000);
  }

  flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await (Settings().showNotification())) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      "High Importance Notifications Description",
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(
    RestartWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GetCitiesBloc>(
            create: (_) => GetCitiesBloc(),
          ),
          BlocProvider<HSBloc>(
            create: (_) => HSBloc(),
          ),
          BlocProvider<CategoriesBloc>(
            create: (_) => CategoriesBloc(),
          ),
        ],
        child: AppStf(),
      ),
    ),
  );
}



class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class AppStf extends StatefulWidget {
  const AppStf({Key? key}) : super(key: key);

  @override
  State<AppStf> createState() => App();
}

class App extends State<AppStf> {
  static late ThemeData theme;
  static late bool isDark;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  ThemeData lightTheme = Themes.themeData();
  ThemeData darkTheme = DarkThemes.darkThemeData();

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    bool isDark2 = await themeChangeProvider.darkThemePreference.darkMode();
    setState(() {
      isDark = isDark2;
      theme = isDark2 ? darkTheme : lightTheme;
    });
    themeChangeProvider.darkTheme = isDark2;
  }

  @override
  Widget build(BuildContext context) {
    isDark = false;

    theme = isDark ? darkTheme : lightTheme;

    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        isDark = value.darkTheme;
        theme = value.darkTheme ? darkTheme : lightTheme;
        return OKToast(
          child: MaterialApp(
            title: 'سیراف',
            localizationsDelegates: const [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("fa", "IR"),
            ],
            locale: Locale("fa", "IR"),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              HttpOverrides.global = MyHttpOverrides();
              return MediaQuery(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: child!,
                ),
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            routes: {
              '/': (_) => ChatListScreen(),
              '/home': (_) => HomeScreen(),
            },
          ),
        );
      }),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
