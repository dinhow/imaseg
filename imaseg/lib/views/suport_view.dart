import 'package:flutter/material.dart';
import 'package:risetech_smart_os/core/widgets/maintance_info.dart';

class SuportScreen extends StatefulWidget {
  const SuportScreen({Key? key}) : super(key: key);

  @override
  State<SuportScreen> createState() => _SuportScreenState();
}

class _SuportScreenState extends State<SuportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Suporte"),
          ),
          body: const MaintanceInfo()),
    );
  }
}
