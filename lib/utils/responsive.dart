import 'package:flutter/widgets.dart';

/// Lebar maksimum isi halaman. Di layar lebar, isi dipusatkan.
const double kMaxContentWidth = 800;

/// Padding horizontal halaman: 20 di layar kecil, otomatis melebar di tablet.
double pagePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width > kMaxContentWidth + 40) {
    return (width - kMaxContentWidth) / 2;
  }
  return 20;
}
