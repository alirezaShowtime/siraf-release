import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/bloc/login_status.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<GetCitiesBloc>(
      create: (_) => GetCitiesBloc(),
    ),
    BlocProvider<HSBloc>(
      create: (_) => HSBloc(),
    ),
    BlocProvider<LoginStatus>(
      create: (_) => LoginStatus(),
    ),
    BlocProvider<CategoriesBloc>(
      create: (_) => CategoriesBloc(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          fontFamily: 'IranSans',
          backgroundColor: Themes.background,
          scaffoldBackgroundColor: Themes.background,
          accentColor: Themes.secondary,
          secondaryHeaderColor: Themes.secondary,
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        home: HomeScreen(),
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
