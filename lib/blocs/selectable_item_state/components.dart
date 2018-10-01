
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';

Widget streamedSelectModeButton(Stream<QuerySnapshot> collectionStream, 
  SelectableItemBloc selectableItemBloc, SelectableItemData selectableItemData) => StreamBuilder<QuerySnapshot>(
    stream: collectionStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError) return Container();
      if(!snapshot.hasData) return Container();

      if(snapshot.data.documents.length == 0) return Container();

      return IconButton(
        onPressed: (){
          SelectableItemData newSelectableItemData = selectableItemData;
          newSelectableItemData.setSelectedMode(true);
          selectableItemBloc.setData.add(newSelectableItemData);
        },
        icon: Icon(Icons.select_all),
      );
    }
  );