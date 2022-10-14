import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_for_kids/values/child_value.dart';

class SelectStatements {
  Future<List<ChildValue>> selectAllUserOfCompany() async {
    List<ChildValue> userList = [];

    await FirebaseFirestore.instance
        .collection('/AllKids/')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        ChildValue value = ChildValue.empty();
        value.name = doc["child_name"];
        value.favoriteFood = doc["favorite_food"];

        //Add Prefferd Food to Array
        await FirebaseFirestore.instance
            .collection('/AllKids/${value.name}/prefferedFood')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            value.prefferdFood.add(doc["name"]);
          }
        });
        //Add Hate Food to Array
        await FirebaseFirestore.instance
            .collection('/AllKids/${value.name}/hateFood')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            value.hateFood.add(doc["name"]);
          }
        });
        userList.add(value);
      }
    });

    return userList;
  }
}
