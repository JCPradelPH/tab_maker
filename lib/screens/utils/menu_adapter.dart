
import 'package:flutter/material.dart';

// global adapter for list items, spinners and menu items
class MenuAdapter {
  const MenuAdapter({ 
    this.title, 
    this.icon, 
    this.iconColor, 
    this.flag, 
    this.actionId, 
    this.listImage, 
    this.subTitle1, 
    this.subTitle2, 
    this.subTitle3, 
    this.tapEvent, 
    this.alwaysOn, 
    this.listTitle });
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool flag;
  final bool alwaysOn;
  final dynamic actionId;
  final Image listImage;
  final String listTitle;
  final String subTitle1;
  final String subTitle2;
  final String subTitle3;
  final VoidCallback tapEvent;
}