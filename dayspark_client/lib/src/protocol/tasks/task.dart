/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class DayTask
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DayTask._({
    this.id,
    required this.title,
    this.description,
    required this.durationMinutes,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.userIdentifier,
  });

  factory DayTask({
    int? id,
    required String title,
    String? description,
    required int durationMinutes,
    required int priority,
    required bool isCompleted,
    required DateTime createdAt,
    String? userIdentifier,
  }) = _DayTaskImpl;

  factory DayTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayTask(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      priority: jsonSerialization['priority'] as int,
      isCompleted: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isCompleted'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? description;

  int durationMinutes;

  int priority;

  bool isCompleted;

  DateTime createdAt;

  String? userIdentifier;

  /// Returns a shallow copy of this [DayTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DayTask copyWith({
    int? id,
    String? title,
    String? description,
    int? durationMinutes,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayTask',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'durationMinutes': durationMinutes,
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DayTask',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'durationMinutes': durationMinutes,
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DayTaskImpl extends DayTask {
  _DayTaskImpl({
    int? id,
    required String title,
    String? description,
    required int durationMinutes,
    required int priority,
    required bool isCompleted,
    required DateTime createdAt,
    String? userIdentifier,
  }) : super._(
         id: id,
         title: title,
         description: description,
         durationMinutes: durationMinutes,
         priority: priority,
         isCompleted: isCompleted,
         createdAt: createdAt,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [DayTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DayTask copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? durationMinutes,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
    Object? userIdentifier = _Undefined,
  }) {
    return DayTask(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
    );
  }
}
