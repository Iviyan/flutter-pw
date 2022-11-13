
import 'package:flutter/material.dart';
import 'package:pw/app_router.dart';
import 'package:pw/core/usecase/auth_use_case.dart';
import 'package:pw/data/repos/auth_repo_impl.dart';
import 'package:pw/domain/usecase/auth.dart';

RegExp loginRegExp = RegExp(r'^[a-z]+$', caseSensitive: false, multiLine: false);

class _SignInPageState extends State<SignInPage> {

  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthUseCase auth = Auth(AuthRepoImpl());

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
                return null;
              },           
              decoration: InputDecoration(
                isDense: true,
                hintText: "Логин",
                border: const OutlineInputBorder(),
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
                return null;
              },         
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
                  if (!_formKey.currentState!.validate()) return;

                  var result = await auth.signIn(SignInParams(login.text, password.text));
                  result.fold(
                    (error) => { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error))) },
                    (role) => { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(role.title))) }
                  );
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
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, pageSignUp);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 102, 140, 198))),
                child: const SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Регистрация",
                  )),
                )),
          ),
        ]),
      ),
    ));
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}
