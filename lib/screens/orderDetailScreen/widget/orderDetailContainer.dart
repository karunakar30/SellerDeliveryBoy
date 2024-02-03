

import 'package:greenfield_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
getOrderDetailContainer({required String title, required String value}) {
  return Row(
    children: [
      Expanded(
        flex: 5,
        child: Text(
          title,
          softWrap: true,
          style: TextStyle(color: ColorsRes.grey),
        ),
      ),
      Widgets.getSizedBox(width: 10),
      Expanded(
        flex: 10,
        child: Text(
          value,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
    ],
  );
}
