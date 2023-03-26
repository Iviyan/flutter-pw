import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  final firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> notes;

  _NotesViewState() {
    notes = firestore.collection("notes");
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? notesData;

  @override
  void initState() {
    super.initState();

    initData();
  }

  Future<void> initData() async {
    notes.snapshots().listen((event) {
      setState(() {
        notesData = event.docs;
        // print(">> ${identical(notesData, event.docs)}"); // false
      });
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: SingleChildScrollView(child: Column(children: [
        Container(margin: const EdgeInsets.fromLTRB(10, 10, 10, 10), child: 
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Form(key: formKey, child:
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Пустое поле";
                  return null;
                },           
                decoration: InputDecoration(
                  isDense: true,
                  labelText: "Название",
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(onTap: () { name.clear(); }, child: const Icon(Icons.clear))
                ),
              ),
            ),
            const SizedBox(height: 6),
            ElevatedButton(onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await firestore.collection("notes").add({"name": name.text});
              } catch (err) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
              }

            }, style: const ButtonStyle(), child: const Text("Добавить")),
          ])
        ),
        Column(children: notesData == null ? [] : notesData!.map((n) => 
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(4),
            child: EditableNote(note: n)
          )).toList()
        )
      ]))
    ));
  }
}


class EditableNote extends StatefulWidget {
  const EditableNote({super.key, required this.note});

  final QueryDocumentSnapshot<Map<String, dynamic>> note;

  @override
  State<EditableNote> createState() => _EditableNoteState();
}

class _EditableNoteState extends State<EditableNote> {

  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  bool isEditing = false;

  void switchEditMode() {
    name.text = widget.note.get("name");

    setState(() { isEditing = true; }); 
  }
  void switchViewMode() {
    setState(() { isEditing = false; }); 
  }

  Widget _buildView(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.note.get("name"), style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: ElevatedButton(onPressed: (){ switchEditMode(); }, style: const ButtonStyle(), child: const Text("Изменить"))),
          const SizedBox(width: 6),
          Expanded(child: ElevatedButton(onPressed: () async {
            widget.note.reference.delete()
              .catchError((err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))));
          }, style: const ButtonStyle(), child: const Text("Удалить")))
        ],)
      ],
    );
  }

  Widget _buildEdit(BuildContext context) {
    return Container(margin: const EdgeInsets.fromLTRB(10, 10, 10, 10), child: 
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Form(key: formKey, child:
          TextFormField(
            controller: name,
            validator: (value) {
              if (value == null || value.isEmpty) return "Пустое поле";
              return null;
            },           
            decoration: InputDecoration(
              isDense: true,
              labelText: "Название",
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(onTap: () { name.clear(); }, child: const Icon(Icons.clear))
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: ElevatedButton(onPressed: () async {            
            if (!formKey.currentState!.validate()) return;

            widget.note.reference.update({"name": name.text})
              .then((value) => switchViewMode())
              .catchError((err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))));
           
          }, style: const ButtonStyle(), child: const Text("Изменить"))),
          const SizedBox(width: 6),
          Expanded(child: ElevatedButton(onPressed: (){ switchViewMode(); }, style: const ButtonStyle(), child: const Text("Отмена")))
        ],)
      ])
    );
  }

  @override
  Widget build(BuildContext context) => !isEditing ? _buildView(context) : _buildEdit(context);
}