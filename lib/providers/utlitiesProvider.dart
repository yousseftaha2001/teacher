import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilitesPro extends ChangeNotifier{
  double _monthlyExam = 0;
  double _tasks = 0;
  double _assignments = 0;

  int _createdTasks = 0;
  int _finishedTasks = 0;
  int _students = 0;
  DateTime now=DateTime.now();
  TimeOfDay timeOfDay=TimeOfDay.now();
  String _assignmentType="";
 DateTime dateTimeOne;
 
 
 getOne(){
   dateTimeOne=DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute);
   return dateTimeOne;
 }


  getDate(){
    return now;
  }
  changeDate(DateTime date){
    now=date;
    notifyListeners();
  }

  String getTime(BuildContext context){
   return  timeOfDay.format(context);
  }
  changeTime(TimeOfDay time){
    timeOfDay=time;
    notifyListeners();
  }

  changeTYpe(String type){
    _assignmentType=type;
    notifyListeners();
  }

  String get assignmentType => _assignmentType;

  setcreatedTasks(int value) {
    _createdTasks = value;
  }

  setfinishedTasks(int value) {
    _finishedTasks = value;
    notifyListeners();
  }

  setstudents(int value) {
    _students = value;
    notifyListeners();
  }
  int get createdTasks => _createdTasks;

  int get finishedTasks => _finishedTasks;

  int get students => _students;
  setExams(double val){
    _monthlyExam=val;
    notifyListeners();
  }
   setTask( double val) {
     _tasks=val;
     notifyListeners();
  }
  setAssignments(double val){
    _assignments=val;
    notifyListeners();
  }
  double get getExams =>_monthlyExam;
  double get getTasks =>_tasks;
  double get getAssignments =>_assignments;


}