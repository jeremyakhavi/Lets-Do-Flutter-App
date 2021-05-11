import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/views/settings.dart';
import 'package:to_do_app/views/task.dart';
import 'package:to_do_app/widgets.dart';

import '../services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _dbClient = DatabaseHelper();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // light indigo background colour, stretching across full width
          color: Colors.indigo[50],
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 25.0),
                        // logo for application in top left corner of home screen
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          height: 75,
                          width: 75,
                        ),
                        // widget to show each task
                      ),
                      Text('      Let\'s Do',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0,
                          )),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbClient.displayTasks(),
                      builder: (context, snapshot) {
                        // remove glow when scrolling
                        return ScrollConfiguration(
                          behavior: RemoveGlow(),
                          // build list view of task widgets
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              // wrap in gesture detector to open task on tap
                              return GestureDetector(
                                onTap: () {
                                  print(snapshot.data[index].id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskView(
                                              task: snapshot.data[index],
                                            )),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskWidget(
                                  taskTitle: snapshot.data[index].taskTitle,
                                  taskDescription:
                                      snapshot.data[index].taskDescription,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                //left: 25.0,
                bottom: 25.0,
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: FloatingActionButton(
                      heroTag: "cameraBtn",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsView()));
                      },
                      child: const Icon(Icons.settings),
                      backgroundColor: Colors.grey[600]),
                ),
              ),
              // Position for floating action button
              Positioned(
                right: 0.0,
                bottom: 20.0,
                child: SizedBox(
                  height: 75,
                  width: 75,
                  // button to create new task then refresh state
                  child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskView(task: null)))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightBlue[900]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
