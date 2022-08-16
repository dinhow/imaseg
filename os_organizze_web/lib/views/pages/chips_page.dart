// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:ndialog/ndialog.dart';
import 'package:os_organizze_web/core/helpers/functions.dart';
import 'package:os_organizze_web/models/chip_model.dart';
import 'package:os_organizze_web/models/user_model.dart';

class ChipsPage extends StatefulWidget {
  const ChipsPage({Key? key, required this.user, required this.token})
      : super(key: key);

  final String token;
  final UserModel user;

  @override
  State<ChipsPage> createState() => _ChipsPageState();
}

class _ChipsPageState extends State<ChipsPage> {
  final StreamController<List<ChipModel>> _streamController =
      StreamController();

  final TextEditingController _apnController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _iccidController = TextEditingController();
  final TextEditingController _chipWithController = TextEditingController();

  final GlobalKey<FormState> _addChipKey = GlobalKey();
  final GlobalKey<FormState> _editChipKey = GlobalKey();

  late Timer _timer;
  late String _toChangeLinkedIn;

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _streamController.close();
    _apnController.dispose();
    _chipWithController.dispose();
    _companyController.dispose();
    _iccidController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      Functions.getChip(widget.token, context, _streamController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddChipDialog,
        backgroundColor: const Color(0xFF112535),
        child: const Icon(Icons.add),
      ),
      // HawkFabMenu(
      //   icon: AnimatedIcons.menu_arrow,
      //   fabColor: Colors.blue,
      //   iconColor: Colors.white,
      //   items: [
      //     HawkFabMenuItem(
      //       label: 'Adicionar Chip',
      //       ontap: () {
      //         _showAddChipDialog();
      //       },
      //       icon: const Icon(
      //         Icons.add,
      //         color: Colors.blue,
      //       ),
      //       color: Colors.white,
      //       labelColor: Colors.blue,
      //     ),
      //     HawkFabMenuItem(
      //       label: 'Víncular Chip',
      //       ontap: () {
      //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('Menu 2 selected')),
      //         );
      //       },
      //       icon: const Icon(
      //         Icons.link,
      //         color: Colors.white,
      //       ),
      //       labelColor: Colors.blue,
      //       labelBackgroundColor: Colors.white,
      //     ),
      //     HawkFabMenuItem(
      //       label: 'Pesquisar',
      //       labelColor: Colors.blue,
      //       ontap: () {
      //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('Menu 3 selected')),
      //         );
      //       },
      //       icon: const Icon(Icons.search),
      //     ),
      //   ],
      //   body: Container(),
      // ),
      body: StreamBuilder<List<ChipModel>>(
          stream: _streamController.stream,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Text('Aguarde...');
                } else {
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum chip cadastrado'));
                  } else {
                    return BuildChipWidget(snapshot.data!);
                  }
                }
            }
          })),
    );
  }

  Widget BuildChipWidget(List<ChipModel> chipModel) {
    return Center(
      child: ListView.builder(
        itemCount: chipModel.length,
        itemBuilder: (BuildContext context, index) {
          late String chipStatusName;
          late Color chipStatusIconColor;
          if (chipModel[index].chipStatus == 0) {
            chipStatusName = 'Desativado';
            chipStatusIconColor = Colors.red;
          } else if (chipModel[index].chipStatus == 1) {
            chipStatusName = 'Aguardando Vínculo';
            chipStatusIconColor = Colors.amber;
          } else if (chipModel[index].chipStatus == 2) {
            chipStatusName = 'Vinculado';
            chipStatusIconColor = Colors.green;
          } else {
            chipStatusName = 'Excluído';
            chipStatusIconColor = Colors.grey;
          }
          return Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TODO: Fazer tooltip caprichado
                  Tooltip(
                      message: chipStatusName,
                      child: IconButton(
                          onPressed: () {
                            _showChangeStatusChipDialog(chipModel[index]);
                          },
                          icon: Icon(
                            Icons.circle,
                            shadows: const [
                              Shadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(3, 3))
                            ],
                            color: chipStatusIconColor,
                          ))),
                ],
              ),
              title: Text(chipModel[index].chipIccid!),
              subtitle: Text(
                  '${chipModel[index].chipCompany} - ${chipModel[index].chipApn}\n${chipModel[index].chipWith!}'),
              trailing: IconButton(
                  onPressed: () {
                    _showEditChipDialog(chipModel[index]);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
              onTap: () => _showChipInfo(chipModel[index]),
            ),
          );
        },
      ),
    );
  }

  _showEditChipDialog(ChipModel chip) async {
    _apnController.text = chip.chipApn!;
    _companyController.text = chip.chipCompany!;
    _iccidController.text = chip.chipIccid!;
    _chipWithController.text = chip.chipWith!;

    await DialogBackground(
      blur: 3,
      dialog: AlertDialog(
        title: Center(
            child: Column(
          children: [
            const Text("Editar Chip"),
            Text("${chip.chipIccid}"),
          ],
        )),
        content: Form(
          key: _editChipKey,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _iccidController,
                      decoration: const InputDecoration(
                        counterText: "",
                        icon: Icon(Icons.sim_card),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'ICCID',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        if (value.length < 19) {
                          return 'O ICCID deve possuir de 19 à 20 dígitos';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.cell_tower),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Operadora',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      controller: _apnController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'APN',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      controller: _chipWithController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.pin_drop),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Localização',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        return null;
                      }),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () => _showDeleteChipConfirmation(chip),
              icon: const Icon(Icons.close),
              label: const Text('Excluir')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.backspace),
              label: const Text('Voltar')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              autofocus: true,
              onPressed: () {
                if (_editChipKey.currentState!.validate()) {
                  chip.chipIccid = _iccidController.text;
                  chip.chipCompany = _companyController.text;
                  chip.chipApn = _apnController.text;
                  chip.chipWith = _chipWithController.text;
                  Functions.editChip(chip, widget.token, context);
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Salvar')),
        ],
      ),
    ).show(context);
  }

  _showChipInfo(ChipModel chip) async {
    _apnController.text = chip.chipApn!;
    _companyController.text = chip.chipCompany!;
    _iccidController.text = chip.chipIccid!;
    _chipWithController.text = chip.chipWith!;

    await DialogBackground(
      blur: 3,
      dialog: AlertDialog(
        title: Center(
            child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ))
                ]),
                const Text("Informações do Chip"),
              ],
            ),
          ],
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'ICCID: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.chipIccid!)
              ],
            ),
            Row(
              children: [
                const Text(
                  'Adicionado: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(DateFormat('dd/MM/yy - hh:mm').format(chip.addAt!))
              ],
            ),
            // Row(
            //   children: [
            //     const Text(
            //       'Cancelado: ',
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     Text(DateFormat('dd/MM/yy - hh:mm').format(chip.cancelledAt!))
            //   ],
            // ),
            const Divider(thickness: 1),
            Row(
              children: [
                const Text(
                  'Operadora: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.chipCompany!)
              ],
            ),
            Row(
              children: [
                const Text(
                  'APN: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.chipApn!)
              ],
            ),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.chipStatus == 0
                    ? 'Cancelado'
                    : chip.chipStatus == 1
                        ? 'Em estoque'
                        : chip.chipStatus == 2
                            ? 'Vinculado'
                            : '--')
              ],
            ),
            const Divider(thickness: 1),
            Row(
              children: [
                const Text(
                  'Chip com: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.chipWith ?? '--')
              ],
            ),
            Row(
              children: [
                const Text(
                  'Entregue dia: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    '${DateFormat('dd-MM-yy').format(chip.chipWithAt!)} às ${DateFormat('kk:mm').format(chip.chipWithAt!)}')
              ],
            ),
            const Divider(thickness: 1),
            Row(
              children: [
                const Text(
                  'Vinculado por: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.linkedBy ?? '--')
              ],
            ),
            Row(
              children: [
                const Text(
                  'No cliente: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(chip.linkedIn ?? '--')
              ],
            ),
            Row(
              children: [
                const Text(
                  'No dia: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    '${DateFormat('dd-MM-yy').format(chip.linkedAt!)} às ${DateFormat('kk:mm').format(chip.linkedAt!)}')
              ],
            ),
          ],
        ),
        actions: <Widget>[
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => _showDeleteChipConfirmation(chip),
                  icon: const Icon(Icons.close),
                  label: const Text('Excluir')),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  autofocus: true,
                  onPressed: () {
                    _showEditChipDialog(chip);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar')),
            ],
          ),
        ],
      ),
    ).show(context);
  }

  _showDeleteChipConfirmation(ChipModel chip) async {
    await DialogBackground(
      dialog: AlertDialog(
        title: const Center(child: Text("Atenção!")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Você irá remover o chip:'),
            Text(
              chip.chipIccid!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
                "\nEsta ação não poderá ser desfeita! Deseja continuar?"),
          ],
        ),
        actions: <Widget>[
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.keyboard_arrow_left),
              label: const Text('Voltar')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () {
                chip.cancelledBy = widget.user.firstName!;
                Functions.removeChip(chip, widget.token, context);
              },
              icon: const Icon(Icons.close),
              label: const Text('Sim')),
        ],
      ),
    ).show(context);
  }

  _showChangeStatusChipDialog(ChipModel chip) async {
    int? selectedOption;
    final groupButtonController =
        GroupButtonController(selectedIndex: chip.chipStatus);
    await DialogBackground(
      dialog: AlertDialog(
        title: const Center(child: Text("Alterar status do chip")),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GroupButton(
                options: const GroupButtonOptions(elevation: 2),
                key: const Key('status'),
                controller: groupButtonController,
                buttons: const ['Cancelado', 'Em estoque', 'Vincular'],
                onSelected: (i, selected, a) {
                  Functions.printOnDebugMode(selected);
                  selectedOption = selected;
                },
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.keyboard_arrow_left),
              label: const Text('Voltar')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                if (selectedOption == 2) {
                  _showSelectClientToLinkChipDialog(chip);
                } else if (selectedOption != null) {
                  chip.chipStatus = selectedOption;
                  Functions.changeChipStatus(chip, widget.token, context);
                } else {
                  Get.back();
                  setState(() {});
                  Functions.showInfoSnackbar(
                      "ATENÇÂO", "Nenhuma alteração efetuada", context);
                }
              },
              icon: const Icon(Icons.update),
              label: const Text('Alterar')),
        ],
      ),
    ).show(context);
  }

  _showSelectClientToLinkChipDialog(ChipModel chip) async {
    final List<Map<String, dynamic>> roles = [
      {"name": "Super Admin", "desc": "Having full access rights", "role": 1},
      {
        "name": "Admin",
        "desc": "Having full access rights of a Organization",
        "role": 2
      },
      {
        "name": "Manager",
        "desc": "Having Magenent access rights of a Organization",
        "role": 3
      },
      {
        "name": "Technician",
        "desc": "Having Technician Support access rights",
        "role": 4
      },
      {
        "name": "Customer Support",
        "desc": "Having Customer Support access rights",
        "role": 5
      },
      {"name": "User", "desc": "Having End User access rights", "role": 6},
    ];
    await DialogBackground(
      dialog: AlertDialog(
        title: const Center(child: Text("Vincular com:")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownFormField<Map<String, dynamic>>(
              onEmptyActionPressed: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  labelText: "Cliente"),
              onSaved: (dynamic str) {},
              onChanged: (dynamic str) {
                Functions.printOnDebugMode(str['name']);
                _toChangeLinkedIn = str['name'];
              },
              validator: (dynamic str) {
                return null;
              },
              displayItemFn: (dynamic item) => Text(
                (item ?? {})['name'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              selectedFn: (dynamic item1, dynamic item2) {
                if (item1 != null && item2 != null) {
                  return item1['name'] == item2['name'];
                }
                return false;
              },
              findFn: (dynamic str) async => roles,
              filterFn: (dynamic item, str) =>
                  item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
              dropdownItemFn: (dynamic item, position, focused,
                      dynamic lastSelectedItem, onTap) =>
                  ListTile(
                title: Text(item['name']),
                subtitle: Text(
                  item['desc'] ?? '',
                ),
                tileColor: focused
                    ? const Color.fromARGB(20, 0, 0, 0)
                    : Colors.transparent,
                onTap: onTap,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.backspace),
              label: const Text('Voltar')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                chip.linkedBy = widget.user.username;
                chip.linkedIn = _toChangeLinkedIn;
                Functions.linkClientWithChip(chip, widget.token, context);
              },
              icon: const Icon(Icons.update),
              label: const Text('Alterar')),
        ],
      ),
    ).show(context);
  }

  _showAddChipDialog() async {
    await DialogBackground(
      blur: 3,
      dialog: AlertDialog(
        title: const Center(child: Text("Cadastrar chip")),
        content: Form(
          key: _addChipKey,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      maxLength: 20,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _iccidController,
                      decoration: const InputDecoration(
                        counterText: "",
                        icon: Icon(Icons.sim_card),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'ICCID',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        if (value.length < 19) {
                          return 'O ICCID deve possuir de 19 à 20 dígitos';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.cell_tower),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Operadora',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                      controller: _apnController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'APN',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                        return null;
                      }),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
              label: const Text('Voltar')),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              autofocus: true,
              onPressed: () {
                if (_addChipKey.currentState!.validate()) {
                  ChipModel chip = ChipModel();
                  chip.chipIccid = _iccidController.text;
                  chip.chipCompany = _companyController.text;
                  chip.chipApn = _apnController.text;
                  Functions.addNewChip(chip, widget.token, context);
                  clearTextControllers();
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Cadastrar')),
        ],
      ),
    ).show(context);
  }

  void clearTextControllers() {
    _apnController.clear();
    _chipWithController.clear();
    _companyController.clear();
    _iccidController.clear();
  }
}
