import 'package:flutter/material.dart';

mixin CrossaxisWidget {
  int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return 4;  
    if (width > 600) return 3;  
    return 2;                   
  }
}