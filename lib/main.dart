import 'package:flutter/material.dart';
import 'package:pw/app_router.dart';
import 'package:pw/core/db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRouter,
      initialRoute: pageSignIn,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}