import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:os_organizze_web/models/user_model.dart';
import 'package:os_organizze_web/views/pages/chips_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.token, required this.user, Key? key})
      : super(key: key);

  final UserModel user;
  final String token;

  @override
  State<HomeView> createState() => _HomeViewState();
}

PageController page = PageController();

List<SideMenuItem> items = [
  // SideMenuItem(
  //   // Priority of item to show on SideMenu, lower value is displayed at the top
  //   priority: 0,
  //   title: 'Técnicos',
  //   onTap: () => page.jumpToPage(0),
  //   icon: const Icon(FontAwesomeIcons.toolbox),
  //   badgeContent: const Text(
  //     '3',
  //     style: TextStyle(color: Colors.white),
  //   ),
  // ),
  // SideMenuItem(
  //   priority: 1,
  //   title: 'Passagens',
  //   onTap: () => page.jumpToPage(1),
  //   icon: const Icon(Icons.note_add),
  // ),
  SideMenuItem(
    priority: 0,
    title: 'Chips',
    onTap: () => page.jumpToPage(0),
    icon: const Icon(Icons.sim_card),
  ),
  SideMenuItem(
    priority: 1,
    title: 'Administração',
    onTap: () => page.jumpToPage(1),
    icon: const Icon(Icons.admin_panel_settings),
  ),
];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset("images/logo_gps.png"),
          // Image.network(
          //     'https://www.gpssa.com.br/wp-content/uploads/2020/05/logo_gps.png'),
          actions: [
            Row(
              children: [
                Text(
                  widget.user.firstName!,
                  style: const TextStyle(color: Colors.black),
                ),
                IconButton(
                    onPressed: () => exit(0),
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    )),
              ],
            )
          ],
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              // Page controller to manage a PageView
              controller: page,
              style: SideMenuStyle(
                  unselectedIconColor: Colors.white,
                  unselectedTitleTextStyle:
                      const TextStyle(color: Colors.white),
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  backgroundColor: const Color(0xFF112535)),
              // Will shows on top of all items, it can be a logo or a Title text
              //title: Image.asset('/images/logo_gps.png'),
              // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
              footer: TextButton(
                onPressed: () {},
                child: const Text('Criado por Rodrigues',
                    style: TextStyle(color: Colors.white)),
              ),
              // Notify when display mode changed
              onDisplayModeChanged: (mode) {
                if (kDebugMode) {
                  print(mode);
                }
              },
              // List of SideMenuItem to show them on SideMenu
              items: items,
            ),
            Expanded(
              child: PageView(
                controller: page,
                children: [
                  // Container(
                  //   child: Center(
                  //     child: Text('Orçamentos'),
                  //   ),
                  // ),
                  // Container(
                  //   child: Center(
                  //     child: Text('Passagens'),
                  //   ),
                  // ),
                  ChipsPage(user: widget.user, token: widget.token),
                  Container(
                    child: Center(
                      child: Text('Administração'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
