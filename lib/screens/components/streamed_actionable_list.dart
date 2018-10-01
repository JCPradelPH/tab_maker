import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/screens/components/popup_menu.dart';
import 'package:tab_maker/screens/components/shared_components.dart';
import 'package:tab_maker/screens/utils/menu_adapter.dart';

class StreamedActionableList extends StatelessWidget{

  final dynamic listItemCallback, where, subtitle;
  final dynamic emptyPlaceholder, addWidget, renameFolderEvent, deleteFolderEvent;
  final String idFieldName, nameFieldName, collectionName;
  final IconData mainIcon;
  final SelectableItemData selectableItemData;
  final RecordType recordType;
  final bool isGridMode, isMenuSelectionMode;
  final int crossAxisCount;
  final double childAspectRatio, crossAxisSpacing, mainAxisSpacing;
  final CollectionReference mainColRef;
  final List<MenuAdapter> menuList = <MenuAdapter>[
    MenuAdapter(
      title: 'Rename', 
      actionId: 0,
    ),
    MenuAdapter(
      title: 'Delete', 
      actionId: 1,
    ),
    MenuAdapter(
      title: 'Select', 
      actionId: 2,
    ),
  ];

  StreamedActionableList(
    {
      @required this.recordType,
      @required this.selectableItemData,
      @required this.mainIcon,
      @required this.idFieldName,
      @required this.nameFieldName,
      @required this.collectionName,
      @required this.listItemCallback,
      @required this.isGridMode,
      @required this.isMenuSelectionMode,
      @required this.mainColRef,
      this.emptyPlaceholder,
      this.renameFolderEvent,
      this.deleteFolderEvent,
      this.addWidget,
      this.where,
      this.subtitle,
      this.crossAxisCount = 2,
      this.childAspectRatio = 2.85, 
      this.crossAxisSpacing = 5.0, 
      this.mainAxisSpacing = 5.0
    }
  );

  @override
  Widget build(BuildContext context) {
    if(isGridMode){
      return verticalGridStream(
        mainColRef.snapshots(),
        _listStateStream, 
        noResult: emptyPlaceholder??null,
        addWidget: addWidget??null,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      );
    }
    return verticalListStream(
      mainColRef.snapshots(),
      _listStateStream, 
      noResult: emptyPlaceholder??null,
      addWidget: addWidget??null,
    );
  }

  Widget _listStateStream(BuildContext context, dynamic doc, List<dynamic> siblingRecords) => _folderListItem(context, doc);

