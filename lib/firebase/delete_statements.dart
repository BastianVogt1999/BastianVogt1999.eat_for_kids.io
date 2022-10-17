// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_for_kids/values/child_value.dart';

class DeleteStatements {
  deleteUser(ChildValue child) {
    //delete Collection hateFood inside Kid
    FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/hateFood')
        .snapshots()
        .forEach((querySnapshot) {
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        docSnapshot.reference.delete();
      }
    });

    FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/prefferedFood')
        .snapshots()
        .forEach((querySnapshot) {
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        docSnapshot.reference.delete();
      }
    });

    //delete Kid
    var database = FirebaseFirestore.instance.collection('/AllKids/');
    database
        .doc(child.name)
        .delete()
        .catchError((error) => print("Failed to delete food: $error"));
  }

  deletePrefferedFood(ChildValue child, String foodName) {
    var database = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/preferredFood');
    database
        .doc(foodName)
        .delete()
        .catchError((error) => print("Failed to delete food: $error"));
  }

  deleteHatedFood(ChildValue child, String foodName) {
    var database = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/hateFood');
    database
        .doc(foodName)
        .delete()
        .catchError((error) => print("Failed to delete food: $error"));
  }
}
