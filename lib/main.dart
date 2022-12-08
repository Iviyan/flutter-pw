import 'package:flutter/material.dart';
import 'package:pw/screen2.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  TextEditingController text = TextEditingController();

  final Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

  @override
  void initState() {
    sharedPreferences.then((prefs) {
      text.text = prefs.getString("text") ?? "";
      text.addListener(() { prefs.setString("text", text.text); });
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: text,          
              decoration: InputDecoration(
                isDense: true,
                hintText: "Логин",
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(onTap: () { text.clear(); }, child: const Icon(Icons.clear))
              ),
            ),

            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => Screen2(text: text.text)));
            }, child: const Text("Перейти"))
          ],
        ),
      ),
    );
  }
}
