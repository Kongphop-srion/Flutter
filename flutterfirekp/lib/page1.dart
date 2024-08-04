import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firestore Example',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userData').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Text(
                        '${data['job']} เงินเดือน ${data['salary']}'), // เพิ่มข้อมูลเงินเดือนใน subtitle
                    leading: const Icon(Icons.person),
                    trailing: !data['admin']
                        ? SizedBox(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    doEdit(document, data);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    doDel(document
                                        .id); // pass document id instead of data
                                  },
                                ),
                              ],
                            ),
                          )
                        : null,
                    tileColor: Colors.amberAccent,
                  ),
                );
              }).toList()));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          doAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void doAdd() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();
    TextEditingController salaryController =
        TextEditingController(); // เพิ่ม controller สำหรับเงินเดือน

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add User'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: jobController,
                  decoration: const InputDecoration(labelText: 'Job'),
                ),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(
                      labelText: 'Salary'), // เพิ่ม TextField สำหรับเงินเดือน
                  keyboardType:
                      TextInputType.number, // ให้ใช้ประเภทข้อมูลตัวเลขเท่านั้น
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;
                  final CollectionReference mainCollection =
                      firestore.collection('userData');
                  mainCollection.add({
                    'name': nameController.text,
                    'job': jobController.text,
                    'salary': int.parse(salaryController
                        .text), // บันทึกเงินเดือนเป็นตัวเลขจำนวนเต็ม
                    'admin': false,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void doEdit(DocumentSnapshot document, Map<String, dynamic> data) {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();
    TextEditingController salaryController =
        TextEditingController(); // เพิ่ม controller สำหรับเงินเดือน

    nameController.text = data['name'];
    jobController.text = data['job'];
    salaryController.text =
        data['salary'].toString(); // ตั้งค่าเงินเดือนใน TextField

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit User'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: jobController,
                  decoration: const InputDecoration(labelText: 'Job'),
                ),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Text('Save Data'),
                            content: const Text('Are you sure?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                child: const Text('Save'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  final CollectionReference mainCollection =
                                      firestore.collection('userData');

                                  await mainCollection.doc(document.id).update({
                                    'name': nameController.text,
                                    'job': jobController.text,
                                    'salary': int.parse(salaryController
                                        .text), // บันทึกเงินเดือนเป็นตัวเลขจำนวนเต็ม
                                  });
                                },
                              )
                            ]);
                      }).then((value) => Navigator.pop(context));
                },
              ),
            ],
          );
        });
  }

  void doDel(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Data'),
            content: const Text('Are your sure?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  Navigator.pop(context);
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;
                  final CollectionReference mainCollection =
                      firestore.collection('userData');
                  await mainCollection.doc(id).delete();
                },
              )
            ],
          );
        });
  }
}
