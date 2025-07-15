import 'package:flutter/material.dart';
import 'package:state_management/test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management/bloc/champion_bloc.dart';
import 'package:state_management/setstate/home_screen.dart';
import 'package:state_management/bloc/home_screen_bloc.dart';
import 'package:state_management/bloc/champion_api_service.dart';
import 'package:state_management/setstate/champion_detail_screen.dart';
import 'package:state_management/bloc/detail/champion_detail_bloc.dart';
import 'package:state_management/bloc/detail/champion_detail_api_service.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  final ChampionApiService championApiService = ChampionApiService();
  final ChampionDetailApiService championDetailApiService =
      ChampionDetailApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChampionBloc(apiService: championApiService),
        ),
        BlocProvider(
          create: (context) =>
              ChampionDetailBloc(apiService: championDetailApiService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreenBloc(),
    );
  }
}
