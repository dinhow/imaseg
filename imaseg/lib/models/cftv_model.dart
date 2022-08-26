class CftvModel {
  int? id;
  String? vendor;
  String? user;
  String? password;
  String? model;
  String? serialNumber;
  String? address;
  int? httpPort;
  int? rtspPort;
  int? tcpPort;
  int? activeCameras;
  List<String>? zonePerCamera;
  bool? is32kbps;

  CftvModel(
      {this.id,
      this.vendor,
      this.user,
      this.password,
      this.model,
      this.serialNumber,
      this.address,
      this.httpPort,
      this.rtspPort,
      this.tcpPort,
      this.activeCameras,
      this.zonePerCamera,
      this.is32kbps});

  CftvModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    user = json['user'];
    password = json['password'];
    model = json['model'];
    serialNumber = json['serialNumber'];
    address = json['address'];
    httpPort = json['httpPort'];
    rtspPort = json['rtspPort'];
    tcpPort = json['tcpPort'];
    activeCameras = json['activeCameras'];
    zonePerCamera = json['zonePerCamera'].cast<String>();
    is32kbps = json['is32kbps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor'] = vendor;
    data['user'] = user;
    data['password'] = password;
    data['model'] = model;
    data['serialNumber'] = serialNumber;
    data['address'] = address;
    data['httpPort'] = httpPort;
    data['rtspPort'] = rtspPort;
    data['tcpPort'] = tcpPort;
    data['activeCameras'] = activeCameras;
    data['zonePerCamera'] = zonePerCamera;
    data['is32kbps'] = is32kbps;
    return data;
  }

  String formatToClipboard() {
    String extraStream = '';
    if (is32kbps!) {
      extraStream = 'Sim';
    } else {
      extraStream = 'Não';
    }
    final formattedData = '''
_______________________________

*Informações do CFTV*

*Fabricante do DVR:* $vendor
*Modelo do DVR:* $model
*SN (Serial Number):* $serialNumber
*IP Fixo / DDNS:* $address
*Porta HTTP:* $httpPort
*Porta TCP (Serviço):* $tcpPort
*Porta RTSP:* $rtspPort
*Quantidade de câmeras ativas:* $activeCameras
*Configurado Stream Extra 32Kbps?*: $extraStream

*Usuário:* $user
*Senha:* $password

''';
    return formattedData;
  }
}
