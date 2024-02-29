const String tableName = "todo";

class TodoFields {
  static List<String>? values = [id, title, description, isImportant, time];
  static const String id = "_id";
  static const String title = "title";
  static const String description = "description";
  static const String isImportant = "isImportant";
  static const String time = "time";
}

class TodoModel {
  final int? id;
  final String title;
  final String description;
  final bool isImportant;
  final DateTime createdTime;

  TodoModel(
      {this.id,
      required this.title,
      required this.description,
      required this.isImportant,
      required this.createdTime});

  static TodoModel fromJson(Map<String, Object?> json) => TodoModel(
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        id: json[TodoFields.id] as int?,
        isImportant: json[TodoFields.isImportant] == 1,
        createdTime: DateTime.parse(json[TodoFields.time] as String),
      );

  Map<String, dynamic> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.isImportant: isImportant ? 1 : 0,
        TodoFields.time: createdTime.toIso8601String()
      };
  TodoModel copy({
    int? id,
    String? title,
    String? description,
    bool? isImportant,
    DateTime? createdTime,
  }) =>
      TodoModel(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          isImportant: isImportant ?? this.isImportant,
          createdTime: createdTime ?? this.createdTime);
}
