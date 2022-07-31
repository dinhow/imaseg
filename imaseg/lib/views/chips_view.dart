import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../core/helpers/app_helper.dart';

class ChipsScreen extends StatefulWidget {
  const ChipsScreen({Key? key}) : super(key: key);

  @override
  State<ChipsScreen> createState() => _ChipsScreenState();
}

Future<String> _getString() async {
  String string = await Future.delayed(const Duration(seconds: 2), (() {
    return 'Teste';
  }));
  return string;
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String _dropdownChipValue = 'default';
String _dropdownClientValue = 'default';

List<DropdownMenuItem<String>> chipList = [
  const DropdownMenuItem(
    child: Text('Selecione um chip'),
    value: 'default',
  ),
  const DropdownMenuItem(
    child: Text('Virtueyes-Algar - 89553202100037317575'),
    value: '0',
  ),
  const DropdownMenuItem(
    child: Text('Virtueyes-Algar - 89553202100037318888'),
    value: '1',
  ),
  const DropdownMenuItem(
    child: Text('Virtueyes-Algar - 89553202100037312386'),
    value: '2',
  ),
  const DropdownMenuItem(
      child: Text('Virtueyes-Algar - 89553202100037315353'), value: '3')
];

List<DropdownMenuItem<String>> orderOfServiceList = [
  const DropdownMenuItem(
    child: Text('Selecione a Ordem de Serviço'),
    value: 'default',
  ),
  const DropdownMenuItem(
    child: Text('C154[001] - Fulano de Tal - 2500780'),
    value: '0',
  ),
  const DropdownMenuItem(
    child: Text('A104[001] - Ciclano de Tal - 2500789'),
    value: '1',
  ),
  const DropdownMenuItem(
    child: Text('1545[001] - Beltrano de Tal - 2500795'),
    value: '2',
  ),
];

class _ChipsScreenState extends State<ChipsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: ElevatedButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.blue)))),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If all fields is OK, show a alertDialog
                  // asking if the informations is correct
                  AppHelper.showNAlertDialog(context, const Text('Atenção'),
                      const Text('Chip informado está correto?'), [
                    TextButton(
                        onPressed: () {
                          Get.back();
                          sendForm();
                        },
                        child: const Text('Sim')),
                    TextButton(
                        onPressed: () => Get.back(), child: const Text('Não')),
                  ]);
                }
              },
              icon: const Icon(
                LineAwesomeIcons.link,
                size: 40,
              ),
              label: const Text(
                'Vincular',
                style: TextStyle(fontSize: 15),
              )),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Vincular Chip"),
          ),
          body: FutureBuilder(
              future: _getString(),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  default:
                    if (snapshot.hasData && !snapshot.hasError) {
                      return chipsViewContent();
                    } else {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                }
              }))),
    );
  }

  Widget chipsViewContent() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Chip',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _dropdownChipValue,
                    items: chipList,
                    onChanged: dropdownChipCallback,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Ordem de Serviço',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _dropdownClientValue,
                    items: orderOfServiceList,
                    onChanged: dropdownClientCallback,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //       width: MediaQuery.of(context).size.width,
                  //       height: 50,
                  //       child: ElevatedButton(
                  //           style: ButtonStyle(
                  //               shape: MaterialStateProperty.all<
                  //                       RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(10)))),
                  //           onPressed: () {
                  //             if (_formKey.currentState!.validate()) {
                  //               // If all fields is OK, show a alertDialog
                  //               // asking if the informations is correct
                  //               AppHelper.showNAlertDialog(
                  //                   context,
                  //                   const Text('Atenção'),
                  //                   const Text('Chip informado está correto?'), [
                  //                 TextButton(
                  //                     onPressed: () {
                  //                       Get.back();
                  //                       sendForm();
                  //                     },
                  //                     child: const Text('Sim')),
                  //                 TextButton(
                  //                     onPressed: () => Get.back(),
                  //                     child: const Text('Não')),
                  //               ]);
                  //             }
                  //           },
                  //           child: const Text(
                  //             "Vincular",
                  //             style: TextStyle(fontSize: 22),
                  //           ))),
                  // )
                ],
              ))
        ],
      ),
    );
  }

  void dropdownChipCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownChipValue = selectedValue;
      });
    }
  }

  void dropdownClientCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownClientValue = selectedValue;
      });
    }
  }

  sendForm() {}
}
