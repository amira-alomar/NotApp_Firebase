import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(70),
          ),
          child: Image.asset(
            "assets/image/logo1.png",
            width: 100,
            height: 100,
          )),
    );
  }
}
