import 'package:risetech_smart_os/core/helpers/app_helper.dart';

class ClientModel {
  int? id;
  String? clientAccount;
  String? clientName;
  List<Map<String, dynamic>>? contacts;
  List<String>? contactPhone;
  String? email;
  String? verbalPasswordAsk;
  String? verbalPasswordAnswer;
  String? comments;
  bool? alarmMonitoring;
  bool? cftvMonitoring;

  ClientModel(
      {this.id,
      this.clientAccount,
      this.clientName,
      this.contacts,
      this.email,
      this.verbalPasswordAsk,
      this.verbalPasswordAnswer,
      this.comments,
      this.alarmMonitoring,
      this.cftvMonitoring});

  ClientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientAccount = json['clientAccount'];
    clientName = json['clientName'];
    contacts = json['contacts'].cast<Map<String, dynamic>>();
    email = json['email'];
    verbalPasswordAsk = json['verbalPasswordAsk'];
    verbalPasswordAnswer = json['verbalPasswordAnswer'];
    comments = json['comments'];
    alarmMonitoring = json['alarmMonitoring'];
    cftvMonitoring = json['cftvMonitoring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientAccount'] = clientAccount;
    data['clientName'] = clientName;
    data['contacts'] = contacts;
    data['email'] = email;
    data['verbalPasswordAsk'] = verbalPasswordAsk;
    data['verbalPasswordAnswer'] = verbalPasswordAnswer;
    data['comments'] = comments;
    data['alarmMonitoring'] = alarmMonitoring;
    data['cftvMonitoring'] = cftvMonitoring;
    return data;
  }

  String formatToClipboard() {
    final String formattedData = '''
*Conta:* $clientAccount
*Cliente:* $clientName
________________________________

*Senha verbal*

*Pergunta:* $verbalPasswordAsk
*Resposta:* $verbalPasswordAnswer
________________________________

*Contatos*

${AppHelper.showContactsList(contacts!)}
''';
    return formattedData;
  }
}
