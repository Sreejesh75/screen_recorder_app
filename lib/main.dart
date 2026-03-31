import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screen_recorder_/core/theme/app_theme.dart';
import 'package:screen_recorder_/features/recorder/bloc/recorder_bloc.dart';
import 'package:screen_recorder_/features/recorder/presentation/recorder_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('recordings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecorderBloc(),
      child: MaterialApp(
        title: 'Screen Recorder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const RecorderPage(),
      ),
    );
  }
}
