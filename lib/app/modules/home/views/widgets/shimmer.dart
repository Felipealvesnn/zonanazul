import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zona_azul/app/theme/tema.dart';

class ShimmerHomer extends StatelessWidget {
  const ShimmerHomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Get.theme.primaryColor,
        highlightColor: Colors.grey[300]!,
        child: const Text(
          'Zona Azul',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
