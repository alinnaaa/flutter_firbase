import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final controllerName = TextEditingController();
  final controllerMessage = TextEditingController();
  List<String> docIds = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: 500,
      ),
      backgroundColor: Colors.blue,
    );
  }

  Widget buildUser(User user) => ListTile(
        title: Text(user.name),
        subtitle: Text(user.message),
      );

//read
  Stream<List<User>> readUser() => FirebaseFirestore.instance
      .collection('names')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

// add data to firebase
  Future creatUser(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docUser = firestore.collection('names').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  //read data
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('names')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIds.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }
}

class User {
  String id;
  final String name;
  final String message;

  User({this.id = '', required this.name, required this.message});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'message': message};

  static User fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], message: json['message']);
}
