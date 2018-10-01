import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:tab_maker/blocs/selectable_item_state/fn_streams.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';
import 'package:tab_maker/screens/components/shared_components.dart';
import 'package:tab_maker/screens/utils/fn.dart';

class ListActions{

  final bool isMenuSelectionMode;

  ListActions({
    @required this.isMenuSelectionMode,
  });


  Widget _confirmationMessage(String message) => Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    child: leftAlignedSection([
      Flexible(
        child: Text(
          message,
          style: TextStyle(fontSize: 15.0)
        )
      ),
    ]),
  );

  Widget _streamedDialogMessage(BuildContext context, AsyncSnapshot<SelectableItemData> snapshot, String typeMsg) => Container(
    height: 75.0,
    child: Column(
      children: <Widget>[
        _confirmationMessage("${snapshot.data.getNumProcessed.toString()} of ${
          snapshot.data.getSelectableItemAdapter.length>0?
            snapshot.data.getSelectableItemAdapter.length.toString():
            snapshot.data.getCachedItemAdapter.length.toString()
          } items $typeMsg"),
        LinearProgressIndicator(
          value: double.parse(
            (
              snapshot.data.getNumProcessed / (snapshot.data.getSelectableItemAdapter.length > 0 ? 
                snapshot.data.getSelectableItemAdapter.length : snapshot.data.getCachedItemAdapter.length
            ) 
            ).toString()),
          )
      ],
    ),
  );

  void groupDeleteConfirmation(BuildContext context, SelectableItemData selectableItemData) => showConfirmDialog(
    context, 
    _confirmationMessage("Are you sure you want to delete all ${selectableItemData.getSelectableItemAdapter.length} item(s)."),
    "Delete Item",
    actions: [
      FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: (){ Navigator.pop(context,true); },
        child: Text("Cancel")
      ),
      FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: (){ 
          Navigator.pop(context,true);
          _deleteGroup(context, selectableItemData);
        },
        child: Text("Delete")
      ),
    ]
  );

  void _deleteGroup(BuildContext context, SelectableItemData selectableItemData) async {
    final selectableItemBloc = StreamProvider.selectableItemBlocInstance(context);
    showConfirmDialog(
      context,
      messagedFolderSetupStream(selectableItemBloc,_streamedDialogMessage,"Deleted"),
      "Delete Selected",
      barrierDismissible: false
    );
    int cachedItemCount = selectableItemData.getSelectableItemAdapter.length;
    for(var adapter in selectableItemData.getSelectableItemAdapter){
      await adapter.getSelectedDocRef.delete();
      selectableItemData.setNumProcessed(selectableItemData.getNumProcessed+1);
      selectableItemBloc.setData.add(selectableItemData);
    }
    
    Timer(Duration(seconds: 2),(){
      Navigator.pop(context);
      selectableItemData.setNumProcessed(0);
      selectableItemData.setSelectableItemAdapter(List<SelectableItemAdapter>());
      selectableItemData.setSelectedMode(false);
      selectableItemBloc.setData.add(selectableItemData);
    });
    showToast(message: "Successfuly deleted all ${cachedItemCount.toString()} items");
  }


  void setActionState({
    @required BuildContext context, 
    @required SelectableItemData snapshot, 
    @required bool copyMode, 
    @required bool moveMode, 
    @required bool selectedMode
  }) {
    assert(context != null);
    assert(snapshot != null);
    assert(copyMode != null);
    assert(moveMode != null);
    assert(selectedMode != null);
    SelectableItemData selectableItemData = snapshot;
    final selectableItemBloc = StreamProvider.selectableItemBlocInstance(context);
    selectableItemData.setCachedItemAdapter(
      copyMode||moveMode?
      selectableItemData.getSelectableItemAdapter:
      List<SelectableItemAdapter>()
    );
    selectableItemData.setNumProcessed(0);
    selectableItemData.setSelectableItemAdapter(List<SelectableItemAdapter>());
    selectableItemData.setSelectedMode(selectedMode);
    selectableItemData.setCopyMode(copyMode);
    selectableItemData.setMoveMode(moveMode);
    selectableItemData.setSourceFolderId(!copyMode&&!moveMode?"":selectableItemData.getCurrentFolderId);
    selectableItemBloc.setData.add(selectableItemData);
  }
}