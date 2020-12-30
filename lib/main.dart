import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/providers/utlitiesProvider.dart';
import 'package:chatapp/screens/loginscreen.dart';
import 'package:chatapp/screens/signup.dart';
import 'package:chatapp/screens/teacher/addassignment.dart';
import 'package:chatapp/screens/teacher/addlessons.dart';
import 'package:chatapp/screens/teacher/addtask.dart';
import 'package:chatapp/screens/teacher/assignemtsph.dart';
import 'package:chatapp/screens/teacher/assignmentpdf.dart';
import 'package:chatapp/screens/teacher/chatroom.dart';
import 'package:chatapp/screens/teacher/lessons.dart';
import 'package:chatapp/screens/teacher/lessonsView.dart';
import 'package:chatapp/screens/teacher/studentlist.dart';
import 'package:chatapp/screens/teacher/t.assignments.dart';
import 'package:chatapp/screens/teacher/t.home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                create: (_) => AuthProvider(),
              ),
              ChangeNotifierProvider<CloudStorageProvider>(
                create: (_) => CloudStorageProvider(),
              ),
              ChangeNotifierProvider<FireStoreProvider>(
                create: (_) => FireStoreProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UtilitesPro(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: LogInScreen(),
              routes: {
                SignUp.routeName: (context) => SignUp(),
                LogInScreen.routeName: (context) => LogInScreen(),
                TeacherHome.routeName: (context) => TeacherHome(),
                TChatRoom.routeName: (context) => TChatRoom(),
                StudentsList.routeName: (context) => StudentsList(),
                TAssignments.routeName: (context) => TAssignments(),
                AddAssignment.routeName: (context) => AddAssignment(),
                AssignemtPdf.routeName: (context) => AssignemtPdf(),
                AssignemtPhoto.routeName: (context) => AssignemtPhoto(),
                AddLessons.routeName: (context) => AddLessons(),
                Lessons.routeName: (context) => Lessons(),
                LessonView.routeName: (context) => LessonView(),
                AddTask.routeName: (context) => AddTask()
              },
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
