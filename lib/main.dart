import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite_crud/student_model.dart';
import 'package:http/http.dart' as http;

import 'db_helper.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Isolates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;
  DBHelper dbHelper;
  List<Student> images;

  @override
  void initState() {
    super.initState();
    //   DBHelper.instance.initDatabase();
    images = [];
    //  callApi2();
    callApi3();
    print('data values');
    // dbHelper = DBHelper();
  }

/*
  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
    });
  }
*/

  /*
  void callApi2() async {
    var recievePort = new ReceivePort();
    await Isolate.spawn(entryPoint1, recievePort.sendPort);
    recievePort.listen((message) async {
      print('callapi2: $message');

      await DBHelper.instance.add(message);
      await DBHelper.instance.getPictures();
      await DBHelper.instance.getCount();
      //  await DBHelper.instance.getPictures();
      print('added successfully');
    });
  }
*/

  void callApi2() async {
    var recievePort = new ReceivePort();
    await Isolate.spawn(entryPoint1, recievePort.sendPort);

    recievePort.listen((message) async {
      print('callapi2: $message');

      await DBHelper.instance.add(message);
      //  await DBHelper.instance.getPictures();
      await DBHelper.instance.getCount();
      //  await DBHelper.instance.getPictures();
      print('added successfully');
    });
  }

  void callApi3() async {
    var recievePort = new ReceivePort();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    print(timestamp);
    var p = 0;
    var iso = ['1', '2'];
    await Isolate.spawn(entryPoint1, recievePort.sendPort);
    await Isolate.spawn(entryPoint2, recievePort.sendPort);
    recievePort.listen((message) async {
      if (message == null) {
        print('Isolate stopped');
      } else {
        print('callapi 2 and 3: $message');
        print('for pic: ${message.pic}');
        print('Isolate:${message.isolate}');
        await DBHelper.instance.add(message).then((value) {
          if (message.isolate == '1' && message.pic == 5) {
            print('done');
          }
          if (message.id == message.pic) {
            print('${message.isolate} is for image${message.pic} occurred');
          }
          if ((message.isolate == '1' || message.isolate == '2') &&
              message.pic == 5) {
            print('Isolate ${message.isolate} completed');
            iso.remove('${message.isolate}');

            print(
                'Isolate ${message.isolate} images added to database successfully');
            p++;
          }
        });
        print('No of isolate added to database:$p');

        await DBHelper.instance.getPictures();
        await DBHelper.instance.getCount();
        print(iso.isEmpty);
        print(iso);
        if (iso.isEmpty == true) {
          print('Isolate finished');
        }
        //  await DBHelper.instance.getPictures();
        print('added successfully');
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        print(timestamp);
      }
    });
  }

  static entryPoint1(SendPort sendPort) async {
    try {
      final List imgList = [
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      ];

      Uint8List _imageBase64;

      var stu;
      var pic = 0;
      var isolate = '2';
      for (int i = 0; i < imgList.length; i++) {
        var response = await http.get(Uri.parse(imgList[i]));

        print('response: ${response.body}');
        if (response.bodyBytes != null) {
          _imageBase64 = response.bodyBytes;
          print('imagebase1: $_imageBase64');
          stu = Student(
            id: i,
            imageData: _imageBase64,
            pic: pic,
            isolate: isolate,
          );
          print('picture1: $stu');
          print('start of database 1');
          // await Databasehelper.instance.initDB();
          //DBHelper.instance.initDatabase();
          //   await DBHelper.instance.add(stu);
          // await DBHelper.add(Student(null, stu));
          sendPort.send(stu);
          pic++;
        }
      }
      print('$pic images for Isolate1 Completed');
      print('Isolate1 completed');
      //sendPort.send(json.decode(response.body));

    } catch (e) {
      print('error is :${e.toString()}');
    }
  }

  static entryPoint2(SendPort sendPort) async {
    try {
      final List imgList = [
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      ];

      Uint8List _imageBase64;
      var menuNames = <int>[];
      var menuIconPath = <String>[];
      var picture;
      var isolate = '1';
      var pic = 0;
      for (int i = 0; i < imgList.length; i++) {
        var response = await http.get(Uri.parse(imgList[i]));
        //  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80'));
        print('response: ${response.body}');
        if (response.bodyBytes != null) {
          _imageBase64 = response.bodyBytes;
          print('imagebase2: $_imageBase64');

          picture = Student(
              id: i, imageData: _imageBase64, pic: pic, isolate: isolate);
          print('picture2: $picture');
          print('start of database for 2');
          // await Databasehelper.instance.initDB();
          //DBHelper.instance.initDatabase();
          //   await DBHelper.instance.add(stu);
          // await DBHelper.add(Student(null, stu));
          pic++;
          sendPort.send(picture);
        }
      }

      print('$pic images for Isolate2 Completed');
      //sendPort.send(json.decode(response.body));
      print('Isolate2 Completed');
    } catch (e) {
      print('error is :${e.toString()}');
    }
  }

  refreshImages() {
    DBHelper.instance.getPictures().then((imgs) {
      setState(() {
        images.addAll(imgs);
      });
    });
  }

  /* static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
    setState(() {
      notification = data;
    });
  }
*/
/*
  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
        notification = '';
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }



  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: Student.imageData,
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Text(widget.title),

        /* FutureBuilder(
            //  future: dbHelper.getPictures(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
          if (snapshot.hasData) {
            ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {});
          }
        }),*/
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: callApi3,
        //tooltip: _running ? 'Timer stop' : 'Timer start',
        //child: gridView(),
        //_running ? new Icon(Icons.stop) : new Icon(Icons.play_arrow),
      ),
    );
  }
}
