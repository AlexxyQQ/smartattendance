import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartattendance/pages/studnets.dart';

class ClassListView extends StatelessWidget {
  final List<dynamic> data;

  const ClassListView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final dynamic item = data[index];
        final now = DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd').format(now);

        if (formattedDate != item['date']) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsList(classId: [item['cid']]),
                  ),
                );
              },
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: item['cancelled']!
                  ? const Color(0xFFcd577d)
                  : const Color(0xFF40826d),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    item['name'] ?? 'No class name',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: RichText(
                    text: TextSpan(
                      text: 'Lecturer: ',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: item['lecturer'] ?? 'No teacher name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Time: ',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${item['time']['start']} - ${item['time']['end']} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: RichText(
                        text: TextSpan(
                          text: 'Place: ',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: item['place'] ?? 'No place name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
