import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:risetech_smart_os/core/helpers/app_helper.dart';
import 'package:risetech_smart_os/core/helpers/budget_helper.dart';
import 'package:risetech_smart_os/models/budget_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _localContactNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String company = '';
  String account = '';
  String clientName = '';
  String localContactName = '';
  String email = '';
  String detailedBudget = '';

  List<DropdownMenuItem<String>> items = const [
    DropdownMenuItem(
      child: Text('Force'),
      value: 'Force',
    ),
    DropdownMenuItem(
      child: Text('GPS'),
      value: 'GPS',
    )
  ];

  String _dropdownValue = 'Force';

  bool _needSimCard = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Orçamento"),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Selecione a Empresa: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            DropdownButton<String>(
                              value: _dropdownValue,
                              items: items,
                              onChanged: dropdownCallback,
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _accountController,
                        validator: (value) {
                          if (value!.length < 4) {
                            return 'A conta deve possuir 4 caractéres!';
                          }
                          if (value.isEmpty) {
                            return 'Não pode estar em branco!';
                          }
                          if (value.contains(RegExp(r'[G-Z]'))) {
                            return 'Letra inválida, aceita apenas de "A" a "F"';
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Conta',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _clientNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Não pode estar em branco!';
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Nome do cliente',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _localContactNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Deve ser pego um nome de contato!';
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Contato no local com:',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Não pode estar em branco!';
                          }
                          if (!value.contains('@')) {
                            return 'Insira um e-mail válido';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'E-mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _budgetController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Não pode estar em branco!';
                          }
                        },
                        minLines: 1,
                        maxLines: 9999,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Orçamento detalhado',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SwitchListTile(
                          title: const Text('Enviar proposta de chip?'),
                          value: _needSimCard,
                          onChanged: (bool value) {
                            setState(() {
                              _needSimCard = value;
                            });
                          }),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // If all fields is OK, show a alertDialog
                                // asking if the informations is correct
                                AppHelper.showNAlertDialog(
                                    context,
                                    const Text('Atenção'),
                                    const Text(
                                        'Todos os dados estão corretos?'),
                                    [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                            saveForm();
                                          },
                                          child: const Text('Sim')),
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Não')),
                                    ]);
                              }
                            },
                            child: const Text(
                              "Enviar",
                              style: TextStyle(fontSize: 22),
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  saveForm() {
    // company = _dropdownValue;
    // account = _accountController.text;
    // clientName = _clientNameController.text;
    // localContactName = _localContactNameController.text;
    // email = _emailController.text;
    // detailedBudget = _budgetController.text;

    final String formattedBudget = BudgetModel(
            company: _dropdownValue,
            clientAccount: _accountController.text,
            clientName: _clientNameController.text,
            localContactName: _localContactNameController.text,
            email: _emailController.text,
            detailedBudget: _budgetController.text,
            needChip: _needSimCard)
        .formatToClipboard();

    if (!kIsWeb) {
      BudgetHelper().sendData(formattedBudget);
    }
  }
}
