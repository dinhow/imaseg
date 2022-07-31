import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class BudgetHelper {
  Future<void> sendData(String toSend) async {
    final link = WhatsAppUnilink(text: toSend);
    Clipboard.setData(ClipboardData(text: toSend));
    // ignore: deprecated_member_use
    await launch('$link');
  }
}






//     Clipboard.setData(ClipboardData(text: '''
// *Empresa:* $company

// *Conta:* $account
// $clientName
// ______________________________

// *Descrição do orçamento:*
// $detailedBudget

// *Enviar proposta de Chip?*
// $needChip

// *Contato no local com:*
// $localContactName

// *Email para envio do orçamento:*
// $email'''));

  // static Future<String> formatedBudgetData() async {
  //   final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
  //   return clipboardData?.text ?? '';
  // }

  // static Future<bool> hasData() async {
  //   return Clipboard.hasStrings();
  // }

//   static Future<void> sendToWhatsApp(String company, account, clientName,
//       localContactName, email, detailedBudget, needChip) async {
//     final link = WhatsAppUnilink(text: '''
// *Empresa:* $company

// *Conta:* $account
// $clientName
// ______________________________

// *Descrição do orçamento:*
// $detailedBudget

// *Enviar proposta de Chip?*
// $needChip

// *Contato no local com:*
// $localContactName

// *Email para envio do orçamento:*
// $email''');
//     // ignore: deprecated_member_use
//     await launch('$link');
//   }

