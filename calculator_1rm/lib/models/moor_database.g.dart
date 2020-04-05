// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  Exercise({@required this.id, @required this.name});
  factory Exercise.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Exercise(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  ExercisesCompanion createCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Exercise copyWith({int id, String name}) => Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Exercise && other.id == this.id && other.name == this.name);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  ExercisesCompanion copyWith({Value<int> id, Value<String> name}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExercisesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 140);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $ExercisesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'exercises';
  @override
  final String actualTableName = 'exercises';
  @override
  VerificationContext validateIntegrity(ExercisesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Exercise.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ExercisesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(_db, alias);
  }
}

class Record extends DataClass implements Insertable<Record> {
  final int id;
  final int exercise;
  final int reps;
  final double weight;
  final DateTime timestamp;
  final String description;
  Record(
      {@required this.id,
      @required this.exercise,
      @required this.reps,
      @required this.weight,
      @required this.timestamp,
      this.description});
  factory Record.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return Record(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      exercise:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}exercise']),
      reps: intType.mapFromDatabaseResponse(data['${effectivePrefix}reps']),
      weight:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}weight']),
      timestamp: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
    );
  }
  factory Record.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Record(
      id: serializer.fromJson<int>(json['id']),
      exercise: serializer.fromJson<int>(json['exercise']),
      reps: serializer.fromJson<int>(json['reps']),
      weight: serializer.fromJson<double>(json['weight']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exercise': serializer.toJson<int>(exercise),
      'reps': serializer.toJson<int>(reps),
      'weight': serializer.toJson<double>(weight),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'description': serializer.toJson<String>(description),
    };
  }

  @override
  RecordsCompanion createCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      exercise: exercise == null && nullToAbsent
          ? const Value.absent()
          : Value(exercise),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  Record copyWith(
          {int id,
          int exercise,
          int reps,
          double weight,
          DateTime timestamp,
          String description}) =>
      Record(
        id: id ?? this.id,
        exercise: exercise ?? this.exercise,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        timestamp: timestamp ?? this.timestamp,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('id: $id, ')
          ..write('exercise: $exercise, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('timestamp: $timestamp, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          exercise.hashCode,
          $mrjc(
              reps.hashCode,
              $mrjc(weight.hashCode,
                  $mrjc(timestamp.hashCode, description.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Record &&
          other.id == this.id &&
          other.exercise == this.exercise &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.timestamp == this.timestamp &&
          other.description == this.description);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<int> id;
  final Value<int> exercise;
  final Value<int> reps;
  final Value<double> weight;
  final Value<DateTime> timestamp;
  final Value<String> description;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.exercise = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.description = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    @required int exercise,
    @required int reps,
    @required double weight,
    @required DateTime timestamp,
    this.description = const Value.absent(),
  })  : exercise = Value(exercise),
        reps = Value(reps),
        weight = Value(weight),
        timestamp = Value(timestamp);
  RecordsCompanion copyWith(
      {Value<int> id,
      Value<int> exercise,
      Value<int> reps,
      Value<double> weight,
      Value<DateTime> timestamp,
      Value<String> description}) {
    return RecordsCompanion(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
    );
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  final GeneratedDatabase _db;
  final String _alias;
  $RecordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _exerciseMeta = const VerificationMeta('exercise');
  GeneratedIntColumn _exercise;
  @override
  GeneratedIntColumn get exercise => _exercise ??= _constructExercise();
  GeneratedIntColumn _constructExercise() {
    return GeneratedIntColumn('exercise', $tableName, false,
        $customConstraints: 'REFERENCES exercises(id)');
  }

  final VerificationMeta _repsMeta = const VerificationMeta('reps');
  GeneratedIntColumn _reps;
  @override
  GeneratedIntColumn get reps => _reps ??= _constructReps();
  GeneratedIntColumn _constructReps() {
    return GeneratedIntColumn(
      'reps',
      $tableName,
      false,
    );
  }

  final VerificationMeta _weightMeta = const VerificationMeta('weight');
  GeneratedRealColumn _weight;
  @override
  GeneratedRealColumn get weight => _weight ??= _constructWeight();
  GeneratedRealColumn _constructWeight() {
    return GeneratedRealColumn(
      'weight',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedDateTimeColumn _timestamp;
  @override
  GeneratedDateTimeColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedDateTimeColumn _constructTimestamp() {
    return GeneratedDateTimeColumn(
      'timestamp',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, exercise, reps, weight, timestamp, description];
  @override
  $RecordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'records';
  @override
  final String actualTableName = 'records';
  @override
  VerificationContext validateIntegrity(RecordsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.exercise.present) {
      context.handle(_exerciseMeta,
          exercise.isAcceptableValue(d.exercise.value, _exerciseMeta));
    } else if (isInserting) {
      context.missing(_exerciseMeta);
    }
    if (d.reps.present) {
      context.handle(
          _repsMeta, reps.isAcceptableValue(d.reps.value, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (d.weight.present) {
      context.handle(
          _weightMeta, weight.isAcceptableValue(d.weight.value, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (d.timestamp.present) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableValue(d.timestamp.value, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Record map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Record.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(RecordsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.exercise.present) {
      map['exercise'] = Variable<int, IntType>(d.exercise.value);
    }
    if (d.reps.present) {
      map['reps'] = Variable<int, IntType>(d.reps.value);
    }
    if (d.weight.present) {
      map['weight'] = Variable<double, RealType>(d.weight.value);
    }
    if (d.timestamp.present) {
      map['timestamp'] = Variable<DateTime, DateTimeType>(d.timestamp.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    return map;
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ExercisesTable _exercises;
  $ExercisesTable get exercises => _exercises ??= $ExercisesTable(this);
  $RecordsTable _records;
  $RecordsTable get records => _records ??= $RecordsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [exercises, records];
}
