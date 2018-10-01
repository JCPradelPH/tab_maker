import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';
import 'package:tab_maker/screens/components/popup_menu.dart';
import 'package:tab_maker/screens/components/put_modal.dart';
import 'package:tab_maker/screens/utils/menu_adapter.dart';

class ActionableTabItem extends StatelessWidget{

  final String tabId, tabName;
  final CollectionReference tabItemRef;
  final SelectableItemData selectableItemData;
  final VoidCallback renameTabEvent;
  final TabManagementData tabData;
  final dynamic addDishEvent;
  final menuList = <MenuAdapter>[
    MenuAdapter(
      title: 'Rename', 
      actionId: 0,
    ),
    MenuAdapter(
      title: 'Delete', 
      actionId: 1,
    ),
    MenuAdapter(
      title: 'Add Dishes', 
      actionId: 2,
    ),
  ];

  ActionableTabItem({
    this.tabId,
    this.tabName,
    this.tabItemRef,
    this.selectableItemData,
    this.renameTabEvent,
    this.tabData,
    this.addDishEvent,
  });

  @override
  Widget build(BuildContext context) {
    return selectableItemData.isSelectedMode && tabData.getCurrentWorkingTabId!=tabId ? Container() : Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(tabName),
        tabData.getCurrentWorkingTabId==tabId&&!selectableItemData.isSelectedMode?_trailing(context):Container()
      ],
    );
  }

  Widget _trailing(BuildContext context) => //folderSetupData.isSelectedMode ? Container() : 
    PopUpMenu( 
      menuList,
      icon: Icon(Icons.more_vert, size: 15.0),
      onSelect: (MenuAdapter menu){
        switch(menu.actionId){
          case 0: 
          renameTabEvent();
          break;
          case 1: 
          deleteTabConfirmation(context, tabItemRef.document(tabId), tabName);
          break;
          case 2: 
          addDishEvent(context, tabData);
          break;
        }
      },
    );

}