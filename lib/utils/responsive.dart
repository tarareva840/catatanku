import 'package:flutter/widgets.dart';

const double kMaxContentWidth = 800;

double pagePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width > kMaxContentWidth + 40) {
    return (width - kMaxContentWidth) / 2;
  }
  return 20;
}
