
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:tab_maker/blocs/selectable_item_state/selectable_item_model.dart';


class SelectableItemBloc{
  //input
  Sink<SelectableItemData> get setData => _dataController.sink;
  final _dataController = BehaviorSubject<SelectableItemData>();

  //output
  Stream<SelectableItemData> get data => _dataSubject;
  final _dataSubject = BehaviorSubject<SelectableItemData>();
  BehaviorSubject<SelectableItemData> get getData => _dataSubject;

  SelectableItemBloc(){
    _dataController.stream.listen( (data) => _dataSubject.add(data) );
  }

  void dispose(){
    _dataController.close();
  }
}