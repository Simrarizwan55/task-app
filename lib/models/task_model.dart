
class TaskModel{
  final int id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime ? dueDate;
  TaskModel( {
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted=false,
     this.dueDate,

  });
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: int.parse(map["id"]),
      title: map["title"],
      description: map["description"],
      dueDate: DateTime.tryParse(map["dueDate"].toString()),
    );
  }
}