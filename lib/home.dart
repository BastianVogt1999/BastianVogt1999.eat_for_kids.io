// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:eat_for_kids/firebase/delete_statements.dart';
import 'package:eat_for_kids/firebase/insert_statements.dart';
import 'package:eat_for_kids/values/child_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'nav_bar.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget(this.currentUser, {Key? key}) : super(key: key);
  List<ChildValue> currentUser;

  @override
  State<HomeWidget> createState() => _HomeWidgetState(currentUser);
}

class _HomeWidgetState extends State<HomeWidget> {
  bool isHover = false;
  List<ChildValue> currentUser;
  TextEditingController textController = TextEditingController();

  _HomeWidgetState(this.currentUser);
  @override
  Widget build(BuildContext context) {
    void _showAlertDialog(ChildValue child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(
            'Warnung',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('Kind wirklich löschen?'),
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
                DeleteStatements().deleteUser(child);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NavBar()));
              },
              child: const Text('Ja'),
            ),
          ],
        ),
      );
    }

    // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
    // ignore: unused_element
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

    var sizeOfPopup = MediaQuery.of(context).copyWith().size.height * 0.40;
    void showPopupDelete() {
      List<CupertinoActionSheetAction> listSheets = [];

      for (var i = 0; i < currentUser.length; i++) {
        CupertinoActionSheetAction value = CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// defualt behavior, turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            _showAlertDialog(currentUser[i]);
          },
          child: Text(currentUser[i].name),
        );
        listSheets.add(value);
      }
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Kind löschen'),
          actions: listSheets,
        ),
      );
    }

    void showPopupInsert() {
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
                        const Material(
                            child: Text(
                          "Name eingeben",
                          style: TextStyle(
                            backgroundColor: CupertinoColors.white,
                            fontSize: 28,
                          ),
                        )),
                        SizedBox(
                            height: 5.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CupertinoTextField(
                                    controller: textController,
                                    onChanged: (value) {},
                                    onSubmitted: (value) {},
                                    autocorrect: true,
                                  ),
                                ),
                              ],
                            )),
                        CupertinoButton.filled(
                          onPressed: () {
                            ChildValue child = ChildValue.empty();
                            child.name = textController.text;
                            if (textController.text != "" &&
                                textController.text.length < 10) {
                              bool success =
                                  InsertStatements().insertNewUser(child);
                              if (success) {
                                textController.text = "";
                                Navigator.of(context).pop;
                              } else {
                                textController.text = "";
                                Navigator.of(context).pop;
                              }
                            } else if (textController.text.length >= 10) {
                              // ignore: avoid_print
                              print("zu groß");
                            }
                          },
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
                  )),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CupertinoButton.filled(
            minSize: 5.w,
            onPressed: () {
              showPopupInsert();
            },
            child: const Text('Neues Kind hinzufügen'),
          ),
          SizedBox(height: 1.h),
          CupertinoButton.filled(
            minSize: 5.w,
            onPressed: () {
              showPopupDelete();
            },
            child: const Text('Kind löschen'),
          ),
        ],
      ),
    );
  }
}
