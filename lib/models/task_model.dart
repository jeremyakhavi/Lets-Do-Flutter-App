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
