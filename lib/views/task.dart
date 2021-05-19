import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/services/database.dart';
import 'package:to_do_app/models/picture_model.dart';
import 'package:to_do_app/models/subtask_model.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/views/home.dart';
import 'package:to_do_app/widgets.dart';
import 'package:to_do_app/services/utility.dart';

/*
TaskView is a class allowing individual tasks to be viewed in detail,
edited, updated and removed
*/

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

  // focus nodes to allow focus to be changed to next field
  FocusNode _focusTitle, _focusDescription, _focusSubTask;
  bool showContent = false;
  DatabaseHelper _dbClient = DatabaseHelper();

  @override
  void initState() {
    super.initState();
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
  }

  // function to display images from database
  refreshImages() async {
    _dbClient.displayPhotos(_taskID).then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  // function to dispose all focuses
  void disposeFocus() {
    _focusTitle.dispose();
    _focusDescription.dispose();
    _focusSubTask.dispose();
  }

  // function uses Intent and ImagePicker to get permissions and open camera
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        // get image captured, convert, and store in database
        print(pickedFile.path.runtimeType);
        _image = File(pickedFile.path);
        String imgString = Utility.base64String(_image.readAsBytesSync());
        Photo photo = Photo(id: 0, taskID: _taskID, picture: imgString);
        _dbClient.savePicture(photo);
        refreshImages();
      } else {
        print("No image found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                        child: BackButton(
                          onPressed: () {
                            // update database title with most up-to-date value
                            if (_titleController.text != "") {
                              _dbClient.updateTitle(
                                  _taskID, _titleController.text);
                            }
                            if (_descriptionController.text != "") {
                              if (_taskID != 0) {
                                _dbClient.updateDescription(
                                    _taskID, _descriptionController.text);
                              }
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                        )),

                    Expanded(
                      // Text field for title of task
                      child: Focus(
                        onFocusChange: (value) async {
                          if (!value) {
                            // instantiate Task object to add to task table in database
                            // ensure that field is not empty
                            if (_titleController.text != "") {
                              // check if received task from home view is null
                              // if null then create new task
                              if (widget.task == null) {
                                Task _newTask =
                                    Task(taskTitle: _titleController.text);
                                _taskID = await _dbClient.addTask(_newTask);
                                setState(() {
                                  showContent = true;
                                  _title = _titleController.text;
                                });
                              } else {
                                // update title if task is not null
                                _dbClient.updateTitle(
                                    _taskID, _titleController.text);
                                setState(() {
                                  _title = _titleController.text;
                                });
                              }
                            }
                          }
                        },
                        child: TextField(
                          focusNode: _focusTitle,
                          onSubmitted: (value) {
                            // change focus to description
                            _focusDescription.requestFocus();
                          },
                          // populate text field with task title from database
                          controller: _titleController..text = _title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Task Title (tap enter)",
                          ),
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
                    child: Focus(
                      onFocusChange: (value) async {
                        if (!value) {
                          if (_descriptionController.text != "") {
                            // if task is valid then update description
                            if (_taskID != 0) {
                              _dbClient.updateDescription(
                                  _taskID, _descriptionController.text);
                            }
                          }
                          setState(() {
                            _description = _descriptionController.text;
                          });
                        }
                      },
                      child: TextField(
                        onSubmitted: (value) {
                          _focusSubTask.requestFocus();
                        },
                        // populate text field with description value in database
                        controller: _descriptionController..text = _description,
                        focusNode: _focusDescription,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description for task"),
                      ),
                    ),
                  ),
                ),

                /*
                THE BELOW IS CODE TO SHOW IMAGES IN TASKS, I DIDN'T HAVE TIME TO
                GET IT WORKING, BUT I WAS ALMOST THERE         
                Visibility(
                  visible: showContent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Picture()),
                      );
                    },
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbClient.displayPhotos(_taskID),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 200,
                                padding: EdgeInsets.all(5.0),
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: snapshot.data[index]['picture'],
                                      fit: BoxFit.cover),
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ), 
                */
                const Divider(
                  height: 0,
                  thickness: 2.5,
                  indent: 20,
                  endIndent: 20,
                ),
                // SUB-TASK SECTION
                // text-field to add new sub-tasks
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
                                  // create new SubTask object and add to database
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
                                hintText: ("New sub-task... (tap enter)")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // List of CheckListWidgets to view and interact with sub-tasks
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
                      // i.e. get image path etc.
                      // onPressed: () => android_intent.Intent()
                      //   ..setAction(android_action.Action.ACTION_IMAGE_CAPTURE)
                      //   ..startActivityForResult().then(
                      //     (data) => print(data),
                      //     onError: (e) => print(e.toString()),
                      //   ),
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
                        // check task is valid, then remove task and go back to home
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
