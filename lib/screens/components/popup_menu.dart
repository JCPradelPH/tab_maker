import 'package:flutter/material.dart';
import 'package:tab_maker/screens/utils/menu_adapter.dart';

class PopUpMenu extends StatelessWidget{

  final dynamic onSelect;
  final List<MenuAdapter> _choices;
  final Icon icon;

  PopUpMenu(this._choices,{this.onSelect,this.icon:const Icon(Icons.more_vert, color: Colors.black)});

  @override
  Widget build(BuildContext context) {
    return icon==null?PopupMenuButton<MenuAdapter>(
      padding: new EdgeInsets.all(0.0),
      onSelected: (menuAdapter) => onSelect(menuAdapter),
      itemBuilder: _menuChoices,
    ):PopupMenuButton<MenuAdapter>(
      padding: new EdgeInsets.all(0.0),
      icon: icon,
      onSelected: (menuAdapter) => onSelect(menuAdapter),
      itemBuilder: _menuChoices,
    );
  }

  List<PopupMenuEntry<MenuAdapter>> _menuChoices(BuildContext context) {
    return _choices
      .map( (choice) {
        return PopupMenuItem<MenuAdapter>(
          value: choice,
          child: _menuItems(choice),
        );
      }).toList();
  }

  _menuItems(choice) => choice.icon==null?ListTile(
    contentPadding: new EdgeInsets.all(0.0),
    title: Text(choice.title, style: TextStyle(fontSize: 14.0),)
  ):ListTile(
    contentPadding: new EdgeInsets.all(0.0),
    leading: Icon(choice.icon),
    title: Text(choice.title, style: TextStyle(fontSize: 14.0),)
  );
}