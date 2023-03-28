import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImagesView extends StatefulWidget {
  const ImagesView({super.key});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  
  late CollectionReference<Map<String, dynamic>> images;
  late Reference storageRef;


  _ImagesViewState() {
    images = firestore.collection("images");
    storageRef = storage.ref();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>>? imagesData;

  @override
  void initState() {
    super.initState();

    initData();
  }

  Future<void> initData() async {
    images.snapshots().listen((event) {
      setState(() {
        imagesData = event.docs;
        // print(">> ${identical(imagesData, event.docs)}"); // false
      });
    });
    storageRef.listAll().then((value) {
      value.items.forEach((element) {
        print(">> ${element.name}");
      });
    });
  }

  String generateRandomString() => DateTime.now().microsecondsSinceEpoch.toString();


  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: SingleChildScrollView(child: Column(children: [
        Container(margin: const EdgeInsets.fromLTRB(10, 10, 10, 10), child: 
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Pick file button using file_picker
            ElevatedButton(onPressed: () async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result?.toString() ?? "null")));
              if (result == null) return;
              final file = result.files.single;
              final name = generateRandomString();

              try {
                final TaskSnapshot uploadFile = await storageRef.child(name)
                  .putData(file.bytes!, SettableMetadata(contentType: "image/${file.extension}"));
                
                await firestore.collection("images").add({
                  "name": file.name, "size": file.size, 
                  "link": uploadFile.ref.fullPath, "downloadUrl": await uploadFile.ref.getDownloadURL()
                });
              } catch (err) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
              }
            }, style: const ButtonStyle(), child: const Text("Добавить изображение")),
          ])
        ),
        Column(children: imagesData == null ? [] : imagesData!.map((i) => 
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(4),
            child: EditableImage(image: i, imageRef: storageRef.child(i.get("link")))
          )).toList()
        )
      ]))
    ));
  }
}


class EditableImage extends StatefulWidget {
  const EditableImage({super.key, required this.image, required this.imageRef});

  final QueryDocumentSnapshot<Map<String, dynamic>> image;
  final Reference imageRef;

  @override
  State<EditableImage> createState() => _EditableImageState();
}

class _EditableImageState extends State<EditableImage> {

  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  bool isEditing = false;
  String? downloadUrl;
  PlatformFile? newFile;

  @override
  void initState() {
    super.initState();

    initData();
  }

  Future<void> initData() async {
    setState(() async {
      downloadUrl = await widget.imageRef.getDownloadURL();
    });
  }

  void switchEditMode() {
    name.text = widget.image.get("name");

    setState(() { isEditing = true; }); 
  }
  void switchViewMode() {
    setState(() { isEditing = false; newFile = null; }); 
  }

  Widget _buildView(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.image.get("name"), style: const TextStyle(fontSize: 16)),
        ...(downloadUrl == null ? [const Center(child: Text("..."))] : [
          const SizedBox(height: 6),
          Center(child: Image.network(downloadUrl!, width: 200, height: 200, fit: BoxFit.cover)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: ElevatedButton(onPressed: (){ switchEditMode(); }, style: const ButtonStyle(), child: const Text("Изменить"))),
          const SizedBox(width: 6),
          Expanded(child: ElevatedButton(onPressed: () async {
            try {
              await widget.image.reference.delete();
              await widget.imageRef.delete();
            } catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
            }
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
        const SizedBox(height: 4),
        ElevatedButton(onPressed: () async {
            final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result?.toString() ?? "null")));
            if (result == null) return;
            final file = result.files.single;
            setState(() {
              newFile = file;
            });
          }, style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(newFile == null ? Colors.blue : Colors.lightGreen[600])
          ), child: const Text("Изменить изображение")),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: ElevatedButton(onPressed: () async {            
            if (!formKey.currentState!.validate()) return;

            try {
              if (newFile != null) {
                final file = newFile!;

                  final TaskSnapshot uploadFile = await widget.imageRef
                    .putData(file.bytes!, SettableMetadata(contentType: "image/${file.extension}"));
                  
                  await widget.image.reference.update({
                    "name": name.text,
                    "link": uploadFile.ref.fullPath,
                    "downloadUrl": await uploadFile.ref.getDownloadURL()
                  });
                
              } else {
                await widget.image.reference.update({ "name": name.text });
              }
            } catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
            }

            switchViewMode();
           
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