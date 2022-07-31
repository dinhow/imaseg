// import 'package:flutter/material.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:risetech_smart_os/core/helpers/app_helper.dart';

// class ListviewBuilder extends StatefulWidget {

//   const ListviewBuilder({ Key? key }) : super(key: key);

//   @override
//   State<ListviewBuilder> createState() => _ListviewBuilderState();
// }

// class _ListviewBuilderState extends State<ListviewBuilder> {

//    @override
//    Widget build(BuildContext context) {
//        return ListView.builder(
//                                                   shrinkWrap: true,
//                                                   physics:
//                                                       const NeverScrollableScrollPhysics(),
//                                                   itemCount: _users.length,
//                                                   itemBuilder:
//                                                       (BuildContext context,
//                                                           int index) {
//                                                     return ListTile(
//                                                       leading: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Text(_users[index]
//                                                                   ['number']
//                                                               .toString()),
//                                                         ],
//                                                       ),
//                                                       title: Text(_users[index]
//                                                           ['name']),
//                                                       trailing: IconButton(
//                                                           onPressed: () {
//                                                             AppHelper.showNAlertDialog(
//                                                                 context,
//                                                                 Text(
//                                                                     'Remover usuário ${_users[index]['name']} ?'),
//                                                                 const Text(
//                                                                     'Esta operação não poderá ser desfeita!'),
//                                                                 [
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () => Get
//                                                                               .back(),
//                                                                       child:
//                                                                           const Text(
//                                                                         'Cancelar',
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 Colors.red),
//                                                                       )),
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         AppHelper.showCustomSnackbar(
//                                                                             '${_users[index]['name']} removido',
//                                                                             Colors.red,
//                                                                             3);
//                                                                         _users.removeAt(
//                                                                             index);
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         'Confirmar',
//                                                                       ))
//                                                                 ]);
//                                                           },
//                                                           icon: const Icon(
//                                                               LineAwesomeIcons
//                                                                   .trash)),
//                                                     );
//                                                   }),
//   }
// }