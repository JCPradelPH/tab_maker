import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_blocs.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';

Widget menuCreatorStream(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData, dynamic content) {
    final TabManagementBloc tabManagementBloc = StreamProvider.tabManagementBlocInstance(context);
    
    return StreamBuilder<TabManagementData>(
      stream: tabManagementBloc.data,
      initialData: TabManagementData(
        currentWorkingTabId: tabs.length > 0 ? tabs[0].data["id"] : "",
        currentWorkingTabName: tabs.length > 0 ? tabs[0].data["name"] : "",
        currentWorkingTabIndex: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot<TabManagementData> snapshot){
        return content(context,tabs,selectableItemData,snapshot.data);
      },
    );
  }

  Widget menuCreatorStreamItem(BuildContext context, List<DocumentSnapshot> tabs, DocumentSnapshot tab, SelectableItemData selectableItemData, dynamic content) {
    final TabManagementBloc tabManagementBloc = StreamProvider.tabManagementBlocInstance(context);
    return StreamBuilder<TabManagementData>(
      stream: tabManagementBloc.data,
      initialData: TabManagementData(
        currentWorkingTabId: tabs[0].data["id"],
        currentWorkingTabName: tabs[0].data["name"],
        currentWorkingTabIndex: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot<TabManagementData> snapshot){
        return content(context,tab,selectableItemData,snapshot.data);
      },
    );
  }

  