import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_maker/screens/components/auto_validated_field.dart';
import 'package:tab_maker/screens/components/shared_components.dart';
import 'package:tab_maker/screens/utils/fn.dart';
import 'package:uuid/uuid.dart';

final uuid = new Uuid();
String recordName;
final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

void putRecordModal(BuildContext context, CollectionReference colRef, String recordType, 
  {String recId, String recName}) => showConfirmDialog(
  context, 
  _putTabForm(recName??"",recordType),
  recId==null?"New $recordType":"Rename $recordType",
  actions: [
    FlatButton(
      padding: new EdgeInsets.all(0.0),
      onPressed: (){ Navigator.pop(context,true); },
      child: Text("Cancel")
    ),
    FlatButton(
      padding: new EdgeInsets.all(0.0),
      onPressed: (){
        _saveTab(context,colRef,recId: recId);
      },
      child: Text(recId==null?"Create":"Rename")
    ),
  ]
);

Widget _putTabForm(String recName, String recordType) => Container(
  height: 90.0,
  child: Form(
    key: _formKey,
    autovalidate: true,
    child: _folderTabField(recName, recordType)
  ),
);

Widget _folderTabField(String recName, String recordType) => AutoValidatedField(
  (val) {

    if(val.isEmpty) return '$recordType name is required';
    
    return null;
  },
  onSave: (val) => recordName = val,
  keyboardType: TextInputType.text,
  hintText: "Enter $recordType name",
  initialValue: recName,
);

void _saveTab(BuildContext context, CollectionReference colRef, {String recId}) {
    final FormState form = _formKey.currentState;
    hideKeyboard();
    if(form.validate()){
      form.save();
      String tid = recId??uuid.v1();
      DateTime now = new DateTime.now();
      DocumentReference folderRef = colRef.document(tid);
      if(recId==null){
        folderRef.setData({
          'id':tid,
          'name':recordName,
          'createdAt': now.millisecondsSinceEpoch,
          'updatedAt': now.millisecondsSinceEpoch,
        },merge: true);
      }else{
        folderRef.setData({
          'name':recordName,
          'updatedAt': now.millisecondsSinceEpoch,
        },merge: true);
      }
      Navigator.pop(context);
    }
  }

void deleteTabConfirmation(BuildContext context, DocumentReference tabRef, String recName) => showConfirmDialog(
    context, 
    _confirmationMessage("Are you sure you want to delete ${recName=="An item"?"this item":recName}?"),
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
          tabRef.delete();
          showToast(message: "$recName has been successfuly deleted");
        },
        child: Text("Delete")
      ),
    ]
  );

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