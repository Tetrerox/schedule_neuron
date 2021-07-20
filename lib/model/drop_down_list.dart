import 'package:flutter/material.dart';
import 'package:schedule_neuron/model/drop_down_item.dart';

class DropDownList {
  static const List<DropDownItem> itemsFirst = [
    itemsLogOut,
  ];

  static const itemsLogOut = DropDownItem(
    text: 'Log-Out',
    icon: Icons.logout,
  );

  static const List<DropDownItem> itemsSecond = [
    itemsCredit,
  ];

  static const itemsTheme = DropDownItem(
    text: 'Theme',
    icon: Icons.star_half_rounded,
  );

  static const itemsCredit = DropDownItem(
    text: 'Credits',
    icon: Icons.folder_open,
  );
}
