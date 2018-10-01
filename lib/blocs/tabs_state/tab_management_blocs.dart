
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:tab_maker/blocs/tabs_state/tab_management_model.dart';

class TabManagementBloc{
  //input
  Sink<TabManagementData> get setData => _dataController.sink;
  final _dataController = StreamController<TabManagementData>();

  //output
  Stream<TabManagementData> get data => _dataSubject;
  final _dataSubject = BehaviorSubject<TabManagementData>();
  BehaviorSubject<TabManagementData> get tabData => _dataSubject;

  TabManagementBloc(){
    _dataController.stream.listen( (flushbar) => _dataSubject.add(flushbar) );
  }

  void dispose(){
    _dataController.close();
  }
}