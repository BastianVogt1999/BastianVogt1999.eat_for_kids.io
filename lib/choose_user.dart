// ignore_for_file: must_be_immutable, no_logic_in_create_state, list_remove_unrelated_type

import 'dart:math';

import 'package:eat_for_kids/firebase/delete_statements.dart';
import 'package:eat_for_kids/firebase/insert_statements.dart';
import 'package:eat_for_kids/firebase/update_statements.dart';
import 'package:eat_for_kids/values/child_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:sizer/sizer.dart';

class ChooseUser extends StatefulWidget {
  ChooseUser(this.currentUser, {Key? key}) : super(key: key);
  List<ChildValue> currentUser;

  @override
  State<ChooseUser> createState() => _ChooseUserState(currentUser);
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  void initState() {
    firstStarted = true;
    coloredFirst = true;
    super.initState();
  }

  _ChooseUserState(this.currentUser);

  int _selectedValue = 0;
  List<ChildValue> currentUser;

  late bool firstStarted;
  int widgetHeight = 15;
  late bool coloredFirst;
  bool hoverFavorite = false;
  bool hoverPreferred = false;
  bool hoverHated = false;

  TextEditingController textController = TextEditingController();
  TextEditingController controller = TextEditingController();

  bool showAddFavorites = false;
  bool showAddHatings = false;
  bool showEditFav = false;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    List<ChildValue> showedUser = currentUser;
    var sizeOfPopup = MediaQuery.of(context).copyWith().size.height * 0.40;
    var dividerHeight = 0.1.h;

