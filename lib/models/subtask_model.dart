// model for sub-tasks allowing them to be stored in sql database
// includes task ID allowing each sub-task to be associated with a task

class SubTask {
  final int id;
  final int taskID;
  final String subTaskTitle;
  final int complete;
  SubTask({this.id, this.taskID, this.subTaskTitle, this.complete});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskID': taskID,
      'subTaskTitle': subTaskTitle,
      'complete': complete,
    };
  }
}
