import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'edit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCSVz0YwbZWen-jZbNxmJoR9f1PELvBex0",
      appId: "1:411846421257:android:fe7f91675716a403db41d8",
      messagingSenderId: "411846421257",
      projectId: "sekul-bdc32",
    ),
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan),
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? studentName, studentNIS, studentKelas, studentAlamat;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentID(nis) {
    this.studentNIS = nis;
  }

  getStudentKelas(kelas) {
    this.studentKelas = kelas;
  }

  getStudentAlamat(alamat) {
    this.studentAlamat = alamat;
  }

  createData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyStudents")
        .doc(studentName);

    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentNIS": studentNIS,
      "studentKelas": studentKelas,
      "studentAlamat": studentAlamat,
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName Created");
    });
  }

  readData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyStudents")
        .doc(studentName);

    documentReference.get().then((datasnapshot) {
      var data = datasnapshot.data() as Map<String, dynamic>?;
      print(data?["studentName"]);
      print(data?["studentNIS"]);
      print(data?["studentKelas"]);
      print(data?["studentAlamat"]);
    });
  }

  updateData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyStudents")
        .doc(studentName);

    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentNIS": studentNIS,
      "studentKelas": studentKelas,
      "studentAlamat": studentAlamat,
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName updated");
    });
  }

  deleteData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyStudents")
        .doc(studentName);

    documentReference.delete().whenComplete(() {
      print("$studentName deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Siswa"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String name) {
                  getStudentName(name);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "NIS",
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String nis) {
                  getStudentID(nis);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Kelas",
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String kelas) {
                  getStudentKelas(kelas);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Alamat",
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String alamat) {
                  getStudentAlamat(alamat);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    createData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text("Simpan"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Expanded(child: Text("Nama")),
                  Expanded(child: Text("NIS")),
                  Expanded(child: Text("Kelas")),
                  Expanded(child: Text("Alamat")),
                ],
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection("MyStudents")
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditPage(
                                  id: document.id,
                                  name: document["studentName"],
                                  nis: document["studentNIS"],
                                  kelas: document["studentKelas"],
                                  alamat: document["studentAlamat"],
                                ),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(document["studentName"])),
                          Expanded(child: Text(document["studentNIS"])),
                          Expanded(child: Text(document["studentKelas"])),
                          Expanded(
                            child: Text(document["studentAlamat"].toString()),
                          ),
                          IconButton(
                            icon: Text(
                              'x',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("MyStudents")
                                  .doc(document.id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