    void _showAlertDialog(String addName, int index) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(
            'Warnung',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('Element wirklich löschen?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              /// This parameter indicates this action is the default,
              /// and turns the action's text to bold text.
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Nein'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                if (addName == "Neues bevorzugtes Essen") {
                  DeleteStatements().deletePrefferedFood(
                      currentUser[_selectedValue],
                      currentUser[_selectedValue].prefferdFood[index]);
                  currentUser[_selectedValue].prefferdFood.remove(index);
                } else {
                  DeleteStatements().deleteHatedFood(
                      currentUser[_selectedValue],
                      currentUser[_selectedValue].hateFood[index]);
                  currentUser[_selectedValue].hateFood.remove(index);
                }

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Ja'),
            ),
          ],
        ),
      );
    }

    void showPopup(String text, int isfavorite, String favortiteEat) {
      if (isfavorite == 0) {
        textController.text = favortiteEat;
      } else {
        textController.text = "";
      }

      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext builder) {
            return CupertinoPopupSurface(
              isSurfacePainted: true,
              child: Container(
                  padding: const EdgeInsetsDirectional.all(20),
                  color: CupertinoColors.white,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: sizeOfPopup,
                  child: Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                            child: Text(
                          text,
                          style: const TextStyle(
                            backgroundColor: CupertinoColors.white,
                            fontSize: 28,
                          ),
                        )),
                        SizedBox(
                            height: 5.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CupertinoSearchTextField(
                                    controller: textController,
                                    onChanged: (value) {
                                      setState(() {
                                        sizeOfPopup = MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.80;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        sizeOfPopup = MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.80;
                                      });
                                    },
                                    autocorrect: true,
                                  ),
                                ),
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              if (textController.text != "") {
                                if (isfavorite == 0) {
                                  currentUser[_selectedValue].favoriteFood =
                                      textController.text;

                                  UpdateStatements().updateFavFood(
                                      currentUser[_selectedValue],
                                      textController.text);
                                } else if (isfavorite == 1) {
                                  currentUser[_selectedValue]
                                      .prefferdFood
                                      .add(textController.text);

                                  InsertStatements().insertNewPreferredFood(
                                      currentUser[_selectedValue],
                                      textController.text);
                                } else {
                                  currentUser[_selectedValue]
                                      .hateFood
                                      .add(textController.text);

                                  InsertStatements().insertNewHateFood(
                                      currentUser[_selectedValue],
                                      textController.text);
                                }
                                setState(() {});
                                Navigator.of(context).pop();
                              } else {}
                            },
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                padding: const EdgeInsets.all(5),
                                height: 5.h,
                                child: const Text("Speichern",
                                    style: TextStyle(
                                        fontSize: 28, color: Colors.white)))),
                      ],
                    ),
                  )),
            );
          });
    }

    decoratedRowKidsPref(String text, IconData icon, MaterialColor color) {
      final item = text;
      return SizedBox(
          height: widgetHeight.h,
          child: Container(
            alignment: Alignment.centerRight,
            child: SwipeActionCell(
                key: Key(item),

                ///this key is necessary
                trailingActions: <SwipeAction>[
                  SwipeAction(
                      icon: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit_note,
                          color: Colors.lightGreen,
                          size: 40,
                        ),
                      ),
                      onTap: (CompletionHandler handler) {
                        showPopup("Favorit bearbeiten", 0,
                            currentUser[_selectedValue].favoriteFood);
                      },
                      color: Colors.green),
                ],
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[200],
                        radius: 30,
                        child: Icon(
                          icon,
                          color: color,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: widgetHeight.h,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                                  child: Center(child: Text(text)))),
                          SizedBox(
                            width: 5.w,
                            child: InkWell(
                              onHover: (value) {
                                setState(() {
                                  hoverFavorite = value;
                                });
                              },
                              onTap: (() {}),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_back,
                                      color: hoverFavorite
                                          ? Colors.black87
                                          : const Color.fromARGB(
                                              0, 255, 255, 255),
                                      size: 40)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ));
    }

    decoratedRowKidsElse(String addName, String zeroText, List<String> values,
        IconData icon, MaterialColor color, bool showAddField) {
      final item = zeroText;
      return Container(
          alignment: Alignment.topCenter,
          height: 20.h,
          child: SwipeActionCell(
              key: Key(item),

              ///this key is necessary
              trailingActions: <SwipeAction>[
                SwipeAction(
                    icon: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.post_add_rounded,
                          color: Colors.lightGreen, size: 40),
                    ),
                    onTap: (CompletionHandler handler) {
                      if (addName == "Neues bevorzugtes Essen") {
                        showPopup(addName, 1, "");
                      } else {
                        showPopup(addName, 2, "");
                      }
                    },
                    color: Colors.green),
              ],
              child: values.isNotEmpty
                  ? Stack(
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            height: 20.h,
                            child: CustomScrollView(slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    childCount: values.length,
                                    (BuildContext context, int index) {
                                  var itemR = Random().nextInt(1000).toString();
                                  coloredFirst
                                      ? coloredFirst = false
                                      : coloredFirst = true;
                                  return SwipeActionCell(
                                      key: Key(itemR),

                                      ///this key is necessary
                                      leadingActions: <SwipeAction>[
                                        SwipeAction(
                                            icon: const CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              child: Icon(Icons.delete_forever,
                                                  color: Colors.red, size: 20),
                                            ),
                                            onTap: (CompletionHandler handler) {
                                              _showAlertDialog(addName, index);
                                            },
                                            color: Colors.red),
                                      ],
                                      child: Container(
                                          color: coloredFirst
                                              ? Colors.grey[200]
                                              : Colors.grey[100],
                                          height: 8.h,
                                          alignment: Alignment.center,
                                          child: Text(values[index])));
                                }),
                              ),
                            ])),
                        Container(
                            height: widgetHeight.h,
                            padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                                backgroundColor: Colors.blue[200],
                                radius: 30,
                                child: Icon(icon, color: color, size: 40))),
                        SizedBox(
                          height: widgetHeight.h,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                width: 100.w,
                                child: InkWell(
                                  onHover: (value) {
                                    setState(() {
                                      hoverFavorite = value;
                                    });
                                  },
                                  onTap: (() {}),
                                  child: Container(
                                      width: 5.w,
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.arrow_back,
                                          color: hoverFavorite
                                              ? Colors.black87
                                              : const Color.fromARGB(
                                                  0, 255, 255, 255),
                                          size: 40)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: (() {
                        if (addName == "Neues bevorzugtes Essen") {
                          showPopup(addName, 1, "");
                        } else {
                          showPopup(addName, 2, "");
                        }
                      }),
                      child: Center(
                        child: Text(
                          "$zeroText: Hier hinzufügen",
                          style: const TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    )));
    }

    kidsPreferences() {
      return Center(
        child: Column(
          children: [
            decoratedRowKidsPref(currentUser[_selectedValue].favoriteFood,
                Icons.favorite, Colors.red),
            Divider(
              thickness: dividerHeight,
              color: Colors.blue[900],
            ),
            decoratedRowKidsElse(
                "Neues bevorzugtes Essen",
                "Bevorzugtes Essen",
                currentUser[_selectedValue].prefferdFood,
                Icons.favorite,
                Colors.lightGreen,
                showAddFavorites),
            Divider(
              thickness: dividerHeight,
              color: Colors.blue[900],
            ),
            decoratedRowKidsElse(
                "Neues unliebsames Essen",
                "Unliebsames Essen",
                currentUser[_selectedValue].hateFood,
                Icons.heart_broken,
                Colors.deepOrange,
                showAddHatings),
            Divider(
              thickness: dividerHeight,
              color: Colors.blue[900],
            ),
          ],
        ),
      );
    }

    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    // Display a CupertinoPicker with list of fruits.
                    onPressed: () => _showDialog(
                      Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: CupertinoSearchTextField(
                                controller: controller,
                                onChanged: (value) {
                                  List<ChildValue> localList = [];

                                  for (var i = 0; i < currentUser.length; i++) {
                                    if (currentUser[i].name.contains(value)) {
                                      localList.add(currentUser[i]);
                                    }
                                  }
                                  setState(() {
                                    showedUser = localList;
                                  });
                                },
                                onSubmitted: (value) {
                                  List<ChildValue> localList = [];

                                  for (var i = 0; i < currentUser.length; i++) {
                                    if (currentUser[i].name.contains(value)) {
                                      localList.add(currentUser[i]);
                                    }
                                  }
                                  setState(() {
                                    showedUser = localList;
                                  });
                                },
                                autocorrect: true,
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              magnification: 1.5,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: 8.h,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  _selectedValue = selectedItem;
                                });
                              },
                              children: List<Widget>.generate(showedUser.length,
                                  (int index) {
                                return Center(
                                  child: Text(
                                    showedUser[index].name,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // This displays the selected fruit name.
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        currentUser[_selectedValue].name,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: dividerHeight,
              color: Colors.blue[900],
              height: 2.h,
            ),
            Expanded(
                child: Container(
              child: kidsPreferences(),
            ))
          ],
        ),
      ),
    );
  }
}
