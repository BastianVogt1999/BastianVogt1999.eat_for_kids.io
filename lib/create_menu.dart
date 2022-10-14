// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:eat_for_kids/values/child_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CreateMenu extends StatefulWidget {
  CreateMenu(this.currentUser, {Key? key}) : super(key: key);

  List<ChildValue> currentUser;
  @override
  State<CreateMenu> createState() => _CreateMenuState(currentUser);
}

class _CreateMenuState extends State<CreateMenu> {
  @override
  void initState() {
    firstStarted = true;
    fillUserSelected();
    super.initState();
  }

  _CreateMenuState(this.currentUser);
  List<bool> userSelected = [];
  List<ChildValue> currentUser;

  List<String> currentPreffered = [];
  List<String> currentHated = [];

  late bool firstStarted;

  fillUserSelected() {
    for (var i = 0; i < currentUser.length; i++) {
      userSelected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int countOfRows;
    double rowFontSize;

    if (MediaQuery.of(context).copyWith().size.width > 600) {
      countOfRows = 4;
      rowFontSize = 5.sp;
    } else {
      countOfRows = 2;

      rowFontSize = 20.sp;
    }

    refactorPreffered() {
      List<String> localList = [];

      //fill all preffered food
      for (var i = 0; i < currentUser.length; i++) {
        if (userSelected[i]) {
          for (var j = 0; j < currentUser[i].prefferdFood.length; j++) {
            localList.add(currentUser[i].prefferdFood[j]);
          }
        }
      }

      //remove duplicates
      localList = localList.toSet().toList();

//check if food is hated by someone -> hated food must be set before
      for (var i = 0; i < localList.length; i++) {
        if (currentHated.contains(localList[i])) {
          localList.removeAt(i);
        }
      }
      setState(() {
        currentPreffered = localList;
      });
    }

    refactorHated() {
      List<String> localList = [];
      for (var i = 0; i < currentUser.length; i++) {
        if (userSelected[i]) {
          for (var j = 0; j < currentUser[i].hateFood.length; j++) {
            localList.add(currentUser[i].hateFood[j]);
          }
        }
      }
      //remove duplicates
      localList = localList.toSet().toList();
      setState(() {
        currentHated = localList;
      });
    }

    Widget tableList(List<String> values, IconData icon) {
      return Column(
        children: [
          SizedBox(
            height: 5.h,
            child: Icon(
              icon,
              size: 40,
            ),
          ),
          Expanded(
              child: Center(
            child: CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: values.length,
                    (BuildContext context, int index) {
                  return Center(
                      child: Text(
                    values[index],
                    style: const TextStyle(fontSize: 20),
                  ));
                }),
              ),
            ]),
          )),
        ],
      );
    }

    Widget mainOutput() {
      return Row(
        children: [
          SizedBox(
              width: 49.w, child: tableList(currentPreffered, Icons.favorite)),
          Expanded(
              child: Container(
            color: Colors.blue.withOpacity(0.1),
          )),
          SizedBox(
              width: 49.w, child: tableList(currentHated, Icons.heart_broken)),
        ],
      );
    }

    Widget pickUser() {
      return SizedBox(
        height: 20.h,
        child: CustomScrollView(slivers: <Widget>[
          (SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      userSelected[index]
                          ? userSelected[index] = false
                          : userSelected[index] = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: userSelected[index]
                            ? Colors.orange[600]
                            : Colors.grey[200]),
                    height: 10.h,
                    alignment: Alignment.center,
                    child: Text(
                      currentUser[index].name,
                      style: TextStyle(fontSize: rowFontSize),
                    ),
                  ),
                );
              },
              childCount: currentUser.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: countOfRows,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 6.0,
            ),
          ))
        ]),
      );
    }

    return SizedBox(
      child: Column(
        children: [
          pickUser(),
          CupertinoButton.filled(
            onPressed: () {
              refactorHated();
              refactorPreffered();
            },
            child: const Text('Los'),
          ),
          Expanded(
            child: mainOutput(),
          )
        ],
      ),
    );
  }
}
