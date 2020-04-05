import 'package:moor/moor.dart';

import 'moor_database.dart';

class ExtendedRecord extends Record{
  double rm;

  ExtendedRecord(
      {@required id,
        @required exercise,
        @required reps,
        @required weight,
        @required timestamp,
        @required this.rm,
        description}) :
        super(id: id,
          exercise: exercise,
          reps: reps,
          weight: weight,
          timestamp: timestamp,
          description: description);

  ExtendedRecord.from(Record record, this.rm):
    super(id: record.id,
        exercise: record.exercise,
        reps: record.reps,
        weight: record.weight,
        timestamp: record.timestamp,
        description: record.description);

}