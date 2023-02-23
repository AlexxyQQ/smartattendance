import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartattendance/model/mongo_db.dart';
import 'package:smartattendance/widgets/student_list_view.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class StudentsList extends StatefulWidget {
  final List<String> classId;
  const StudentsList({Key? key, required this.classId}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  static InAppWebViewController? webViewController;

  late Future<List<dynamic>> students =
      MongoDatabase.collectStudents(widget.classId);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students", style: TextStyle(fontSize: 40)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 200,
              width: 400,
              child: InAppWebView(
                pullToRefreshController: PullToRefreshController(
                  options: PullToRefreshOptions(
                    color: Colors.red,
                  ),
                  onRefresh: () async {
                    setState(() {
                      students = MongoDatabase.collectStudents(widget.classId);
                    });
                  },
                ),
                initialUrlRequest: URLRequest(
                    url: Uri.parse('http://192.168.100.160:8000/video_feed')),
                onWebViewCreated: (controller) {
                  if (webViewController != null) {
                    webViewController!;
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  students = MongoDatabase.collectStudents(widget.classId);
                });
              },
              child: FutureBuilder<List<dynamic>>(
                future: students,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error while fetching data.'),
                      );
                    } else {
                      final List<dynamic> data = snapshot.data ?? [];
                      return StudentsListView(
                          data: data, classID: widget.classId[0]);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
