
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TaskEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  String _getUserIdentifier(Session session) {
    final auth = session.authenticated;

    if (auth == null) {
      throw Exception('Please sign in to continue.');
    }

    return auth.userIdentifier;
  }

  Future<List<DayTask>> getTasks(Session session) async {
    final userIdentifier = _getUserIdentifier(session);

    return DayTask.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );
  }

  Future<DayTask> addTask(
    Session session, {
    required String title,
    String? description,
    required int durationMinutes,
    required int priority,
  }) async {
    final userIdentifier = _getUserIdentifier(session);

    final task = DayTask(
      title: title,
      description: description,
      durationMinutes: durationMinutes,
      priority: priority,
      isCompleted: false,
      createdAt: DateTime.now(),
      userIdentifier: userIdentifier,
    );

    return DayTask.db.insertRow(session, task);
  }

  Future<DayTask> updateTask(
    Session session,
    DayTask task,
  ) async {
    final userIdentifier = _getUserIdentifier(session);

    if (task.id == null) {
      throw Exception('Invalid task.');
    }

    final existing = await DayTask.db.findById(session, task.id!);

    if (existing == null ||
        existing.userIdentifier != userIdentifier) {
      throw Exception('Task not found or access denied.');
    }

    existing
      ..title = task.title
      ..description = task.description
      ..durationMinutes = task.durationMinutes
      ..priority = task.priority
      ..isCompleted = task.isCompleted;

    return DayTask.db.updateRow(session, existing);
  }

  Future<bool> deleteTask(
    Session session,
    int taskId,
  ) async {
    final userIdentifier = _getUserIdentifier(session);

    final task = await DayTask.db.findById(session, taskId);

    if (task == null ||
        task.userIdentifier != userIdentifier) {
      return false;
    }

    await DayTask.db.deleteRow(session, task);
    return true;
  }
}
