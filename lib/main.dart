import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pw/cubit/home_cubit.dart';
import 'package:pw/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: "LD app",
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: BlocProvider(
              create: (_) => HomeCubit(),
              child: MyHomePage(),
            ),
          );
        },
      );
}

class MyHomePage extends StatelessWidget {
   late bool isDark;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("LD app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isDark ? 'dark' : 'light',
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => Text(
                state.counter.toString(),
                style: Theme.of(context).textTheme.headline4,
              )
            ),
            ElevatedButton(onPressed: () {context.read<HomeCubit>().add(isDark ? 2 : 1);}, child: const Text("ADD")),
            ElevatedButton(onPressed: () {context.read<HomeCubit>().sub(isDark ? 2 : 1);}, child: const Text("SUB")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Provider.of<ThemeProvider>(context, listen: false).toggleTheme(!isDark); },
        tooltip: 'Change theme',
        child: const Icon(Icons.switch_access_shortcut),
      ), 
    );
  }
}
