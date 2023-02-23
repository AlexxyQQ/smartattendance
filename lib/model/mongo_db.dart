import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:smartattendance/others/constant.dart';

class MongoDatabase {
  static Future<void> connect() async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    db.close();
  }

  static Future<List<dynamic>> collectClasses() async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection(COLLECTION_NAME);
    final result = await collection.find().toList();
    db.close();
    return result;
  }

  static Future<List<dynamic>> collectStudents(List<String> classIds) async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    final result = await db.collection('students').find({
      "classes": {"\$in": classIds},
    }).toList();
    db.close();
    countSts(classIds[0]);
    return result;
  }

  static Future<void> attendance(String classId, String stsId) async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    final studentCollection = db.collection('students');
    final classCollection = db.collection('classes');

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedDate2 = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);

    final stsFilter = {
      'name': stsId,
      "classes": {
        "\$in": [classId]
      },
    };
    final students = await studentCollection.find(stsFilter).toList();
    final classFilter = {
      "cid": classId,
      'date': formattedDate,
    };

    final classes = await classCollection.find(classFilter).toList();
    if (classes.isEmpty) {
      print('No class found for the current date.');
      db.close();
      return;
    } else {
      final startString = classes[0]['time']['start'];
      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateFormat('hh').parse(startString).hour,
        DateFormat('mm').parse(startString).minute,
      );
      final endString = classes[0]['time']['end'];
      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateFormat('hh').parse(endString).hour,
        DateFormat('mm').parse(endString).minute,
      );

      if (now.isAfter(startTime) && endTime.isBefore(now)) {
        for (final student in students) {
          final attendance = student[formattedDate];
          if (attendance == null) {
            await studentCollection.updateOne(
              where.eq('name', stsId).and(where.eq('id', student['id'])),
              modify.set(
                formattedDate,
                {
                  'date': formattedDate2,
                  'attendance': 'Present',
                  'cid': classId,
                },
              ),
            );
          } else {
            final attDate = DateTime.parse(attendance['date']);
            if (attDate.isAfter(startTime) && endTime.isBefore(attDate)) {
              await studentCollection.updateOne(
                where.eq('name', stsId).and(where.eq('id', student['id'])),
                modify.set(
                  formattedDate,
                  {
                    'date': formattedDate2,
                    'attendance': 'Present',
                    'cid': classId,
                  },
                ),
              );
            } else {
              print('Already marked');
            }
          }
        }
      } else {
        print('The current time is outside of the class time.');
      }

      db.close();
    }
  }

  static countSts(String classId) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int presentCount = 0;
    final db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection('students');
    final result = await collection.find({
      "classes": {
        "\$in": [classId]
      }
    }).toList();
    db.close();
    for (var element in result) {
      if (element[formattedDate] != null) {
        if (element[formattedDate]['cid'] == classId) {
          presentCount++;
        }
      }
    }
    print(presentCount);
  }
}
