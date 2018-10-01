import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/blocs/tabs_state/fn_streams.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';
import 'package:tab_maker/screens/components/actionable_tab_item.dart';
import 'package:tab_maker/screens/components/put_modal.dart';
import 'package:tab_maker/screens/components/shared_components.dart';
import 'package:tab_maker/screens/components/tab_content.dart';
import 'package:tab_maker/screens/utils/list_actions.dart';

class TabManagementSection extends StatelessWidget{

  final TabController tabController;
  final List<DocumentSnapshot> tabs;
  final SelectableItemData selectableItemData;
  final String userId;
  final CollectionReference menuTabsReference;
  final ListActions listActions;

  TabManagementSection({
    @required this.tabController,
    @required this.tabs,
    @required this.selectableItemData,
    @required this.userId,
    @required this.menuTabsReference,
    @required this.listActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _menuBar(context, tabController, tabs, selectableItemData),
        _tabBarView(context, tabs, selectableItemData),
      ],
    );
  }

  Widget _menuBar(BuildContext context, TabController tabController, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => 
    AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 1.0,
      flexibleSpace: _tabBar(context, tabController, tabs, selectableItemData),
    );

  Widget _tabBar(BuildContext context, TabController tabController, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => TabBar(
    controller: tabController,
    labelColor: Theme.of(context).primaryColor,
    isScrollable: true,
    tabs: selectableItemData.isSelectedMode ? _selectModeMenuTabs(context, tabs,selectableItemData) : 
      _menuTabs(context, tabs,selectableItemData),
  );

  List<Widget> _menuTabs(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => tabs.map( (DocumentSnapshot tab) {
      print("REMAP");
      return menuCreatorStreamItem(context, tabs, tab, selectableItemData, _actionableTabItem);
    } )
    .toList()..add( Tab( child: _addTabButton(context) ) );

  List<Widget> _selectModeMenuTabs(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => tabs.map( (DocumentSnapshot tab) {
      print("REMAP");
      return menuCreatorStreamItem(context, tabs, tab, selectableItemData, _actionableTabItem);
    } )
    .toList();
  
  Widget _actionableTabItem(BuildContext context, DocumentSnapshot tab, SelectableItemData selectableItemData, TabManagementData tabData) => Tab(
    child: ActionableTabItem(
      tabId: tab.data["id"],
      tabName: tab.data["name"],
      tabItemRef: menuTabsReference,
      selectableItemData: selectableItemData,
      tabData: tabData,
      renameTabEvent: (){
        putRecordModal(context, menuTabsReference, "Tab", recId: tab.data["id"], recName: tab.data["name"]);
      },
      addDishEvent: (BuildContext context, TabManagementData tabData){
        // TODO: show new item modal
        putRecordModal(context, menuTabsReference.document(tab.data["id"]??"0").collection("items"), "Item");
      }
    ),
  );

  Widget _addTabButton(BuildContext context, ) => IconButton(
    icon: Icon(Icons.add),
    onPressed: (){
      putRecordModal(context, menuTabsReference, "Tab");
    },
  );

  Widget _tabBarView(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData) => Container(
    child: menuCreatorStream(context,tabs,selectableItemData,_menuContent),
  );

  Widget _menuContent(BuildContext context, List<DocumentSnapshot> tabs, SelectableItemData selectableItemData, TabManagementData tabData) => tabs.length > 0 ? 
    TabContent(tabData.getCurrentWorkingTabId, menuTabsReference ) : noResultPlaceholderVec(
        // AssetImage("assets/images/menu-vector.png"), 
        "Click the add icon on the top left of your screen to add your first tab.",
        "You can create items per tabs you create."
      );

}