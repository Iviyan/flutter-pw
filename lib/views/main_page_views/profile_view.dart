import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

RegExp nameRegExp = RegExp(r'^[a-zа-яё]{1,30}$', caseSensitive: false, multiLine: false);

class _ProfileViewState extends State<ProfileView> {

  TextEditingController name = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> users;

  _ProfileViewState() {
    users = firestore.collection("users");
  }

  DocumentReference<Map<String, dynamic>>? user;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();

    initData();
  }

  Future<void> initData() async {
    final _user = await users.where('email', isEqualTo: widget.userCredential.user?.email).get();
    if (_user.size == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User data not found")));
      return;
    }

    user = _user.docs.first.reference; 
    _user.docs.first.reference.snapshots().listen((event) {
      setState(() {
        userData = event.data()!;
        name.text = userData['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? const Text("Загрузка") : Scaffold(body: SafeArea(
      child: Form(key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Email: ${widget.userCredential.user?.email ?? ""}"),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              controller: name,
              validator: (value) {
                if (value == null || value.isEmpty) return "Пустое поле";
                return null;
              },           
              decoration: InputDecoration(
                isDense: true,
                hintText: "Имя",
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(onTap: () { name.clear(); }, child: const Icon(Icons.clear))
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  try { 
                    await user!.update({'name': name.text}); 
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Данные обновлены")));
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))); 
                  }               
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 84, 102, 78))),
                child: const SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Обновить",
                  )),
                )),
          )
        ]),
      ),
    ));
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.userCredential}) : super(key: key);

  final UserCredential userCredential;

  @protected
  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}
