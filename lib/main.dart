import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebaseapp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:html';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(initialLink: window.location.href));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialLink});

  final String? initialLink;

  @override
  State<MyApp> createState() => _MyAppState();
}

const String emailForLinkPref = "emailForLink";

class _MyAppState extends State<MyApp> {

  late Future<UserCredential?> user;

  @override
  void initState() {
    super.initState();
    user = _initAuth();     
  }

  Future<UserCredential?> _initAuth() async {
    print(widget.initialLink);
    if (widget.initialLink == null || !FirebaseAuth.instance.isSignInWithEmailLink(widget.initialLink!)) return null;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString(emailForLinkPref);
      if (email == null) return null;

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailLink(email: email, emailLink: widget.initialLink!);

      print('Successfully signed in with email link!\n$userCredential');

      return userCredential;
    } catch (error) {
      print('Error signing in with email link.\n${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<UserCredential?>(
        future: user,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data != null
              ? TextPage(text: snapshot.data.toString())
              : const HomePage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ), 
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController smsCode = TextEditingController();
  ConfirmationResult? smsConfirmationResult;

  //final GlobalKey<FormState> _formKey = GlobalKey();

  /* @override
  void initState() {
    
  } */

  //flutter run -d web-server --web-port=61049

  final acs = ActionCodeSettings(
    url: 'http://localhost:61049/',
    handleCodeInApp: true,
    //androidPackageName: 'com.example.firebaseapp',
    androidInstallApp: true,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            controller: email,  
            decoration: InputDecoration(
              isDense: true,
              hintText: "Логин",
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(onTap: () { email.clear(); }, child: const Icon(Icons.clear))
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            controller: password,         
            decoration: InputDecoration(
              isDense: true,
              hintText: "Пароль",
              //contentPadding: EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(onTap: () { password.clear(); }, child: const Icon(Icons.clear, ))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email.text, password: password.text)
                  .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage(text: value.toString()),));
                  })
                  .onError<FirebaseAuthException>((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                  });
                
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 84, 102, 78))),
              child: const SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Авторизация",
                )),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance
                  .sendSignInLinkToEmail(email: email.text, actionCodeSettings: acs)
                  .then((value) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString(emailForLinkPref, email.text);
                    
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Письмо отправлено")));
                  })
                  .onError<FirebaseAuthException>((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                  });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 92, 131, 115))),
              child: const SizedBox(
                height: 50,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Отправить ссылку на email",
                )),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance
                  .signInAnonymously()
                  .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage(text: value.toString())));
                  })
                  .onError<FirebaseAuthException>((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                  });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 92, 131, 115))),
              child: const SizedBox(
                height: 50,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Анонимный вход",
                )),
              )),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            controller: phone,        
            decoration: InputDecoration(
              isDense: true,
              hintText: "Телефон",
              //contentPadding: EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(onTap: () { phone.clear(); }, child: const Icon(Icons.clear, ))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance
                .signInWithPhoneNumber(phone.text)
                .then((value) { 
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                  setState(() {
                    smsConfirmationResult = value;
                  });
                })
                .onError<FirebaseAuthException>((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                });
            },
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 84, 102, 78))),
            child: const SizedBox(
              height: 60,
              width: double.infinity,
              child: Center(
                  child: Text(
                "Отправить смс на телефон",
              )),
            )
          ),
        ),
        ...(smsConfirmationResult == null ? [] : [ Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            controller: smsCode,        
            decoration: InputDecoration(
              isDense: true,
              hintText: "Код из смс",
              //contentPadding: EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(onTap: () { smsCode.clear(); }, child: const Icon(Icons.clear, ))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () async {
                smsConfirmationResult!.confirm(smsCode.text)
                  .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage(text: value.toString()),));
                  })
                  .onError<FirebaseAuthException>((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                  });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 84, 102, 78))),
              child: const SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Проверить смс код",
                )),
              )
            ),
          )]),
        ]),
    ));
  }
}


class TextPage extends StatelessWidget {
  const TextPage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(text, style: const TextStyle(fontSize: 14)),
      ElevatedButton(onPressed: () { Navigator.pop(context); }, child: const Text("Назад"))
    ]));
  }
}