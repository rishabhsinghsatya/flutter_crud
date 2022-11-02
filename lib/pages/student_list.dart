import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/pages/update_student_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  //fetch data from firebase
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection("students").snapshots();

//for deleting user
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  Future<void> deleteUser(id) {
    return students
        .doc(id)
        .delete()
        .then((value) => print("user deleted"))
        .catchError((error) => print("failed to delete user: $error"));
    // print("user deleted $id");
  }

  @override
  Widget build(BuildContext context) {
    //use stream builder for show instant change
    return StreamBuilder<QuerySnapshot>(
        stream: studentsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          //data nikalenge yahan se snapshot.data
          final List storedocs = [];
          snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storedocs.add(a);
              a['id'] = document.id;
              // print(storedocs);
            },
          ).toList();
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(140),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            tableCell("Name"),
                            tableCell("Email"),
                            tableCell("Action")
                          ],
                        ),
                        for (var i = 0; i < storedocs.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                    child: Text(storedocs[i]['name'],
                                        style: TextStyle(fontSize: 14.0))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text(storedocs[i]['email'],
                                        style: TextStyle(fontSize: 14.0))),
                              ),
                              TableCell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateStudentPage(
                                                    id: storedocs[i]['id']),
                                          ),
                                        )
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          {deleteUser(storedocs[i]['id'])},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]
                      ])));
        });
  }

  static tableCell(String str) {
    return TableCell(
      child: Container(
        color: Color.fromARGB(255, 228, 90, 90),
        child: Center(
          child: Text(
            str,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
