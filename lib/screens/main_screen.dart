
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:tab_maker/blocs/selectable_item_state/components.dart';
import 'package:tab_maker/blocs/selectable_item_state/fn_streams.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/blocs/tabs_state/fn_streams.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_blocs.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';
import 'package:tab_maker/screens/components/put_modal.dart';
import 'package:tab_maker/screens/components/shared_components.dart';
import 'package:tab_maker/screens/components/tab_management_section.dart';
import 'package:tab_maker/screens/utils/fn.dart';
import 'package:tab_maker/screens/utils/list_actions.dart';

class MainScreen extends StatefulWidget{
  
  final String deviceId;

  MainScreen({@required this.deviceId}) : assert(deviceId != null && deviceId != "");

  @override
  _State createState() => _State();

}

class _State extends State<MainScreen> with TickerProviderStateMixin{

  ListActions _listActions;
  CollectionReference _menuTabsReference;

  SelectableItemBloc _selectableItemBloc;

  @override
  void initState() {
    super.initState();
    _listActions = ListActions( isMenuSelectionMode: false, );
    _menuTabsReference = Firestore.instance.collection("tab_maker/${widget.deviceId}/tabs");
  }

  @override
  Widget build(BuildContext context) {
    return _tabStream();
  }

  Widget _tabStream() {
    _selectableItemBloc = StreamProvider.selectableItemBlocInstance(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _menuTabsReference.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) return genericLoader();

        if(snapshot.hasData){
          List<DocumentSnapshot> tabs = snapshot.data.documents;
          TabController tabController = TabController(initialIndex: 0,length: tabs.length+1,vsync: this);
          final TabManagementBloc tabManagementBloc = StreamProvider.tabManagementBlocInstance(context);
          TabManagementData tabData = TabManagementData(
            currentWorkingTabId: "",
            currentWorkingTabIndex: 0,
            currentWorkingTabName: ""
          );
          tabController.addListener((){ 
            setTabData(
              tabData: tabData, 
              tabController: tabController, 
              tabs: tabs, 
              tabManagementBloc: tabManagementBloc
            ); 
          });
          if(tabs.length> 0){
            if(tabManagementBloc.tabData.value != null){
              tabController.index = isValidIndex(tabController.index, tabs) ? tabManagementBloc.tabData.value.getCurrentWorkingTabIndex : 
                tabManagementBloc.tabData.value.getCurrentWorkingTabIndex - 1;
            }
            setTabData(
              tabData: tabData, 
              tabController: tabController, 
              tabs: tabs, 
              tabManagementBloc: tabManagementBloc
            ); 
          }
          return tabbedFolderSetupStream(tabController, tabs, _selectableItemBloc, tabData, _mainScaffold);
        }

        return genericLoader();
      },
    );
  }

  Widget _mainScaffold(TabController tabController, List<DocumentSnapshot> tabs, 
    SelectableItemData selectableItemData, TabManagementData tabData) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
        actions: selectableItemData.isSelectedMode ? _selectStateButtons(selectableItemData, tabs) : _normalStateTabButtons(selectableItemData, tabData),
        title: Text(
          selectableItemData.isSelectedMode ? "${selectableItemData.getSelectableItemAdapter.length} item(s) selected" : "Tab Maker Demo",
          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor)
        ),
      ),
      body: WillPopScope(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _formScaffold(tabController, tabs, selectableItemData),
            ],
          ),
        onWillPop: (){ return _backEvent(selectableItemData); },
      ),
      floatingActionButton: tabs.length > 0 ? 
        menuCreatorStream(context, tabs, selectableItemData, _addItemToTabButton) : null,
      resizeToAvoidBottomPadding: false,
    );

  List<Widget> _selectStateButtons(SelectableItemData selectableItemData, List<DocumentSnapshot> tabs) => [
    menuCreatorStream(context, tabs, selectableItemData, _detachButton),
    IconButton(
      onPressed: (){
        _listActions.setActionState(
          context: context, 
          snapshot: selectableItemData,
          copyMode: false,
          moveMode: false,
          selectedMode: false
        );
      },
      icon: Icon(Icons.cancel, color: Theme.of(context).primaryColor),
    ),
  ];

  List<Widget> _normalStateTabButtons(SelectableItemData selectableItemData, TabManagementData tabData) => [
    streamedSelectModeButton(
      _menuTabsReference
        .document(tabData.getCurrentWorkingTabId==""?"0":tabData.getCurrentWorkingTabId)
        .collection("items")
        .snapshots(),
      StreamProvider.selectableItemBlocInstance(context),
      selectableItemData
    ),
  ];

  Widget _detachButton(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData, 
    TabManagementData tabData) => IconButton(
    onPressed: (){
      if(selectableItemData.getSelectableItemAdapter.length == 0) {
        showToast(message: "Nothing selected");
        return;
      }
      // TODO: Delete attached tabs here
      _listActions.groupDeleteConfirmation(context, selectableItemData);
    },
    icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
  );

  Widget _addItemToTabButton(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData, TabManagementData tabData) => 
  selectableItemData.isSelectedMode ? Container() : FloatingActionButton(
    backgroundColor: Colors.red,
    child: Icon(Icons.playlist_add, color: Colors.white),
    onPressed: (){
      putRecordModal(
        context, 
        _menuTabsReference
          .document(tabData.getCurrentWorkingTabId==""?"0":tabData.getCurrentWorkingTabId)
          .collection("items"), 
          "Item"
        );
    },
  );

  Widget _formScaffold(TabController tabController, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => TabManagementSection(
    tabController: tabController, 
    tabs: tabs, 
    selectableItemData: selectableItemData,
    userId: widget.deviceId,
    menuTabsReference: _menuTabsReference,
    listActions: _listActions,
  );

  Future<bool> _backEvent(SelectableItemData selectableItemData){
    if(selectableItemData.isSelectedMode){
      _listActions.setActionState(
        context: context, 
        snapshot: selectableItemData,
        copyMode: false,
        moveMode: false,
        selectedMode: false
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

}