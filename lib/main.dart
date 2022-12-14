import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<GetCitiesBloc>(
      create: (_) => GetCitiesBloc(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("fa", "IR"),
        ],
        locale: Locale("fa", "IR"),
        title: 'سیراف',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Vazir',
          backgroundColor: Themes.background,
          scaffoldBackgroundColor: Themes.background,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => SelectCityScreen(),
        },
        builder: (context, child) {
          return MediaQuery(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      ),
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
