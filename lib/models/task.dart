class Task {
  final int? id;
  final String title;
  final String description;
  final int priority;
  final DateTime dueDate;
  DateTime? reminder;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.reminder,
  });

  // Int to string
  String getPriorityString() {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  // Convert a Task object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
    };
  }

  // Create a Task object from a Map object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      dueDate: DateTime.parse(map['dueDate']),
      reminder:
          map['reminder'] != null ? DateTime.parse(map['reminder']) : null,
    );
  }
}
