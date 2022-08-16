

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ndialog/ndialog.dart';

// class AddChipDialog {
//   final BuildContext context;
//   final TextEditingController _apnController;
//   final TextEditingController _companyController;
//   final TextEditingController _iccidController;
//   final GlobalKey<FormState> _addChipKey;

//   AddChipDialog(this.context, this._apnController, this._companyController,
//       this._iccidController, this._addChipKey);

//   showAddChipDialog() async {
//     await DialogBackground(
//       blur: 3,
//       dialog: AlertDialog(
//         title: const Center(child: Text("Cadastrar chip")),
//         content: Form(
//           key: _addChipKey,
//           child: SizedBox(
//             width: 300,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: TextFormField(
//                       maxLength: 20,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: _iccidController,
//                       decoration: const InputDecoration(
//                         counterText: "",
//                         icon: Icon(Icons.sim_card),
//                         border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(20))),
//                         labelText: 'ICCID',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Não pode estar em branco!';
//                         }
//                         if (value.length < 19) {
//                           return 'O ICCID deve possuir de 19 à 20 dígitos';
//                         }
//                         return null;
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: TextFormField(
//                       controller: _companyController,
//                       decoration: const InputDecoration(
//                         icon: Icon(Icons.cell_tower),
//                         border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(20))),
//                         labelText: 'Operadora',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Não pode estar em branco!';
//                         }
//                         return null;
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: TextFormField(
//                       controller: _apnController,
//                       decoration: const InputDecoration(
//                         icon: Icon(Icons.link),
//                         border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(20))),
//                         labelText: 'APN',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Não pode estar em branco!';
//                         }
//                         return null;
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           ElevatedButton.icon(
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.red)),
//               onPressed: () => Get.back(),
//               icon: const Icon(Icons.close),
//               label: const Text('Voltar')),
//           ElevatedButton.icon(
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.green)),
//               autofocus: true,
//               onPressed: () {
//                 if (_addChipKey.currentState!.validate()) {
//                   _addNewChip();
//                 }
//               },
//               icon: const Icon(Icons.check),
//               label: const Text('Cadastrar')),
//         ],
//       ),
//     ).show(context);
//   }

//   Future<void> _addNewChip() async {
//     try {
//       var url = Uri.parse('http://localhost:8000/chips/');
//       var body = json.encode({
//         "chip_iccid": _iccidController.text,
//         "chip_company": _companyController.text,
//         "chip_apn": _apnController.text,
//         "chip_with": "Base",
//       });
//       final response = await http.post(url, body: body, headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer ${widget.token}'
//       });
//       if (response.statusCode == 201) {
//         Get.back();
//         setState(() {});
//         Get.snackbar(_iccidController.text, "Chip cadastrado com sucesso!",
//             backgroundColor: Colors.green,
//             icon: const Icon(Icons.check),
//             duration: const Duration(seconds: 5),
//             margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
//         _apnController.clear();
//         _companyController.clear();
//         _iccidController.clear();
//       } else if (response.statusCode == 400 &&
//           response.body.contains('existe')) {
//         Get.snackbar(
//             "Atenção", "Chip de ICCID ${_iccidController.text} já cadastrado",
//             backgroundColor: Colors.red,
//             icon: const Icon(Icons.error),
//             duration: const Duration(seconds: 5),
//             margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erro');
//       }
//     }
//   }
// }
