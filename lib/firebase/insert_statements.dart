// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_for_kids/values/child_value.dart';

class InsertStatements {
  bool correct = false;
  insertNewUser(ChildValue child) {
    var databaseUser = FirebaseFirestore.instance.collection('/AllKids/');

    databaseUser.doc(child.name).set(
      {
        'child_name': child.name,
        'favorite_food': child.favoriteFood,
      },
    ).then((value) {
      print("User Added");
      correct = true;
    }).catchError((error) {
      print("Failed to add user: $error");
    });

    databaseUser = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/prefferedFood');

    databaseUser.doc("Pizza").set(
      {
        'name': "Pizza",
      },
    ).then((value) {
      print("Food Added");
      correct = true;
    }).catchError((error) {
      correct = false;
      print("Failed to add food: $error");
    });

    databaseUser = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/hateFood');

    databaseUser.doc("Salat").set(
      {
        'name': "Salat",
      },
    ).then((value) {
      print("Food Added");
      correct = true;
    }).catchError((error) {
      correct = false;
      print("Failed to add food: $error");
    });

    return correct;
  }

  insertNewPreferredFood(ChildValue child, String newName) {
    var databaseUser = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/prefferedFood');

    databaseUser.doc(newName).set(
      {
        'name': newName,
      },
    ).then((value) {
      print("Food Added");
      correct = true;
    }).catchError((error) {
      correct = false;
      print("Failed to add food: $error");
    });
  }

  insertNewHateFood(ChildValue child, String newName) {
    var databaseUser = FirebaseFirestore.instance
        .collection('/AllKids/${child.name}/hateFood');

    databaseUser.doc(newName).set(
      {
        'name': newName,
      },
    ).then((value) {
      print("Food Added");
      correct = true;
    }).catchError((error) {
      correct = false;
      print("Failed to add food: $error");
    });
  }
}
