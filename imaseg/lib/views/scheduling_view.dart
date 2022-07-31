import 'package:flutter/material.dart';
import 'package:risetech_smart_os/core/widgets/maintance_info.dart';

class SchedulingScreen extends StatefulWidget {
  const SchedulingScreen({Key? key}) : super(key: key);

  @override
  State<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
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
            title: const Text("Agendamentos"),
          ),
          body: const MaintanceInfo()),
    );
  }
}
