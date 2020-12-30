import 'package:chatapp/providers/authprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreProvider extends ChangeNotifier {
  FirebaseFirestore firestores = FirebaseFirestore.instance;

  addUser({String type, Map<String, dynamic> userdata, String uid}) async {
    try {
      await firestores.collection(type).doc(uid).set(userdata);
      print("user added done");
      return "done";
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  updateUser(String type, String uid, Map<String, dynamic> data) async {
    try {
      await firestores.collection(type).doc(uid).update(data);
      return "done";
    } catch (error) {
      print(error.toString());
      return "error";
    }
  }

  Future getUserType({String id, bool room}) async {
    DocumentSnapshot user;
    user = await firestores.collection("Teacher").doc(id).get();
    if (user.exists) {
      print(" ${user.data()["userType"]} from provider");
      if (room == true) {
        return user.data()["roomId"];
      }
      return user.data();
    } else {
      user = await firestores.collection("Student").doc(id).get();
      if (user.exists) {
        print(" ${user.data()["userType"]} from provider");
        return user.data();
      } else {
        user = await firestores.collection("Other").doc(id).get();
        if (user.exists) {
          print(" ${user.data()["userType"]} from provider");
          return user.data();
        } else {
          return "not";
        }
      }
    }
  }

  Future getNumber(String uid, String collTarget) async {
    print("im here");
    try {
      var docs = await firestores
          .collection("Teacher")
          .doc(uid)
          .collection(collTarget)
          .get();
      int lent = docs.docs.length;
      return lent;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> makeNewRoom({String uid, Map<String, dynamic> data}) async {
    String roomUid;
    await firestores
        .collection("Rooms")
        .add(data)
        .then((value) => roomUid = value.id);
    return roomUid;
  }

  Future<DocumentSnapshot> getRoom({String rid}) async {
    return await firestores.collection("Rooms").doc(rid).get();
  }

  deleteRoom({String rid, String uid, String type}) async {
    await firestores.collection("Rooms").doc(rid).delete();
    await updateUser(type, uid, {"roomId": null});
  }

  addMessage({String rid, Map<String, dynamic> message}) async {
    await firestores
        .collection("Rooms")
        .doc(rid)
        .collection("Chats")
        .add(message);
  }

  uploadtask({String rid, Map<String, dynamic> assignment, String type}) async {
    try {
      await firestores
          .collection("Rooms")
          .doc(rid)
          .collection(type)
          .add(assignment);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  deleteTask({String rid, String type, String docId}) async {
    try {
      await firestores
          .collection("Rooms")
          .doc(rid)
          .collection(type)
          .doc(docId)
          .delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Stream chats({String rid}) {
    return firestores
        .collection("Rooms")
        .doc(rid)
        .collection("Chats")
        .orderBy("created")
        .snapshots();
  }

  Stream studentsList({String rid}) {
    return firestores
        .collection("Rooms")
        .doc(rid)
        .collection("studentslist")
        .snapshots();
  }

  Stream assignmentsT({String rid, String way}) {
    return firestores.collection("Rooms").doc(rid).collection(way).snapshots();
  }

  Stream assignmentsDoneby({String rid, String aid}) {
    return firestores
        .collection("Rooms")
        .doc(rid)
        .collection("assignments")
        .doc(aid)
        .collection("doneBy")
        .snapshots();
  }

  addTask({String rid, Map<String, dynamic> data, String type}) async {
    try {
      await firestores.collection("Rooms").doc(rid).collection(type).add(data);
      return "done";
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<bool> createTask({String userId, Map<String, dynamic> task}) async {
    bool done = false;
    try {
      await firestores
          .collection("Teacher")
          .doc(userId)
          .collection("createdtasks")
          .add(task)
          .whenComplete(() => done = true);
      return done;
    } catch (erorr) {
      print(erorr.toString());
      return done;
    }
  }

   deleteMytask({String userId, String docId}) async {

    try {
      await firestores
          .collection("Teacher")
          .doc(userId)
          .collection("createdtasks")
          .doc(docId)
          .delete();
      return true;
    } catch (eror) {
      print(eror.toString());
      return false;
    }
  }

   update_my_task(
      {String userId, String docId, Map<String, dynamic> up}) async {
    try {
      await firestores
          .collection("Teacher")
          .doc(userId)
          .collection("createdtasks")
          .doc(docId)
          .update(up);
      return true;
    } catch (eror) {
      print(eror.toString());
      return false;
    }
  }



   getTasks( {String id})  {

    return firestores
        .collection("Teacher")
        .doc(id)
        .collection("createdtasks")
        .snapshots();
  }
}
