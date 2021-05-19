import 'package:flutter/material.dart';
import 'package:to_do_app/views/settings.dart';
import 'package:to_do_app/views/task.dart';
import 'package:to_do_app/widgets.dart';
import 'package:to_do_app/services/database.dart';

/* 
HOME VIEW OF APPLICATION, SHOWS ALL TASKS IN LIST, AND HAS BUTTONS TO
ADD NEW TASK, OR OPEN SETTINGS PAGE
from this page the user can tap any task in the list to open it in task view

-- CAPTURE TOUCH GESTURES AND MAKE REASONABLE USE OF THEM
  - long presses are captured here to bring up an alert asking permission to delete all tasks
*/

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // initialise databasehelper for service interactions with database
  DatabaseHelper _dbClient = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // long press touch gesture captured to delete all tasks
        child: GestureDetector(
          onLongPress: () {
            _showDeleteDialog();
          },
          child: Container(
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
                        // use service and content provider to get tasks from db
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
                                  // use TaskWidget (widgets.dart) to display title and description
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
                // Floating settings button in bottom left to open settings page
                Positioned(
                  bottom: 25.0,
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: FloatingActionButton(
                        heroTag: "settingsBtn",
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
                // Floating add button to add new task
                Positioned(
                  right: 0.0,
                  bottom: 20.0,
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    // button to create new task, open taskview, then refresh state
                    child: FloatingActionButton(
                        heroTag: "addBtn",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TaskView(task: null))).then((value) {
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
      ),
    );
  }

  // function to show confirmation alert after long press to delete all tasks
  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      // user must choose an option
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete All"),
          content: Text("Are you sure you want to delete all tasks?"),
          actions: [
            // cancel button to dismiss alert without any action
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            // delete all button to call removeAllTasks method
            TextButton(
                child: Text("Delete All"),
                onPressed: () {
                  _dbClient.removeAllTasks().then((value) {
                    setState(() {});
                  });
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }
}
