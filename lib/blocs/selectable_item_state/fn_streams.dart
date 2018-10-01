import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';

Widget tabbedFolderSetupStream(TabController tabController, List<DocumentSnapshot> tabs, SelectableItemBloc selectableItemBloc, 
  TabManagementData tabData, dynamic content) {
    return StreamBuilder<SelectableItemData>(
      stream: selectableItemBloc.data,
      initialData: SelectableItemData(
        selectedMode: false,
        moveMode: false,
        copyMode: false,
        menuSelectionMode: false,
        currentFolderId: "",
        currentFolderName: "",
        sourceFolderId: "",
        selectableItemAdapter: List<SelectableItemAdapter>(),
        cachedItemAdapter: List<SelectableItemAdapter>(),
        pathList: List<PathWidgetAdapter>(),
        numProcessed: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot<SelectableItemData> snapshot){
        return content(tabController, tabs, snapshot.data, tabData);
      },
    );
  }

  Widget folderSetupStream(SelectableItemBloc selectableItemBloc, dynamic content) {
    return StreamBuilder<SelectableItemData>(
      stream: selectableItemBloc.data,
      initialData: SelectableItemData(
        selectedMode: false,
        moveMode: false,
        copyMode: false,
        menuSelectionMode: false,
        currentFolderId: "",
        currentFolderName: "",
        sourceFolderId: "",
        selectableItemAdapter: List<SelectableItemAdapter>(),
        cachedItemAdapter: List<SelectableItemAdapter>(),
        pathList: List<PathWidgetAdapter>(),
        numProcessed: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot<SelectableItemData> snapshot){
        return content(context,snapshot);
      },
    );
  }

  Widget messagedFolderSetupStream(SelectableItemBloc selectableItemBloc, dynamic content, String typeMsg) {
    return StreamBuilder<SelectableItemData>(
      stream: selectableItemBloc.data,
      initialData: SelectableItemData(
        selectedMode: false,
        moveMode: false,
        copyMode: false,
        menuSelectionMode: false,
        currentFolderId: "",
        currentFolderName: "",
        sourceFolderId: "",
        selectableItemAdapter: List<SelectableItemAdapter>(),
        cachedItemAdapter: List<SelectableItemAdapter>(),
        pathList: List<PathWidgetAdapter>(),
        numProcessed: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot<SelectableItemData> snapshot){
        return content(context,snapshot,typeMsg);
      },
    );
  }