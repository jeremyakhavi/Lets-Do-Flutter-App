// model for a task, allowing it to be stored and retrieved from sql database

class Task {
  final int id;
  final String taskTitle;
  final String taskDescription;
  Task({this.id, this.taskTitle, this.taskDescription});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
    };
  }
}
