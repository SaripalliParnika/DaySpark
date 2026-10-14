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
import 'package:serverpod/serverpod.dart' as _is;

abstract class DayTask
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      isCompleted: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isCompleted'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
    );
  }

  static final t = DayTaskTable();

  static const db = DayTaskRepository._();

  @override
  int? id;

  String title;

  String? description;

  int durationMinutes;

  int priority;

  bool isCompleted;

  DateTime createdAt;

  String? userIdentifier;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DayTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static DayTaskInclude include() {
    return DayTaskInclude._();
  }

  static DayTaskIncludeList includeList({
    _is.WhereExpressionBuilder<DayTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    DayTaskInclude? include,
  }) {
    return DayTaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class DayTaskUpdateTable extends _is.UpdateTable<DayTaskTable> {
  DayTaskUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> durationMinutes(int value) => _is.ColumnValue(
    table.durationMinutes,
    value,
  );

  _is.ColumnValue<int, int> priority(int value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<bool, bool> isCompleted(bool value) => _is.ColumnValue(
    table.isCompleted,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> userIdentifier(String? value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class DayTaskTable extends _is.Table<int?> {
  DayTaskTable({super.tableRelation}) : super(tableName: 'day_task') {
    updateTable = DayTaskUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    durationMinutes = _is.ColumnInt(
      'durationMinutes',
      this,
    );
    priority = _is.ColumnInt(
      'priority',
      this,
    );
    isCompleted = _is.ColumnBool(
      'isCompleted',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final DayTaskUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnInt durationMinutes;

  late final _is.ColumnInt priority;

  late final _is.ColumnBool isCompleted;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnString userIdentifier;

  @override
  List<_is.Column> get columns => [
    id,
    title,
    description,
    durationMinutes,
    priority,
    isCompleted,
    createdAt,
    userIdentifier,
  ];
}

class DayTaskInclude extends _is.IncludeObject {
  DayTaskInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DayTask.t;
}

class DayTaskIncludeList extends _is.IncludeList {
  DayTaskIncludeList._({
    _is.WhereExpressionBuilder<DayTaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DayTask.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DayTask.t;
}

class DayTaskRepository {
  const DayTaskRepository._();

  /// Returns a list of [DayTask]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DayTask>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DayTask>(
      where: where?.call(DayTask.t),
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DayTask] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DayTask?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayTaskTable>? where,
    int? offset,
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DayTask>(
      where: where?.call(DayTask.t),
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DayTask] by its [id] or null if no such row exists.
  Future<DayTask?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DayTask>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DayTask]s in the list and returns the inserted rows.
  ///
  /// The returned [DayTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> insert(
    _is.DatabaseSession session,
    List<DayTask> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DayTask>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DayTask] and returns the inserted row.
  ///
  /// The returned [DayTask] will have its `id` field set.
  Future<DayTask> insertRow(
    _is.DatabaseSession session,
    DayTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DayTask>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DayTask]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [DayTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> upsert(
    _is.DatabaseSession session,
    List<DayTask> rows, {
    required _is.ColumnSelections<DayTaskTable> conflictColumns,
    _is.ColumnSelections<DayTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<DayTaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DayTask>(
      rows,
      conflictColumns: conflictColumns(DayTask.t),
      updateColumns: updateColumns?.call(DayTask.t),
      updateWhere: updateWhere?.call(DayTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DayTask] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [DayTask] will have its `id` field set.
  Future<DayTask?> upsertRow(
    _is.DatabaseSession session,
    DayTask row, {
    required _is.ColumnSelections<DayTaskTable> conflictColumns,
    _is.ColumnSelections<DayTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<DayTaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DayTask>(
      row,
      conflictColumns: conflictColumns(DayTask.t),
      updateColumns: updateColumns?.call(DayTask.t),
      updateWhere: updateWhere?.call(DayTask.t),
      transaction: transaction,
    );
  }

  /// Updates all [DayTask]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> update(
    _is.DatabaseSession session,
    List<DayTask> rows, {
    _is.ColumnSelections<DayTaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DayTask>(
      rows,
      columns: columns?.call(DayTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DayTask]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DayTask> updateRow(
    _is.DatabaseSession session,
    DayTask row, {
    _is.ColumnSelections<DayTaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DayTask>(
      row,
      columns: columns?.call(DayTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DayTask] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DayTask?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DayTaskUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DayTask>(
      id,
      columnValues: columnValues(DayTask.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DayTask]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DayTaskUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DayTaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DayTask>(
      columnValues: columnValues(DayTask.t.updateTable),
      where: where(DayTask.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DayTask]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> delete(
    _is.DatabaseSession session,
    List<DayTask> rows, {
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DayTask>(
      rows,
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DayTask].
  Future<DayTask> deleteRow(
    _is.DatabaseSession session,
    DayTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DayTask>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayTask>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayTaskTable> where,
    _is.OrderByBuilder<DayTaskTable>? orderBy,
    _is.OrderByListBuilder<DayTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DayTask>(
      where: where(DayTask.t),
      orderBy: orderBy?.call(DayTask.t),
      orderByList: orderByList?.call(DayTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayTaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DayTask>(
      where: where?.call(DayTask.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DayTask] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayTaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DayTask>(
      where: where(DayTask.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
