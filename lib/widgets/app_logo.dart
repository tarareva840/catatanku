import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo aplikasi: kotak hijau dengan ikon catatan dan titik kuning.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: AppShadows.soft,
            ),
            child: Center(
              child: Icon(
                Icons.edit_note_rounded,
                color: Colors.white,
                size: size * 0.6,
              ),
            ),
          ),
          Positioned(
            top: -size * 0.05,
            right: -size * 0.05,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: size * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
