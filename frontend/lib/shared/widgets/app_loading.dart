import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double size;
  const AppLoading({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
              color: AppColors.primaryGreen, strokeWidth: 3),
        ),
      );
}
