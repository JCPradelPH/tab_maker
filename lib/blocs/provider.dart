



import 'package:flutter/material.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_blocs.dart';
import 'package:tab_maker/blocs/tabs_state/tab_management_blocs.dart';

class StreamProvider extends InheritedWidget{

  final SelectableItemBloc selectableItemBloc;
  final TabManagementBloc tabManagementBloc;

  StreamProvider({
    Key key, 
    Widget child,
    SelectableItemBloc selectableItemBloc, 
    TabManagementBloc tabManagementBloc, 
  })
    : this.selectableItemBloc = selectableItemBloc ?? SelectableItemBloc(),
      this.tabManagementBloc = tabManagementBloc ?? TabManagementBloc(), 
      super(child: child, key: key);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SelectableItemBloc selectableItemBlocInstance(BuildContext context) => 
    (context.inheritFromWidgetOfExactType(StreamProvider) as StreamProvider)
      .selectableItemBloc;

  static TabManagementBloc tabManagementBlocInstance(BuildContext context) => 
    (context.inheritFromWidgetOfExactType(StreamProvider) as StreamProvider)
      .tabManagementBloc; 

}