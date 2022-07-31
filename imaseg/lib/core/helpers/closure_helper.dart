import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ClosureHelper {
  Future<void> sendData(String toSend) async {
    final link = WhatsAppUnilink(text: toSend);
    if (!kIsWeb) {
      Clipboard.setData(ClipboardData(text: toSend));
    }
    // ignore: deprecated_member_use
    await launch('$link');
  }

//   static Future<void> sendData(
//       String account,
//       String clientName,
//       String verbalPasswordAsk,
//       String verbalPasswordAnswer,
//       String panelVendor,
//       String panelModel,
//       String panelMac,
//       String panelZones,
//       String panelUsers,
//       String panelMasterPassword,
//       String panelProgrammingPassword,
//       String panelRemoteAccessPassword,
//       String dvrVendor,
//       String dvrModel,
//       String dvrSerialNumber,
//       String dvrAddress,
//       String dvrHttpPort,
//       String dvrTcpPort,
//       String dvrRtspPort,
//       String dvrUser,
//       String dvrPassword,
//       String dvrCamQtt,
//       String is32kbps,
//       String comments,
//       bool haveAlarmPanel,
//       bool haveCftv,
//       bool wasPhotosTaken,
//       bool wasLinked) async {
// //Define a formatação das informações de tipo de entrada

// //Dados do cliente
//     final String clientData = '''
// *Conta:* $account
// *Cliente:* $clientName,
// ________________________________

// *Senha verbal*

// *Pergunta:* $verbalPasswordAsk
// *Resposta:* $verbalPasswordAnswer
// ________________________________

// *Contatos*

// *Contato 1:*
// *Contato 2:*
// *Contato 3:*
// *Contato 4:*
// *Contato 5:*

// ''';

// //Dados do alarme
//     final String alarmPanelData = '''
// ________________________________

// *Informações da Central*

// *Fabricante da central:* $panelVendor
// *Modelo da central:* $panelModel
// *MAC:* $panelMac
// *Senha master:* $panelMasterPassword
// *Senha de programação:* $panelProgrammingPassword
// *Senha de acesso remoto:* $panelRemoteAccessPassword

// *Setorização*

// $panelZones

// ''';

// //Dados do CFTV
//     final String cftvData = '''
// _______________________________

// *Informações do CFTV*

// *Fabricante do DVR:* $dvrVendor
// *Modelo do DVR:* $dvrModel
// *SN (Serial Number):* $dvrSerialNumber
// *IP Fixo / DDNS:* $dvrAddress
// *Porta HTTP:* $dvrHttpPort
// *Porta TCP (Serviço):* $dvrTcpPort
// *Porta RTSP:* $dvrRtspPort
// *Quantidade de câmeras ativas:* $dvrCamQtt
// *Configurado Stream Extra 32Kbps?*: $is32kbps

// *Usuário:* $dvrUser
// *Senha:* $dvrPassword

// ''';

//     final link = WhatsAppUnilink(
//         text: clientData +
//             (haveAlarmPanel ? alarmPanelData : '') +
//             (haveCftv ? cftvData : '') +
//             (comments.isEmpty ? comments : ''));

//     Clipboard.setData(ClipboardData(
//         text: clientData +
//             (haveAlarmPanel ? alarmPanelData : '') +
//             (haveCftv ? cftvData : '') +
//             (comments.isEmpty ? '' : comments)));

//     // ignore: deprecated_member_use
//     await launch('$link');
//   }
}
