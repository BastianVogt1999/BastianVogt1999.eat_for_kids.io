// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_for_kids/values/child_value.dart';

class UpdateStatements {
  updateFavFood(ChildValue child, String newText) {
    var database = FirebaseFirestore.instance.collection('/AllKids/');

    database.doc(child.name).update(
      {
        "favorite_food": newText,
      },
    ).catchError((error) {
      print("Failed to update FavFood: $error");
    });
  }
}
