import 'package:flutter/material.dart';
import 'package:risetech_smart_os/views/suport_view.dart';
import 'budget_view.dart';
import 'closure_view.dart';
import 'scheduling_view.dart';

import 'chips_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("RiseTech OS Organizze"),
            // actions: [
            //   IconButton(
            //       onPressed: () {}, icon: const Icon(Icons.notifications))
            // ],
          ),
          body: GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BudgetScreen()));
                },
                child: const Center(child: Text("Orçamentos")),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClosureScreen()));
                },
                child: const Center(child: Text("Fechamentos")),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SchedulingScreen()));
                },
                child: const Center(child: Text("Agendamentos")),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChipsScreen()));
                },
                child: const Center(child: Text("CHIPs")),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuportScreen()));
                },
                child: const Center(child: Text("Suporte")),
              ),
            ],
          )),
    );
  }
}
