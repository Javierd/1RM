import 'dart:io';

import 'package:calculator_1rm/presenters/main_presenter.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'moor_database.g.dart';


class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 140)();
}

class Records extends Table {

  IntColumn get id => integer().autoIncrement()();
  IntColumn get exercise => integer().customConstraint('REFERENCES exercises(id)')();

  IntColumn get reps => integer()();
  RealColumn get weight => real()();
  DateTimeColumn get timestamp => dateTime()();

  TextColumn get description => text().nullable()();

}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Exercises, Records])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  Future<List<Exercise>> getAllExercises() async{
    /* If it's the first time we run the app, insert the basic exercises */
    if (await MainPresenter().isFirstRun){
      await insertExercise(ExercisesCompanion(name: Value("Squat")));
      await insertExercise(ExercisesCompanion(name: Value("Bench Press")));
      await insertExercise(ExercisesCompanion(name: Value("Deadlift")));
    }

    return select(exercises).get();
  }

  Future insertExercise(ExercisesCompanion exercise) => into(exercises).insert(exercise);

  Future deleteExercise(Exercise exercise) => delete(exercises).delete(exercise);

  Future<List<Record>> getExerciseRecords(Exercise ex) => (select(records)..where((r) => r.exercise.equals(ex.id))).get();

  Future insertRecord(RecordsCompanion record) => into(records).insert(record);

}