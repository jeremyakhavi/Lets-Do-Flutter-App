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
