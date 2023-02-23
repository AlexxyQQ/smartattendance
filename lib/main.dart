import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:intl/intl.dart';
import 'package:smartattendance/model/mongo_db.dart';
import 'package:smartattendance/widgets/class_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && dark != null) {
          lightColorScheme = lightDynamic
              .harmonized()
              .copyWith(secondary: const Color(0XFF171A9E));
          darkColorScheme = dark.harmonized();
        } else {
          lightColorScheme =
              ColorScheme.fromSeed(seedColor: const Color(0XFF171A9E));
          darkColorScheme = ColorScheme.fromSeed(
              seedColor: const Color(0XFF171A9E), brightness: Brightness.dark);
        }

        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
          ),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(
            title: 'Dashboard',
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String time;
  late Future<List<dynamic>> classes = MongoDatabase.collectClasses();

  @override
  void initState() {
    super.initState();
    time = DateFormat('yy-MM-dd hh:mm a').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getCurrentTime());
  }

  @override
  void dispose() {
    getCurrentTime();
    super.dispose();
  }

  void getCurrentTime() {
    time = DateFormat('yy-MM-dd hh:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 40)),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(time, style: const TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  classes = MongoDatabase.collectClasses();
                });
              },
              child: FutureBuilder<List<dynamic>>(
                future: classes,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error while fetching data.'),
                    );
                  } else {
                    final List<dynamic> data = snapshot.data ?? [];
                    return ClassListView(data: data);
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
