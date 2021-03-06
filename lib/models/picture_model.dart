// model for photos, allowing photos to be easily stored in sql database

class Photo {
  final int id;
  final int taskID;
  final String picture;

  Photo({this.id, this.taskID, this.picture});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskID': taskID,
      'picture': picture,
    };
  }
}
