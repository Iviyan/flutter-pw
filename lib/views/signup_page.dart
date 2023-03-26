
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/app_router.dart';
import 'package:flutter/material.dart';

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  
  //AuthUseCase auth = Auth(AuthRepoImpl());

  static RegExp emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static String symbols = ",./?;:'\"[{]}-_=+*&^%\$#@!";
  static String digits = "0123456789";
  static int char_a = 'a'.codeUnitAt(0);
  static int char_z = 'z'.codeUnitAt(0);
  static String CharsAZ = String.fromCharCodes([for (var i = char_a; i <= char_z; i++) i]);

  static bool isPasswordValid(String pass) {
    var cs = pass.characters;

    bool anySymbol = cs.any((c) => symbols.contains(c));
    bool anyDigit = cs.any((c) => digits.contains(c));
    bool anyAlphabet = cs.any((c) => CharsAZ.contains(c));

    return anySymbol && anyDigit && anyAlphabet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Form(key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              controller: email,
              validator: (value) {
                if (value == null || value.isEmpty) return "Пустое поле";
                if (!emailRegex.hasMatch(value)) return "Неверный формат email";               
                
                return null;
              },           
              decoration: InputDecoration(
                isDense: true,
                hintText: "Email",
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                suffixIcon: GestureDetector(onTap: () { email.clear(); }, child: const Icon(Icons.clear))
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              controller: password,
              validator: (value) {
                if (value == null || value.isEmpty) return "Пустое поле";
                if (value.length < 3 || value.length > 30) return "Пароль должен быть от 3 до 30 символов";
                if (!isPasswordValid(value)) return "Пароль должен содержать хотя бы 1 букву, цифру и знак";
                return null;
              },         
              decoration: InputDecoration(
                isDense: true,
                hintText: "Пароль",
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                suffixIcon: GestureDetector(onTap: () { password.clear(); }, child: const Icon(Icons.clear, ))
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              controller: name,        
              decoration: InputDecoration(
                isDense: true,
                hintText: "Имя",
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                suffixIcon: GestureDetector(onTap: () { name.clear(); }, child: const Icon(Icons.clear, ))
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final firestore = FirebaseFirestore.instance;
                final users = firestore.collection("users");

                try {
                  UserCredential user = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(email: email.text, password: password.text);
 
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user.toString())));

                  await users.add({
                    'email': email.text,
                    'name': name.text
                  });

                  Navigator. pushNamed(context, pageMain, arguments:  MainRouteArguments(userCredential: user));
                }
                on FirebaseAuthException catch (error) {
                  if (error.code == 'email-already-in-use') {
                    final _user = await users.where('email', isEqualTo: email.text).get();
                    if (_user.size == 0) {
                      await users.add({
                        'email': email.text,
                        'name': name.text
                      });

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Данные пользователя созданы")));
                      Navigator.pop(context);
                      return;
                    }                    
                  } 
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                }
                catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 102, 140, 198))),
              child: const SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Регистрация",
                )),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 84, 102, 78))),
                child: const SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Авторизация",
                  )),
                )),
          ),
        ]),
      ),
    ));
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}
