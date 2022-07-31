import '../core/helpers/app_helper.dart';

class BudgetModel {
  int? id;
  String? company;
  String? clientAccount;
  String? clientName;
  String? localContactName;
  String? email;
  String? detailedBudget;
  bool? needChip;

  BudgetModel(
      {this.id,
      this.company,
      this.clientAccount,
      this.clientName,
      this.localContactName,
      this.email,
      this.detailedBudget,
      this.needChip});

  BudgetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    clientAccount = json['clientAccount'];
    clientName = json['clientName'];
    localContactName = json['localContactName'];
    email = json['email'];
    detailedBudget = json['detailedBudget'];
    needChip = json['needChip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company'] = company;
    data['clientAccount'] = clientAccount;
    data['clientName'] = clientName;
    data['localContactName'] = localContactName;
    data['email'] = email;
    data['detailedBudget'] = detailedBudget;
    data['needChip'] = needChip;
    return data;
  }

  String formatToClipboard() {
    final String formattedData = '''
*Empresa:* $company

*Conta:* $clientAccount
$clientName 
______________________________

*Descrição do orçamento:*
$detailedBudget

*Contato no local com:*
$localContactName

*Email para envio do orçamento:*
$email

${AppHelper.showNeedChipText(needChip!)}''';

    return formattedData;
  }
}
