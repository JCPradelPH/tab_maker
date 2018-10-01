import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_blocs.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';

void setTabData({
  @required TabManagementData tabData, 
  @required TabController tabController, 
  @required List<DocumentSnapshot> tabs, 
  @required TabManagementBloc tabManagementBloc
}) {

  assert(tabData != null);
  assert(tabController != null);
  assert(tabs != null);
  assert(tabManagementBloc != null);

  DocumentSnapshot tabSnap = isValidIndex(tabController.index, tabs) ? 
    tabs[tabController.index]:tabs[tabController.index-1];
  tabData.setCurrentWorkingTabId(tabSnap.data["id"]);
  tabData.setCurrentWorkingTabName(tabSnap.data["name"]);
  tabData.setCurrentWorkingTabIndex(isValidIndex(tabController.index, tabs) ? 
    tabController.index : tabController.index-1);
  tabManagementBloc.setData.add(tabData);
}

bool isValidIndex( index, indexable) {
  int length = indexable.length;
  if (0 > index || index >= length) {
    return false;
  }
  return true;
}

void showToast({@required String message}){
  assert(message != null && message != "");
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
  );
}

void hideKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');