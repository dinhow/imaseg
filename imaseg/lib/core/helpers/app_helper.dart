// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';

class AppHelper {
  AppHelper._();

  static showNAlertDialog(
      context, Widget title, Widget content, List<Widget>? actions) async {
    return await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Center(child: title),
      content: content,
      actions: actions,
    ).show(context);
  }

  static showCustomSnackbar(String message, Color color, int duration) {
    Get.snackbar('', '',
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.only(left: 15, right: 15),
        shouldIconPulse: true,
        overlayBlur: 2,
        colorText: Colors.white,
        backgroundColor: color,
        messageText: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Center(
              child:
                  Text(message, style: const TextStyle(color: Colors.white))),
        ),
        duration: Duration(seconds: duration),
        snackPosition: SnackPosition.BOTTOM);
  }

  static String showZonesList(List<Map<String, dynamic>> zones) {
    String data = '';
    zones.forEach((element) {
      data += '${element['number']} - ${element['name']}\n';
    });
    return data;
  }

  static String showNeedChipText(bool needChip) {
    String data = '';
    if (needChip) {
      data = '''*Enviar proposta de Chip?*
Sim''';
    }
    return data;
  }

  static String showContactsList(List<Map<String, dynamic>> contacts) {
    String data = '';
    contacts.forEach((element) {
      data += '${element['name']} - ${element['phone']}\n';
    });
    return data;
  }

  static String showUsersList(List<Map<String, dynamic>> users) {
    String data = '';
    users.forEach((element) {
      data += '${element['number']} - ${element['name']}\n';
    });
    return data;
  }
}
