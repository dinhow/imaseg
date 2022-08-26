import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:risetech_smart_os/core/helpers/app_helper.dart';
import 'package:risetech_smart_os/core/helpers/closure_helper.dart';
import 'package:risetech_smart_os/core/widgets/maintance_info.dart';
import 'package:risetech_smart_os/models/alarm_panel_model.dart';
import 'package:risetech_smart_os/models/cftv_model.dart';
import 'package:risetech_smart_os/models/client_model.dart';

//TODO: Fazer os VALIDATORS!

class ClosureScreen extends StatefulWidget {
  const ClosureScreen({Key? key}) : super(key: key);

  @override
  State<ClosureScreen> createState() => _ClosureScreenState();
}

class _ClosureScreenState extends State<ClosureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _contactsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _zonesFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _usersFormKey = GlobalKey<FormState>();

  //Controladores de dados de identificação do cliente
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  //final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _verbalPasswordAskController =
      TextEditingController();
  final TextEditingController _verbalPasswordAnswerController =
      TextEditingController();

  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneNumberController =
      TextEditingController();

  //Tipo de dados a serem inseridos
  bool _alarmMonitoring = false;
  bool _cftvMonitoring = false;

  //Controladores de dados do alarme
  final TextEditingController _alarmVendorController = TextEditingController();
  final TextEditingController _alarmModelController = TextEditingController();
  final TextEditingController _alarmMacController = TextEditingController();
  final TextEditingController _zoneNumberController = TextEditingController();
  final TextEditingController _zoneNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userNumberController = TextEditingController();
  final TextEditingController _alarmMasterPasswordController =
      TextEditingController();
  final TextEditingController _alarmProgrammingPasswordController =
      TextEditingController();
  final TextEditingController _alarmRemoteAccessPasswordController =
      TextEditingController();

  //Controladores de dados do CFTV
  final TextEditingController _dvrVendorController = TextEditingController();
  final TextEditingController _dvrModelController = TextEditingController();
  final TextEditingController _dvrSerialNumberController =
      TextEditingController();
  final TextEditingController _dvrAddressController = TextEditingController();
  final TextEditingController _dvrHttpController = TextEditingController();
  final TextEditingController _dvrTcpController = TextEditingController();
  final TextEditingController _dvrRtspController = TextEditingController();
  final TextEditingController _dvrUserController = TextEditingController();
  final TextEditingController _dvrPasswordController = TextEditingController();
  final TextEditingController _dvrCamQttController = TextEditingController();
  final TextEditingController _zoneToCamController = TextEditingController();

  //Confirmar se configurações de Encoder foram efetuadas
  bool _is32kbps = false;

  //Confirmar se procedimentos foram efetuados
  bool _wasLinked = false;
  bool _wasPhotoTaken = false;
  //bool _needComments = false;

  //Lista de contatos
  final List<Map<String, dynamic>> _contacts = [];

  //Lista de zonas
  final List<Map<String, dynamic>> _zones = [];

  //Lista de usuários
  final List<Map<String, dynamic>> _users = [];

  bool inDebug = false;

  String _formattedAlarmPanelData = '';
  String _formattedCftvData = '';

  bool _isIntelbras = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Fechamento / Passagem"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    if (_wasPhotoTaken) {
                      if (_formKey.currentState!.validate()) {
                        // If all fields is OK, show a alertDialog
                        // asking if the informations is correct
                        AppHelper.showNAlertDialog(
                            context,
                            const Text('Atenção'),
                            const Text('Todos os dados estão corretos?'), [
                          TextButton(
                              onPressed: () {
                                saveForm();
                              },
                              child: const Text('Sim')),
                          TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Não')),
                        ]);
                      }
                    } else {
                      AppHelper.showCustomSnackbar(
                          "Necessário tirar as fotos!", Colors.red, 3);
                    }
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
          body: !inDebug
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Identificação',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                maxLength: 4,
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                  counterText: '',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  labelText: 'Conta',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                  controller: _clientNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    labelText: 'Nome do cliente',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Não pode estar em branco!';
                                    }
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Senha Verbal',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFormField(
                                  controller: _verbalPasswordAskController,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    labelText: 'Pergunta',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Não pode estar em branco!';
                                    }
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                  controller: _verbalPasswordAnswerController,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    labelText: 'Resposta',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Não pode estar em branco!';
                                    }
                                  }),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Contatos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            _contacts.isEmpty
                                ? ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                                        'Nenhum contato adicionado'))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _contacts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.contact_phone_rounded),
                                          ],
                                        ),
                                        title: Text(_contacts[index]['name']),
                                        subtitle:
                                            Text(_contacts[index]['phone']),
                                        trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _contacts.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(
                                                LineAwesomeIcons.trash)),
                                      );
                                    }),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: () => setState(() {
                                            addContactToList();
                                          }),
                                      icon: const Icon(LineAwesomeIcons.plus),
                                      label: const Text("Adicionar"))
                                  // Ink(
                                  //   child: IconButton(
                                  //       onPressed: () {
                                  //         setState(() {
                                  //           addContactToList();
                                  //         });
                                  //       },
                                  //       icon: const Icon(Icons.add)),
                                  //   decoration: const ShapeDecoration(
                                  //       shape: CircleBorder(),
                                  //       color: Colors.green),
                                  // ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 2),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SwitchListTile(
                                  title:
                                      const Text('O Alarme será monitorado?'),
                                  value: _alarmMonitoring,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _alarmMonitoring = value;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SwitchListTile(
                                  title: const Text('O CFTV será monitorado?'),
                                  value: _cftvMonitoring,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _cftvMonitoring = value;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SwitchListTile(
                                  title: const Text(
                                      'Foi necessário vincular chip?'),
                                  value: _wasLinked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _wasLinked = value;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SwitchListTile(
                                  title: const Text(
                                      'Foram tiradas todas as fotos?'),
                                  value: _wasPhotoTaken,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _wasPhotoTaken = value;
                                    });
                                  }),
                            ),
                            if (_alarmMonitoring)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ExpansionTile(
                                    title: Column(
                                      children: const [Text("Dados de Alarme")],
                                    ),
                                    children: [
                                      ListTile(
                                          title: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value.toLowerCase() ==
                                                      'intelbras') {
                                                    _isIntelbras = true;
                                                  } else {
                                                    _isIntelbras = false;
                                                  }
                                                });
                                              },
                                              controller:
                                                  _alarmVendorController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText:
                                                    'Fabricante (Central)',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _alarmModelController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Modelo',
                                              ),
                                            ),
                                          ),
                                          if (_isIntelbras)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: TextFormField(
                                                controller: _alarmMacController,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  labelText: 'MAC',
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller:
                                                  _alarmMasterPasswordController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Senha MASTER',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller:
                                                  _alarmProgrammingPasswordController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText:
                                                    'Senha de PROGRAMAÇÃO',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: TextFormField(
                                              controller:
                                                  _alarmRemoteAccessPasswordController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText:
                                                    'Senha de ACESSO REMOTO',
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                              height: 1, thickness: 1),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            child: Text(
                                              'Setorização',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          _zones.isEmpty
                                              ? ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Nenhum setor adicionado'))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: _zones.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListTile(
                                                      leading: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(_zones[index]
                                                                  ['number']
                                                              .toString()),
                                                        ],
                                                      ),
                                                      title: Text(_zones[index]
                                                          ['name']),
                                                      trailing: IconButton(
                                                          onPressed: () {
                                                            AppHelper.showNAlertDialog(
                                                                context,
                                                                Text(
                                                                    'Remover setor ${_zones[index]['name']} ?'),
                                                                const Text(
                                                                    'Esta operação não poderá ser desfeita!'),
                                                                [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () => Get
                                                                              .back(),
                                                                      child:
                                                                          const Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          Get.back();
                                                                          AppHelper.showCustomSnackbar(
                                                                              '${_zones[index]['name']} removido',
                                                                              Colors.red,
                                                                              3);
                                                                          _zones
                                                                              .removeAt(index);
                                                                        });
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Remover',
                                                                      ))
                                                                ]);
                                                          },
                                                          icon: const Icon(
                                                              LineAwesomeIcons
                                                                  .trash)),
                                                    );
                                                  }),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton.icon(
                                                    onPressed: () =>
                                                        setState(() {
                                                          addZoneToList();
                                                        }),
                                                    icon: const Icon(
                                                        LineAwesomeIcons.plus),
                                                    label:
                                                        const Text("Adicionar"))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                              height: 1, thickness: 1),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            child: Text(
                                              'Usuários',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          _users.isEmpty
                                              ? ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Nenhum usuário adicionado'))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: _users.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListTile(
                                                      leading: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(_users[index]
                                                                  ['number']
                                                              .toString()),
                                                        ],
                                                      ),
                                                      title: Text(_users[index]
                                                          ['name']),
                                                      trailing: IconButton(
                                                          onPressed: () {
                                                            AppHelper.showNAlertDialog(
                                                                context,
                                                                Text(
                                                                    'Remover usuário ${_users[index]['name']} ?'),
                                                                const Text(
                                                                    'Esta operação não poderá ser desfeita!'),
                                                                [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () => Get
                                                                              .back(),
                                                                      child:
                                                                          const Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        AppHelper.showCustomSnackbar(
                                                                            '${_users[index]['name']} removido',
                                                                            Colors.red,
                                                                            3);
                                                                        _users.removeAt(
                                                                            index);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Confirmar',
                                                                      ))
                                                                ]);
                                                          },
                                                          icon: const Icon(
                                                              LineAwesomeIcons
                                                                  .trash)),
                                                    );
                                                  }),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton.icon(
                                                    onPressed: () =>
                                                        setState(() {
                                                          addUserToList();
                                                        }),
                                                    icon: const Icon(
                                                        LineAwesomeIcons.plus),
                                                    label:
                                                        const Text("Adicionar"))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  )),
                            if (_cftvMonitoring)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ExpansionTile(
                                    title: Column(
                                      children: const [Text("Dados de CFTV")],
                                    ),
                                    children: [
                                      ListTile(
                                          title: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrVendorController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Fabricante',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrModelController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Modelo',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller:
                                                  _dvrSerialNumberController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'SN (QR Code)',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrAddressController,
                                              minLines: 1,
                                              maxLines: 100,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'IP Fixo / DDNS',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrHttpController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Porta HTTP',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrTcpController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText:
                                                    'Porta TCP (Serviço)',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrRtspController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Porta RTSP',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrUserController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Usuário',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller:
                                                  _dvrPasswordController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Senha',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _dvrCamQttController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText:
                                                    'Qtd. Câmeras Ativas',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: TextFormField(
                                              controller: _zoneToCamController,
                                              minLines: 1,
                                              maxLines: 50,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                labelText: 'Setor / Câmera',
                                                hintText:
                                                    'Z1 / C1\nZ2 / C5\nZ3 / C2\nZ4 / C5\n...',
                                              ),
                                            ),
                                          ),
                                          SwitchListTile(
                                              title: const Text(
                                                  'Stream Extra 32Kbps?'),
                                              value: _is32kbps,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _is32kbps = value;
                                                });
                                              })
                                        ],
                                      ))
                                    ],
                                  )),
                            // SizedBox(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 50,
                            //     child: ElevatedButton(
                            //         style: ButtonStyle(
                            //             shape: MaterialStateProperty.all<
                            //                     RoundedRectangleBorder>(
                            //                 RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(10)))),
                            //         onPressed: () {},
                            //         child: const Text(
                            //           "Salvar",
                            //           style: TextStyle(fontSize: 22),
                            //         ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const MaintanceInfo()),
    );
  }

  addUserToList() {
    AppHelper.showNAlertDialog(
        context,
        const Text('Novo Usuário'),
        Form(
            key: _usersFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _userNumberController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Nº'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Nome'),
                  ),
                )
              ],
            )),
        [
          TextButton(
              onPressed: () => Get.back(),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red))),
          TextButton(
              onPressed: () {
                if (_usersFormKey.currentState!.validate()) {
                  setState(() {
                    _users.add({
                      'number': int.parse(_userNumberController.text),
                      'name': _userNameController.text
                    });
                    _userNameController.clear();
                    _userNumberController.clear();
                    Get.back();
                  });
                }
              },
              child: const Text('Adicionar')),
        ]);
  }

  addZoneToList() {
    AppHelper.showNAlertDialog(
        context,
        const Text('Novo Setor'),
        Form(
            key: _zonesFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _zoneNumberController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Nº'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _zoneNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Nome'),
                  ),
                )
              ],
            )),
        [
          TextButton(
              onPressed: () => Get.back(),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red))),
          TextButton(
              onPressed: () {
                if (_zonesFormKey.currentState!.validate()) {
                  setState(() {
                    _zones.add({
                      'number': int.parse(_zoneNumberController.text),
                      'name': _zoneNameController.text
                    });
                    _zoneNameController.clear();
                    _zoneNumberController.clear();
                    Get.back();
                  });
                }
              },
              child: const Text('Adicionar')),
        ]);
  }

  addContactToList() {
    if (_contacts.length < 5) {
      AppHelper.showNAlertDialog(
          context,
          const Text('Novo contato'),
          Form(
            key: _contactsFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _contactNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Não pode estar em branco!';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                      controller: _contactPhoneNumberController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        labelText: 'Telefone',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não pode estar em branco!';
                        }
                      }),
                ),
              ],
            ),
          ),
          [
            TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  if (_contactsFormKey.currentState!.validate()) {
                    setState(() {
                      _contacts.add({
                        'name': _contactNameController.text,
                        'phone': _contactPhoneNumberController.text
                      });
                      _contactNameController.clear();
                      _contactPhoneNumberController.clear();
                      Get.back();
                    });
                  }
                },
                child: const Text('Adicionar'))
          ]);
    } else {
      AppHelper.showCustomSnackbar(
          'Limite de contatos atingido', Colors.redAccent[700]!, 3);
    }
  }

  saveForm() {
    String _formattedClientData = ClientModel(
            clientAccount: _accountController.text,
            clientName: _clientNameController.text,
            verbalPasswordAsk: _verbalPasswordAskController.text,
            verbalPasswordAnswer: _verbalPasswordAnswerController.text,
            contacts: _contacts)
        .formatToClipboard();

    if (_alarmMonitoring) {
      _formattedAlarmPanelData = AlarmPanelModel(
              vendor: _alarmVendorController.text,
              model: _alarmModelController.text,
              mac: _alarmMacController.text,
              zones: _zones,
              users: _users,
              masterPassword: _alarmMasterPasswordController.text,
              programmingPassword: _alarmProgrammingPasswordController.text,
              remoteAccessPassword: _alarmRemoteAccessPasswordController.text)
          .formatToClipboard();
    } else {
      _formattedAlarmPanelData = '';
    }

    if (_cftvMonitoring) {
      if (_is32kbps) {
        _formattedCftvData = CftvModel(
                vendor: _dvrVendorController.text,
                model: _dvrModelController.text,
                serialNumber: _dvrSerialNumberController.text,
                address: _dvrAddressController.text,
                httpPort: int.parse(_dvrHttpController.text),
                tcpPort: int.parse(_dvrTcpController.text),
                rtspPort: int.parse(_dvrRtspController.text),
                user: _dvrUserController.text,
                password: _dvrPasswordController.text,
                activeCameras: int.parse(_dvrCamQttController.text),
                is32kbps: _is32kbps)
            .formatToClipboard();
      } else {
        AppHelper.showCustomSnackbar(
            "Necessário diminuir o Stream Extra para 32Kbps!", Colors.red, 3);
      }
    } else {
      _formattedCftvData = '';
    }

    ClosureHelper().sendData(
        _formattedClientData + _formattedAlarmPanelData + _formattedCftvData);
  }
}
