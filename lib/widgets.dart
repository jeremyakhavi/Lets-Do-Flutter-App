import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do_app/services/database.dart';

/*
File of widgets being used across the application
*/

// Widget for individual tasks on home page
class TaskWidget extends StatelessWidget {
  final String taskTitle;
  final String taskDescription;
  TaskWidget({this.taskTitle, this.taskDescription});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 25.0,
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // display task title in widget
          Text(
            // if no task title then default to "task"
            taskTitle ?? "Task",
            style: TextStyle(
              color: Colors.lightBlue[900],
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // display task description in widget
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              // if no description then default to "No description..."
              taskDescription ?? "No description for this task",
              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}

// CheckListWidget to show each subtask as an object that can be ticked off
// ignore: must_be_immutable
class CheckListWidget extends StatefulWidget {
  final String subTask;
  final int taskID;
  bool complete;
  CheckListWidget({this.taskID, this.subTask, @required this.complete});
  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  // initialise database content provider
  DatabaseHelper _dbClient = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: CheckboxListTile(
          // set value of checkbox to complete value in database
          value: widget.complete,
          // set text to subtask value, if none then show '(no sub task)'
          title: Text(
            widget.subTask ?? "(No sub task)",
            // grey out and strikethrough completed sub-tasks
            style: TextStyle(
              color: widget.complete ? Colors.grey : Colors.black,
              decoration: widget.complete ? TextDecoration.lineThrough : null,
              decorationThickness: 1.75,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) async {
            print(value);
            // if not complete, then change to 0 (incomplete) in database
            if (value == false) {
              await _dbClient.updateSubTask(widget.taskID, 0);
              // else if complete, then change to 1 (compelete) in database
            } else {
              await _dbClient.updateSubTask(widget.taskID, 1);
            }
            setState(() {
              widget.complete = value;
            });
          },
        ),
      );
    });
  }
}

// found code online to remove glow when scrolling
// https://flutteragency.com/remove-scrollglow-in-flutter/
class RemoveGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// loading widget to be used when logging in or registering
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: Center(
        child: SpinKitChasingDots(color: Colors.blue, size: 60.0),
      ),
    );
  }
}

// contstant for text input decorations used for email and password fields
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
  ),
);
