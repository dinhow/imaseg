// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/chip_model.dart';

class Functions {
//Gera print apenas se aplicação estiver rodando em modo Debug
  static printOnDebugMode(toPrint) {
    if (kDebugMode) {
      print(toPrint);
    }
  }

//Mostra snackbar destinada a informações gerais
  static showInfoSnackbar(String title, String message, BuildContext context) {
    Get.snackbar(title, message,
        backgroundColor: Colors.blue,
        maxWidth: MediaQuery.of(context).size.width * .5,
        icon: const Icon(FontAwesomeIcons.circleInfo),
        margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
  }

//Mostra snackbar destinada a erros
  static showErrorSnackbar(String title, String message, BuildContext context) {
    Get.snackbar(title, message,
        backgroundColor: Colors.red,
        maxWidth: MediaQuery.of(context).size.width * .5,
        duration: const Duration(seconds: 5),
        icon: const Icon(FontAwesomeIcons.circleXmark),
        margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
  }

//Mostra snackbar destinada a operações concluídas corretamente
  static showSuccessSnackbar(
      String title, String message, BuildContext context) {
    Get.snackbar(title, message,
        backgroundColor: Colors.green,
        maxWidth: MediaQuery.of(context).size.width * .5,
        duration: const Duration(seconds: 5),
        icon: const Icon(FontAwesomeIcons.circleCheck),
        margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
  }

//Mostra snackbar destinada a alertas
  static showAlertSnackbar(String title, String message, BuildContext context) {
    Get.snackbar(title, message,
        backgroundColor: Colors.amber,
        maxWidth: MediaQuery.of(context).size.width * .5,
        duration: const Duration(seconds: 5),
        icon: const Icon(FontAwesomeIcons.circleExclamation),
        margin: const EdgeInsets.only(top: 8, left: 8, right: 8));
  }

//Busca lista de Chips no banco de dados
  static Future<void> getChip(String token, BuildContext context,
      StreamController<List<ChipModel>> streamController) async {
    try {
      List<ChipModel> listChip = [];
      String uri = 'http://localhost:8000/chips/';
      final response = await http
          .get(Uri.parse(uri), headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var decodeJson = jsonDecode(response.body);
        decodeJson.forEach((item) {
          if (item['chip_status'] != 99) {
            listChip.add(ChipModel.fromJson(item));
          }
        });
        streamController.sink.add(listChip);
      } else if (response.statusCode == 401 &&
          response.body.contains("foram fornecidas.")) {
        Functions.showErrorSnackbar("ERRO",
            "As credenciais de autenticação não foram fornecidas.", context);
      } else {
        if (kDebugMode) {
          if (response.statusCode == 401) {
            Functions.showInfoSnackbar(
                "Login Expirou", "Faça login novamente", context);
          }
        }
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  //Adiciona novo chip ao banco de dados
  static Future<void> addNewChip(
      ChipModel chip, String token, BuildContext context) async {
    try {
      var url = Uri.parse('http://localhost:8000/chips/');
      var body = json.encode({
        "chip_iccid": chip.chipIccid,
        "chip_company": chip.chipCompany,
        "chip_apn": chip.chipApn,
        "chip_with": "Base",
      });
      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 201) {
        Get.back();
        Functions.showSuccessSnackbar(
            chip.chipIccid!, "Chip cadastrado com sucesso!", context);
      } else if (response.statusCode == 400 &&
          response.body.contains('existe')) {
        Functions.showErrorSnackbar("Atenção",
            "Chip de ICCID ${chip.chipIccid} já cadastrado", context);
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  //Muda chip_status
  static Future<void> changeChipStatus(
      ChipModel chip, String token, BuildContext context) async {
    try {
      printOnDebugMode(chip.chipId);
      var body = '';
      if (chip.chipStatus == 0) {
        body = json.encode({
          "chip_status": chip.chipStatus,
          "canceled_by": chip.cancelledBy,
          "canceled_at": DateTime.now().toString(),
          "linked_in": '',
          "chip_with": ''
        });
      } else if (chip.chipStatus == 1) {
        body = json.encode({
          "chip_status": chip.chipStatus,
        });
      }
      var url = Uri.parse('http://localhost:8000/chips/${chip.chipId}/');

      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Get.back();
        Functions.showSuccessSnackbar(
            "OK", "Status alterado com sucesso!", context);
      } else {
        Functions.printOnDebugMode(response.body.toString());
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  //Edita informações do Chip
  static Future<void> editChip(
      ChipModel chip, String token, BuildContext context) async {
    try {
      var url = Uri.parse('http://localhost:8000/chips/${chip.chipId}/');
      var body = json.encode({
        "chip_iccid": chip.chipIccid,
        "chip_company": chip.chipCompany,
        "chip_apn": chip.chipApn,
        "chip_with_at": DateTime.now().toString(),
        "chip_with": chip.chipWith,
      });
      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Get.back();
        Functions.showSuccessSnackbar(
            chip.chipIccid!, "Chip editado com sucesso!", context);
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  static Future<void> removeChip(
      ChipModel chip, String token, BuildContext context) async {
    try {
      var url = Uri.parse('http://localhost:8000/chips/${chip.chipId}/');
      var body = json.encode({
        "chip_status": 99,
        "cancelled_by": chip.cancelledBy,
        "cancelled_at": DateTime.now().toString(),
      });
      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Functions.showSuccessSnackbar(
            chip.chipIccid!, "Chip removido com sucesso!", context);
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  //Vincula chip com Cliente
  static Future<void> linkClientWithChip(
      ChipModel chip, String token, BuildContext context) async {
    try {
      var url = Uri.parse('http://localhost:8000/chips/${chip.chipId}/');
      var body = json.encode({
        "linked_at": DateTime.now().toString(),
        "chip_status": 2,
        "linked_by": chip.linkedBy,
        "linked_in": chip.linkedIn,
        "chip_with": chip.linkedIn,
      });
      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Functions.showSuccessSnackbar(
            chip.chipIccid!, "Chip vinculado com sucesso!", context);
      } else if (response.statusCode == 400) {
        Functions.printOnDebugMode(response.body);
      }
    } catch (e) {
      Functions.printOnDebugMode(e.toString());
    }
  }

  //Remove chip do banco de dados
  static Future<void> removeChipFromDB(
      ChipModel chip, String token, BuildContext context) async {
    try {
      var url = Uri.parse(
        'http://localhost:8000/chips/${chip.chipId}/',
      );
      final response =
          await http.delete(url, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 204) {
        Get.back();
        Get.back();
        Functions.showSuccessSnackbar(
            chip.chipIccid!, "Chip removido com sucesso.", context);
      }
    } catch (e) {
      Functions.showErrorSnackbar("ERRO", e.toString(), context);
    }
  }
}
