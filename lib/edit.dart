import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditPage extends StatefulWidget {
  final String id;
  final String name;
  final String nis;
  final String kelas;
  final String alamat;

  const EditPage({
    super.key,
    required this.id,
    required this.name,
    required this.nis,
    required this.kelas,
    required this.alamat,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController nameController;
  late TextEditingController nisController;
  late TextEditingController kelasController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    nisController = TextEditingController(text: widget.nis);
    kelasController = TextEditingController(text: widget.kelas);
    alamatController = TextEditingController(text: widget.alamat);
  }

  updateData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyStudents")
        .doc(widget.id);

    Map<String, dynamic> students = {
      "studentName": nameController.text,
      "studentNIS": nisController.text,
      "studentKelas": kelasController.text,
      "studentAlamat": alamatController.text,
    };

    documentReference
        .update(students)
        .whenComplete(() {
          Alert(
            context: context,
            style: AlertStyle(
              backgroundColor: Colors.white,
              titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              descStyle: TextStyle(fontSize: 16),
              alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.cyan),
              ),
            ),
            type: AlertType.success,
            title: "Success",
            desc: "Data berhasil terupdate",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        })
        .catchError((e) {
          Alert(
            context: context,
            style: AlertStyle(
              backgroundColor: Colors.white,
              titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              descStyle: TextStyle(fontSize: 16),
            ),
            type: AlertType.error,
            title: "Error",
            desc: "Error updating: $e",
            buttons: [
              DialogButton(
                child: Text(
                  "Try Again",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Siswa'), backgroundColor: Colors.cyan),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              controller: nisController,
              decoration: InputDecoration(labelText: "NIS"),
            ),
            TextFormField(
              controller: kelasController,
              decoration: InputDecoration(labelText: "Kelas"),
            ),
            TextFormField(
              controller: alamatController,
              decoration: InputDecoration(labelText: "Alamat"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateData, child: Text("Update")),
          ],
        ),
      ),
    );
  }
}
