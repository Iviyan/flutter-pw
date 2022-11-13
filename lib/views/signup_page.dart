
import 'package:flutter/material.dart';
import 'package:pw/core/usecase/auth_use_case.dart';
import 'package:pw/data/repos/auth_repo_impl.dart';
import 'package:pw/domain/entity/role_entity.dart';
import 'package:pw/domain/usecase/auth.dart';

RegExp loginRegExp = RegExp(r'^[a-z]+$', caseSensitive: false, multiLine: false);

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  
  AuthUseCase auth = Auth(AuthRepoImpl());

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
              controller: login,
              validator: (value) {
                if (value == null || value.isEmpty) return "Пустое поле";
                if (value.length < 3) return "Логин не может быть короче 3 сиволов";
                if (value.length > 20) return "Логин не может быть длиннее 20 сиволов";
                if (!loginRegExp.hasMatch(value)) return "Логин должен содержать только символы латинского алфавита";
                return null;
              },           
              decoration: InputDecoration(
                isDense: true,
                hintText: "Логин",
                border: const OutlineInputBorder(),
                errorMaxLines: 2,
                suffixIcon: GestureDetector(onTap: () { login.clear(); }, child: const Icon(Icons.clear))
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                  var error = await auth.signUp(SignUpParams(login.text, password.text, Roles.user));
                  if (error != null)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                  else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Успешная регистрация")));
                  
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
