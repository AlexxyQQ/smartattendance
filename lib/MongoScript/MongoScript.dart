// Import the necessary packages
import 'package:mongo_dart/mongo_dart.dart';
import 'package:smartattendance/others/constant.dart';
import 'dart:math';

void mainss() async {
  // Connect to the database
  final db = await Db.create(MONGO_URL);
  await db.open();

  // Define the classes

  final classes = [
    {
      "name": "Creative Thinking For Business",
      "cid": "STA103IAE",
      "lecturer": "Arun Phuyal",
      "weeks": 13,
      "lessons": 77,
      "type": "Lecture",
      "cancelled": false,
      "place": "LR-8",
      "year": 1,
      "time": {"start": "9:00 AM", "end": "11:00 AM"},
      "date": "2023-02-17"
    },
    {
      "name": "Be Your Own Boss",
      "cid": "STA201IAE",
      "lecturer": "Samip Pandey",
      "weeks": 13,
      "lessons": 15,
      "type": "Lecture",
      "cancelled": false,
      "place": "LR-12",
      "year": 2,
      "time": {"start": "9:00 AM", "end": "11:00 AM"},
      "date": "2023-02-17"
    },
    {
      "name": "People And Computing",
      "cid": "ST5006CEM",
      "lecturer": "Manish Khanal",
      "weeks": 14,
      "lessons": 55,
      "type": "Lecture",
      "cancelled": false,
      "place": "LR-14",
      "year": 2,
      "time": {"start": "7:00 AM", "end": "8:00 AM"},
      "date": "2023-02-18"
    },
    {
      "name": "Enterprise Project",
      "cid": "ST5010CEM",
      "lecturer": "Shrawan Thakur",
      "weeks": 11,
      "lessons": 9,
      "type": "Lecture",
      "cancelled": false,
      "place": "LR-12",
      "year": 2,
      "time": {"start": "7:00 AM", "end": "9:00 AM"},
      "date": "2023-02-20"
    },
    {
      "name": "Data Science For Developers",
      "cid": "ST5014CEM",
      "lecturer": "Siddhartha Neupane",
      "weeks": 13,
      "lessons": 30,
      "type": "Lecture",
      "cancelled": false,
      "place": "LR-14",
      "year": 2,
      "time": {"start": "8:00 AM", "end": "9:00 AM"},
      "date": "2023-02-16"
    },
  ];

  // Insert the classes into the 'classes' collection
  try {
    await db.collection('classes').insertAll(classes);
  } catch (e) {
    print(e);
  }

  // Define the students
  final students = List.generate(80, (i) {
    var rng = Random();
    int age = 18 + rng.nextInt(30 - 18);
    int cc = 0 + rng.nextInt(3 - 1);
    int counts = 1 + rng.nextInt(6 - 1);
    List<String> classIds = [];
    if (cc == 0) {
      // randomly select up to 3 classes for each student
      for (var j = 0; j < counts; j++) {
        var classIndex = rng.nextInt(classes.length);
        var classId = classes[classIndex]["cid"] as String;
        classIds.add(classId);
      }
    }
    return {
      "name": "Student $i",
      "age": age,
      "classes": classIds,
    };
  });

  // // Insert the students into the 'students' collection
  try {
    await db.collection('students').insertAll(students);
  } catch (e) {
    print(e);
  }

  // Close the database connection
  await db.close();
}