  Widget _folderListItem(BuildContext context, dynamic doc) {
    SelectableItemBloc selectableItemBloc = StreamProvider.selectableItemBlocInstance(context);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.7),
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(192, 192, 192, 0.5))
        )
      ),
      child: GestureDetector(
        onLongPress: (){ _onLongPressEvent(selectableItemBloc,doc); },
        child: Container(
          color: _isItemIncluded(doc[idFieldName],selectableItemData.getSelectableItemAdapter)?
            Color.fromRGBO(192, 192, 192, 1.0): Colors.white,
          child: _listTile(context,selectableItemBloc,doc),
        ),
      ),
    );
  }


  Widget _listTile(BuildContext context, SelectableItemBloc selectableItemBloc, dynamic doc) => ListTile(
    onTap: (){
      SelectableItemData selectableItemData = this.selectableItemData;
      if(recordType==RecordType.FOLDER && isMenuSelectionMode && selectableItemData.isSelectedMode){
        selectableItemData.setCachedItemAdapter(List<SelectableItemAdapter>());
        selectableItemData.setNumProcessed(0);
        selectableItemData.setSelectableItemAdapter(List<SelectableItemAdapter>());
        selectableItemData.setSelectedMode(false);
        selectableItemData.setCopyMode(false);
        selectableItemData.setMoveMode(false);
        selectableItemData.setSourceFolderId(selectableItemData.getCurrentFolderId);
        selectableItemBloc.setData.add(selectableItemData);
        return;
      }
      if(selectableItemData.isSelectedMode){
        List<SelectableItemAdapter> newAdapterList = selectableItemData.getSelectableItemAdapter;
        if(_isItemIncluded(doc[idFieldName],selectableItemData.getSelectableItemAdapter)){
          newAdapterList = selectableItemData.getSelectableItemAdapter
            .where( (SelectableItemAdapter adapter) {
              return adapter.getSelectedId != doc[idFieldName];
            } ).toList();
        }else{
          newAdapterList.add(
            SelectableItemAdapter(
              selectedId: doc[idFieldName],
              selectedDocRef: mainColRef.document(doc[idFieldName]),
              selected: true,
              selectedColRef: mainColRef,
              recordType: recordType
            )
          );
        }
        selectableItemData.setSelectableItemAdapter(newAdapterList);
        selectableItemBloc.setData.add(selectableItemData);
      }else{
        listItemCallback(context, doc, selectableItemData);
      }
    },
    contentPadding: new EdgeInsets.only(left:10.0,right:10.0),
    leading: subtitle!=null?_leading(doc):null,
    title: subtitle!=null?Text(doc[nameFieldName]??"No name provided",
        overflow: TextOverflow.ellipsis, 
        maxLines: 2,
        style: TextStyle( fontSize: 14.0 ),):
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: _leading(doc)
          ),
          Expanded(
            child: Text(doc[nameFieldName]??"No name provided",
              overflow: TextOverflow.ellipsis, 
              maxLines: 2,
              style: TextStyle( fontSize: 14.0 ),),
          )
        ],
      ),
    subtitle: subtitle!=null?subtitle(doc):null,
    trailing: recordType==RecordType.FOLDER && !isMenuSelectionMode ? 
      _trailing(context, selectableItemBloc, doc) : null,
  );

  Widget _leading(dynamic doc) {
    if(recordType==RecordType.FOLDER && isMenuSelectionMode){
      return Icon(mainIcon, size: 20.0);
    }
    if(_isItemIncluded(doc[idFieldName], selectableItemData.getSelectableItemAdapter)){
      return Icon(Icons.check, size: 20.0);
    }else{
      return selectableItemData.isSelectedMode ? Icon(Icons.check_box_outline_blank, size: 20.0) : 
        Icon(mainIcon, size: 20.0);
    }
      
  }

  Widget _trailing(BuildContext context, SelectableItemBloc selectableItemBloc, dynamic doc) => selectableItemData.isSelectedMode ? null : 
    PopUpMenu( 
      menuList,
      icon: Icon(Icons.more_vert, size: 15.0),
      onSelect: (MenuAdapter menu){
        switch(menu.actionId){
          case 0: // rename
            renameFolderEvent(context, doc);
          break;
          case 1: // delete
            deleteFolderEvent(context, doc);
          break;
          case 2: // select
            _onLongPressEvent(selectableItemBloc,doc);
          break;
        }
      },
    );

  bool _isItemIncluded(String folderId, List<SelectableItemAdapter> adapterList) {
    if(adapterList == null) return false;

    return adapterList
      .where( (SelectableItemAdapter adapter) => adapter.getSelectedId==folderId )
      .toList().length > 0;
  }
  
  void _onLongPressEvent(SelectableItemBloc folderSetupBloc, dynamic doc) {
    if(recordType==RecordType.FOLDER && isMenuSelectionMode) return null;

    SelectableItemData folderSetupData = this.selectableItemData;
    folderSetupData.setSelectedMode(true);
    List<SelectableItemAdapter> newAdapterList = folderSetupData.getSelectableItemAdapter??List<SelectableItemAdapter>();
    newAdapterList.add(
      SelectableItemAdapter(
        selectedId: doc[idFieldName],
        selectedDocRef: mainColRef.document(doc[idFieldName]),
        selected: true,
        selectedColRef: mainColRef,
        recordType: recordType
      )
    );
    folderSetupData.setSelectableItemAdapter(newAdapterList);
    folderSetupBloc.setData.add(folderSetupData);
  }

}