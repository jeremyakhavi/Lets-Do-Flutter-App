import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/database.dart';
import 'package:to_do_app/models/picture_model.dart';
import 'package:to_do_app/models/subtask_model.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/views/picture.dart';
import 'package:to_do_app/widgets.dart';
import 'package:to_do_app/utility.dart';

class TaskView extends StatefulWidget {
  final Task task;
  TaskView({@required this.task});
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String _title = "";
  int _taskID = 0;
  String _description = "";
  File _image;
  List<Photo> images;
  Base64Codec base64 = Base64Codec();
  final picker = ImagePicker();

  Future getImage() async {
    print("Function running");
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path.runtimeType);
        _image = File(pickedFile.path);
        String imgString = Utility.base64String(_image.readAsBytesSync());
        Photo photo = Photo(id: 0, taskID: _taskID, picture: imgString);
        _dbClient.savePicture(photo);
        refreshImages();
      } else {
        print("No image selected");
      }
    });
  }

  // focus nodes to allow focus to be changed to next field
  FocusNode _focusTitle, _focusDescription, _focusSubTask;
  bool showContent = false;
  DatabaseHelper _dbClient = DatabaseHelper();

  @override
  void initState() {
    if (widget.task != null) {
      _title = widget.task.taskTitle;
      _taskID = widget.task.id;
      _description = widget.task.taskDescription;
      // show description, subtasks and delete if existing task
      showContent = true;
    }
    images = [];
    _focusTitle = FocusNode();
    _focusDescription = FocusNode();
    _focusSubTask = FocusNode();
    //refreshImages();
    super.initState();
  }

  refreshImages() async {
    _dbClient.displayPhotos(_taskID).then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
        print(images);
        print(imgs.runtimeType);
      });
    });
  }

  void disposeFocus() {
    _focusTitle.dispose();
    _focusDescription.dispose();
    _focusSubTask.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // light indigo background colour, stretching across full width
          color: Colors.indigo[50],
          width: double.infinity,
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Back button to return to home screen
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BackButton(),
                    ),
                    Expanded(
                      // Text field for title of task
                      child: TextField(
                        focusNode: _focusTitle,
                        onSubmitted: (value) async {
                          // instantiate Task object to add to task table in database
                          // ensure that field is not empty
                          if (value != "") {
                            // check if received task from home view is null
                            if (widget.task == null) {
                              Task _newTask = Task(taskTitle: value);

                              _taskID = await _dbClient.addTask(_newTask);
                              setState(() {
                                showContent = true;
                                _title = value;
                              });
                            } else {
                              _dbClient.updateTitle(_taskID, value);
                            }
                            _focusDescription.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Task Title",
                        ),
                      ),
                    ),
                  ],
                ),
                // Text field for task description
                Visibility(
                  visible: showContent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                    child: TextField(
                      onSubmitted: (value) {
                        if (value != "") {
                          if (_taskID != 0) {
                            _dbClient.updateDescription(_taskID, value);
                          }
                        }
                        setState(() {
                          _description = value;
                        });
                        _focusSubTask.requestFocus();
                      },
                      controller: TextEditingController()..text = _description,
                      focusNode: _focusDescription,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description for task"),
                    ),
                  ),
                ),
                // Visibility(
                //   visible: showContent,
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => Picture()),
                //       );
                //     },
                //     child: FutureBuilder(
                //         initialData: [],
                //         future: _dbClient.displayPhotos(_taskID),
                //         builder: (context, snapshot) {
                //           return ListView.builder(
                //             itemCount: snapshot.data.length,
                //             itemBuilder: (context, index) {
                //               return Container(
                //                 height: 200,
                //                 padding: EdgeInsets.all(5.0),
                //                 decoration: new BoxDecoration(
                //                   image: new DecorationImage(
                //                       image: snapshot.data[index]['picture'],
                //                       fit: BoxFit.cover),
                //                 ),
                //               );
                //             },
                //           );
                //         }),
                //   ),
                // ),
                const Divider(
                  height: 0,
                  thickness: 2.5,
                  indent: 20,
                  endIndent: 20,
                ),
                Visibility(
                  visible: showContent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          // text field for sub task input
                          child: TextField(
                            focusNode: _focusSubTask,
                            onSubmitted: (value) async {
                              if (value != "") {
                                // check if received task from home view is null
                                if (_taskID != 0) {
                                  SubTask _newSubTask = SubTask(
                                    subTaskTitle: value,
                                    complete: 0,
                                    taskID: _taskID,
                                  );
                                  await _dbClient.addSubTask(_newSubTask);
                                  setState(() {});
                                }
                              }
                            },
                            // clear input field when subTask submitted
                            controller: TextEditingController()..text = "",
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ("New sub-task...")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showContent,
                  child: FutureBuilder(
                      initialData: [],
                      future: _dbClient.displaySubTasks(_taskID),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                // retrieve sub task info from database snapshot
                                return CheckListWidget(
                                  taskID: snapshot.data[index].id,
                                  subTask: snapshot.data[index].subTaskTitle,
                                  complete: snapshot.data[index].complete != 0
                                      ? true
                                      : false,
                                );
                              }),
                        );
                      }),
                ),
              ],
            ),
            // add photo button on bottom left of task page
            Visibility(
              visible: showContent,
              child: Positioned(
                left: 25.0,
                bottom: 25.0,
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: FloatingActionButton(
                      heroTag: "cameraBtn",
                      onPressed: getImage,
                      child: const Icon(Icons.camera_alt),
                      backgroundColor: Colors.blue[700]),
                ),
              ),
            ),
            // delete button at bottom of task page
            Visibility(
              visible: showContent,
              child: Positioned(
                right: 25.0,
                bottom: 25.0,
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: FloatingActionButton(
                      heroTag: "deleteBtn",
                      onPressed: () async {
                        if (_taskID != 0) {
                          _dbClient.removeTask(_taskID);
                          Navigator.pushNamed(context, '/');
                        }
                      },
                      child: const Icon(Icons.delete),
                      backgroundColor: Colors.red[700]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
