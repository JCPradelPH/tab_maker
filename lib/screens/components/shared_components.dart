
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> showConfirmDialog(BuildContext context, Widget content, String title, 
  {bool barrierDismissible,List<Widget> actions, EdgeInsets contentPadding}) {
  return showDialog(
    context: context,
    barrierDismissible:barrierDismissible??true,
    builder: (BuildContext context) => Container(
      child: AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
        contentPadding: contentPadding??EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
        content: content,
        actions: actions??List<Widget>(),
      ),
    ),
  ) ?? false;
}

Widget leftAlignedSection(List<Widget> children) => Flex(
  direction: Axis.horizontal,
  mainAxisAlignment: MainAxisAlignment.start,
  mainAxisSize: MainAxisSize.max,
  children: children
);

Widget rightAlignedSection(List<Widget> children) => Flex(
  direction: Axis.horizontal,
  mainAxisAlignment: MainAxisAlignment.end,
  mainAxisSize: MainAxisSize.max,
  children: children
);

Widget genericLoader() => SafeArea(
  child: Scaffold(
    backgroundColor: Colors.white,
    body: Center(child:CircularProgressIndicator())
  )
);

Widget noResultPlaceholderVec(String message, String subMessage, {Widget additionalWidget}) => Container(
  margin: new EdgeInsets.only(top: 50.0),
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
    children: [
      // Image(image: image, height: 150.0,),
      Container(
        margin: new EdgeInsets.all(10.0),
        child: Text(message,textAlign: TextAlign.center,),
      ),
      Container(
        width: 250.0,
        margin: new EdgeInsets.only(bottom: 10.0),
        child: Center(child: Text(subMessage,textAlign: TextAlign.center)),
      ),
      additionalWidget??Container()
    ],
  ) ),
);

Widget verticalGridStream(Stream<QuerySnapshot> listCollectionStream, dynamic listItemAdapter, 
  {dynamic noResult, dynamic addWidget, dynamic where, int crossAxisCount = 2, 
  double childAspectRatio = 3.0, double crossAxisSpacing = 5.0, double mainAxisSpacing = 5.0,}) => StreamBuilder<QuerySnapshot>(
    stream: listCollectionStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError) {
        return noResult!=null?noResult(context,List<DocumentSnapshot>()):
        noResultPlaceholder("Nothing to show");
      }
      
      if(snapshot.hasData) {
          if(snapshot.data.documents.length == 0) {
            return noResult!=null?noResult(context,List<DocumentSnapshot>()):noResultPlaceholder("Nothing to show");
          }
          List<DocumentSnapshot> docs = where==null? snapshot.data.documents : snapshot.data.documents.where(where).toList();
          return addWidget!=null?Column(
            children: <Widget>[
              addWidget(context,docs),
              GridView.count(
                padding: new EdgeInsets.only(top: 0.0),
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                shrinkWrap: true,
                primary: false,
                children: List.generate(docs.length, (index) => listItemAdapter(context, docs[index], docs) ),
              ),
            ],
          ): GridView.count(
              padding: new EdgeInsets.only(top: 0.0),
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              shrinkWrap: true,
              primary: false,
              children: List.generate(docs.length, (index) => listItemAdapter(context, docs[index], docs) ),
            );
      }

      if(snapshot.connectionState==ConnectionState.waiting) return listViewPlaceholder();
      return listViewPlaceholder();
    },
  );

  Widget verticalListStream(Stream<QuerySnapshot> listCollectionStream, dynamic listItemAdapter, 
  {dynamic noResult, dynamic addWidget, dynamic where}) => StreamBuilder<QuerySnapshot>(
    stream: listCollectionStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError) return noResult!=null?noResult(context,List<DocumentSnapshot>()):
        noResultPlaceholder("Nothing to show");
      
      if(snapshot.hasData) {
          if(snapshot.data.documents.length == 0) return noResult!=null?noResult(context,List<DocumentSnapshot>()):noResultPlaceholder("Nothing to show");
          List<DocumentSnapshot> docs = where==null? snapshot.data.documents : snapshot.data.documents.where(where).toList();
          return addWidget!=null?Column(
            children: <Widget>[
              addWidget(context,docs),
              ListView.builder(
                shrinkWrap: true,
                padding: new EdgeInsets.all(0.0),
                itemCount: docs.length,
                primary: false,
                itemBuilder: (BuildContext context, int index) => listItemAdapter(context, docs[index], docs)
              )
            ],
          ): ListView.builder(
              shrinkWrap: true,
              padding: new EdgeInsets.all(0.0),
              itemCount: docs.length,
              primary: false,
              itemBuilder: (BuildContext context, int index) => listItemAdapter(context, docs[index], docs)
            );
      }

      if(snapshot.connectionState==ConnectionState.waiting) return listViewPlaceholder();
      return listViewPlaceholder();
    },
  );

Widget noResultPlaceholder(String message) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Center(child: Text(message, style: TextStyle(fontSize: 12.0))),
);

Widget listViewPlaceholder() => Container(
  child: LinearProgressIndicator(),
);


