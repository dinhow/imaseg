import 'package:flutter/material.dart';

class MaintanceInfo extends StatelessWidget {
  const MaintanceInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.construction_rounded,
            size: 150,
          ),
          Text(
            "Em breve",
            style: TextStyle(fontSize: 40),
          ),
        ],
      ),
    );
  }
}
