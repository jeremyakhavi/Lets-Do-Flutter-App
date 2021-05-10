import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/picture_model.dart';
import 'package:to_do_app/models/subtask_model.dart';

import 'models/task_model.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'letsdo.db'),
      onCreate: (db, version) async {
        // if no table made for tasks then create table
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, taskTitle TEXT, taskDescription TEXT)");
        await db.execute(
            "CREATE TABLE subTasks(id INTEGER PRIMARY KEY, taskID INTEGER, subTaskTitle TEXT, complete INTEGER)");
        await db.execute(
            "CREATE TABLE photos(id INTEGER PRIMARY KEY AUTOINCREMENT, taskID INTEGER, picture TEXT)");
        return db;
      },
      version: 1,
    );
  }

  void savePicture(Photo picture) async {
    print("Saving picture");
    Database _database = await database();
    await _database.insert("photos", picture.toMap());
    print("Picture saved");
  }

  Future<List<Photo>> displayPhotos(int taskID) async {
    Database _database = await database();
    List<Map<String, dynamic>> photoMap =
        await _database.rawQuery("SELECT * FROM photos WHERE taskID = $taskID");
    return List.generate(photoMap.length, (index) {
      return Photo(
        id: photoMap[index]['id'],
        taskID: photoMap[index]['taskID'],
        picture: photoMap[index]['picture'],
      );
    });
  }

  // function to add new task to database
  Future<int> addTask(Task newTask) async {
    int taskID = 0;
    Database _database = await database();
    await _database
        .insert('tasks', newTask.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskID = value;
    });
    return taskID;
  }

  // function to remove task from database
  Future<void> removeTask(int id) async {
    Database _database = await database();
    await _database.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _database.rawDelete("DELETE FROM subTasks WHERE taskID = '$id'");
    await _database.rawDelete("DELETE FROM photos WHERE taskID = '$id'");
  }

  // function to update the title of an existing task
  Future<void> updateTitle(int id, String taskTitle) async {
    Database _database = await database();
    await _database.rawUpdate(
        "UPDATE tasks SET taskTitle = '$taskTitle' WHERE id = '$id'");
  }

  // function to update the description of an existing task
  Future<void> updateDescription(int id, String taskDescription) async {
    Database _database = await database();
    await _database.rawUpdate(
        "UPDATE tasks SET taskDescription = '$taskDescription' WHERE id = '$id'");
  }

  // function to add new sub-task to database
  Future<void> addSubTask(SubTask newSubTask) async {
    Database _database = await database();
    await _database.insert('subTasks', newSubTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // function to update the description of an existing task
  Future<void> updateSubTask(int id, int complete) async {
    Database _database = await database();
    await _database.rawUpdate(
        "UPDATE subTasks SET complete = '$complete' WHERE id = '$id'");
  }

  // function to get tasks from database
  Future<List<Task>> displayTasks() async {
    Database _database = await database();
    List<Map<String, dynamic>> taskMap = await _database.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          taskTitle: taskMap[index]['taskTitle'],
          taskDescription: taskMap[index]['taskDescription']);
    });
  }

  // function to get relevant sub-tasks from database
  Future<List<SubTask>> displaySubTasks(int taskID) async {
    Database _database = await database();
    List<Map<String, dynamic>> subTaskMap = await _database
        .rawQuery("SELECT * FROM subTasks WHERE taskID = $taskID");
    return List.generate(subTaskMap.length, (index) {
      return SubTask(
          id: subTaskMap[index]['id'],
          taskID: subTaskMap[index]['taskID'],
          subTaskTitle: subTaskMap[index]['subTaskTitle'],
          complete: subTaskMap[index]['complete']);
    });
  }
}
