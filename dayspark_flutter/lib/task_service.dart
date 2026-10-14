import 'package:dayspark_client/dayspark_client.dart' as serverpod;
import 'client.dart';

class TaskService {
  Future<List<serverpod.DayTask>> getTasks() async {
    return await client.task.getTasks();
  }

  Future<serverpod.DayTask> addTask({
    required String title,
    String? category,
    required int durationMinutes,
    required String priority,
  }) async {
    return await client.task.addTask(
      title: title,
      description: category,
      durationMinutes: durationMinutes,
      priority: _priorityToInt(priority),
    );
  }

  Future<serverpod.DayTask> updateTask(
    serverpod.DayTask task,
  ) async {
    return await client.task.updateTask(task);
  }

  Future<bool> deleteTask(int taskId) async {
    return await client.task.deleteTask(taskId);
  }

  int _priorityToInt(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 2;
    }
  }
}