import 'package:crud_app/pages/add_student.dart';
import 'package:crud_app/pages/student_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Firebsae CRUD App",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5.w, 0),
                child: GestureDetector(
                  onTap: () {
                    _navigateToAddStudent(context);
                  },
                  child: Icon(
                    Icons.add_circle_outline_sharp,
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
              )
            ]),
        body: const StudentList(),
      );
    });
  }

  void _navigateToAddStudent(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddStudent()));
  }
}
