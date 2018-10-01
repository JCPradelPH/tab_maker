import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:tab_maker/blocs/selectable_item_state/fn_streams.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/screens/components/put_modal.dart';
import 'package:tab_maker/screens/components/streamed_actionable_list.dart';
import 'package:tab_maker/screens/utils/menu_adapter.dart';

class TabContent extends StatelessWidget{

  final String _tabId;
  CollectionReference _menuCreatorReference, _itemSubColRef;
  final menuList = <MenuAdapter>[
    MenuAdapter(
      title: 'Edit Dish', 
      actionId: 0,
    ),
    MenuAdapter(
      title: 'Remove from Menu', 
      actionId: 1,
    ),
  ];

  TabContent(this._tabId, this._menuCreatorReference){
    _itemSubColRef = _menuCreatorReference.document(_tabId==""?"0":_tabId).collection("items");
  }

  @override
  Widget build(BuildContext context) {
    return _mainContent(context);
  }

  Widget _mainContent(BuildContext context) => Container(
    child: Container(
      margin: new EdgeInsets.only(top: 10.0),
      child: folderSetupStream(StreamProvider.selectableItemBlocInstance(context), _itemListSection),
    ),
  );

  Widget _itemListSection(BuildContext context, AsyncSnapshot<SelectableItemData> snapshot) => StreamedActionableList(
    recordType: RecordType.ITEM,
    selectableItemData: snapshot.data,
    mainIcon: Icons.fastfood,
    idFieldName: "id",
    nameFieldName: "name",
    collectionName: "items",
    mainColRef: _itemSubColRef,
    listItemCallback: (BuildContext context, DocumentSnapshot doc, SelectableItemBloc folderSetupBloc){

    },
    renameFolderEvent: (BuildContext context, dynamic doc){
      putRecordModal(context, _itemSubColRef, "Item", recId: doc["id"], recName: doc["name"]);
    },
    isGridMode: true,
    isMenuSelectionMode: false,
    emptyPlaceholder: (BuildContext context, List<DocumentSnapshot> doc) => Container(),
    childAspectRatio: (MediaQuery.of(context).size.width / 100) - 0.5,
  );
}