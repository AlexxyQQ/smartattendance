import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartattendance/model/mongo_db.dart';

class StudentsListView extends StatelessWidget {
  final List<dynamic> data;
  final String classID;

  const StudentsListView({Key? key, required this.data, required this.classID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final dynamic item = data[index];
        final attendance = item[formattedDate];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () async {
              await MongoDatabase.attendance(classID, item['name']);
            },
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: attendance == null
                ? const Color(0xFFcd577d)
                : const Color(0xFF40826d),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item['name'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              subtitle: Text(
                "Age: ${item['age']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
