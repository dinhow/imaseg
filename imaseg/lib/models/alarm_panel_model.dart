import 'package:risetech_smart_os/core/helpers/app_helper.dart';

class AlarmPanelModel {
  int? id;
  String? vendor;
  String? remoteAccessPassword;
  String? programmingPassword;
  String? model;
  String? mac;
  String? masterPassword;
  List<Map<String, dynamic>>? users;
  List<Map<String, dynamic>>? zones;
  String? formattedZones;

  AlarmPanelModel(
      {this.id,
      this.vendor,
      this.remoteAccessPassword,
      this.programmingPassword,
      this.model,
      this.mac,
      this.masterPassword,
      this.users,
      this.zones});

  AlarmPanelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    remoteAccessPassword = json['remoteAccessPassword'];
    programmingPassword = json['programmingPassword'];
    model = json['model'];
    mac = json['mac'];
    masterPassword = json['masterPassword'];
    users = json['users'].cast<Map<String, dynamic>>();
    zones = json['zones'].cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor'] = vendor;
    data['remoteAccessPassword'] = remoteAccessPassword;
    data['programmingPassword'] = programmingPassword;
    data['model'] = model;
    data['mac'] = mac;
    data['masterPassword'] = masterPassword;
    data['users'] = users;
    data['zones'] = zones;
    return data;
  }

  String formatToClipboard() {
    final formattedData = '''
________________________________

*Informações da Central*

*Fabricante da central:* $vendor
*Modelo da central:* $model
*MAC:* $mac
*Senha master:* $masterPassword
*Senha de programação:* $programmingPassword
*Senha de acesso remoto:* $remoteAccessPassword

*Setorização*

${AppHelper.showZonesList(zones!)}
*Usuários*

${AppHelper.showUsersList(users!)}
''';
    return formattedData;
  }
}
