import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/dark_theme_provider.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/splash_screens.dart';
import 'package:siraf3/themes.dart';

void main() async {
  runApp(
    MultiBlocProvider(
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
  );
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
              '/': (_) => SplashScreen(),
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
