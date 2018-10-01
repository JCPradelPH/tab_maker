
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectableItemData{
  List<PathWidgetAdapter> pathList;
  String currentFolderId, currentFolderName, sourceFolderId;
  bool selectedMode, moveMode, copyMode, menuSelectionMode;
  List<SelectableItemAdapter> selectableItemAdapter, cachedItemAdapter;
  int numProcessed;

  void setPathList(pathList) => this.pathList = pathList;
  void setNumProcessed(numProcessed) => this.numProcessed = numProcessed;
  void setCurrentFolderId(currentFolderId) => this.currentFolderId = currentFolderId;
  void setCurrentFolderName(currentFolderName) => this.currentFolderName = currentFolderName;
  void setSourceFolderId(sourceFolderId) => this.sourceFolderId = sourceFolderId;
  void setMenuSelectionMode(bool menuSelectionMode) => this.menuSelectionMode = menuSelectionMode;
  void setSelectedMode(bool selectedMode) => this.selectedMode = selectedMode;
  void setMoveMode(bool moveMode) => this.moveMode = moveMode;
  void setCopyMode(bool copyMode) => this.copyMode = copyMode;
  void setSelectableItemAdapter(List<SelectableItemAdapter> selectableItemAdapter) => this.selectableItemAdapter = selectableItemAdapter;
  void setCachedItemAdapter(List<SelectableItemAdapter> cachedItemAdapter) => this.cachedItemAdapter = cachedItemAdapter;

  bool get isSelectedMode => this.selectedMode;
  bool get isMenuSelectionMode => this.menuSelectionMode;
  int get getNumProcessed => this.numProcessed;
  bool get isMoveMode => this.moveMode;
  bool get isCopyMode => this.copyMode;
  String get getCurrentFolderId => this.currentFolderId;
  String get getSourceFolderId => this.sourceFolderId;
  List<SelectableItemAdapter> get getSelectableItemAdapter => this.selectableItemAdapter;
  List<SelectableItemAdapter> get getCachedItemAdapter => this.cachedItemAdapter;
  List<PathWidgetAdapter> get getPathList => this.pathList;
  String get getCurrentFolderName => this.currentFolderName;

  SelectableItemData({
    @required this.pathList,
    @required this.currentFolderId,
    @required this.currentFolderName,
    @required this.selectedMode,
    @required this.menuSelectionMode,
    @required this.selectableItemAdapter,
    @required this.moveMode,
    @required this.copyMode,
    @required this.cachedItemAdapter,
    @required this.numProcessed,
    @required this.sourceFolderId,
  });
}

class PathWidgetAdapter{
  Widget pathWidget;
  String folderId, folderName;

  void setPathWidget(pathWidget) => this.pathWidget = pathWidget;
  void setFolderId(folderId) => this.folderId = folderId;
  void setFolderName(folderName) => this.folderName = folderName;

  Widget get getPathWidget => this.pathWidget;
  String get getFolderId => this.folderId;
  String get getFolderName => this.folderName;

  PathWidgetAdapter(this.folderId,this.folderName,this.pathWidget);
}

class SelectableItemAdapter{
  String selectedId;
  DocumentReference selectedDocRef;
  CollectionReference selectedColRef;
  RecordType recordType;
  bool selected;

  void setSelectedDocRef(DocumentReference selectedDocRef) => this.selectedDocRef = selectedDocRef;
  void setSelectedColRef(CollectionReference selectedColRef) => this.selectedColRef = selectedColRef;
  void setSelected(bool selected) => this.selected = selected;
  void setSelectedId(String selectedId) => this.selectedId = selectedId;
  void setRecordType(RecordType recordType) => this.recordType = recordType;

  DocumentReference get getSelectedDocRef => this.selectedDocRef;
  CollectionReference get getSelectedColRef => this.selectedColRef;
  bool get isSelected => this.selected;
  String get getSelectedId => this.selectedId;
  RecordType get getRecordType => this.recordType;

  SelectableItemAdapter({
    this.selectedId,
    this.selectedDocRef,
    this.selected,
    this.selectedColRef,
    this.recordType,
  });
}

enum RecordType{
  FOLDER, ITEM, ADDON, EXCLUDABLE, TABITEM, MENU
}