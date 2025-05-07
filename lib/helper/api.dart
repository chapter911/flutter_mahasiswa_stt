import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as g;

class Api {
  var id, quote, author;

  Api({this.id, this.quote, this.author});

  factory Api.result(dynamic object) {
    return Api(
      id: object['id'],
      quote: object['quote'],
      author: object['author'],
    );
  }

  static Future<Api?> getData(BuildContext context) async {
    String apiUrl = "https://dummyjson.com/quotes/random";

    EasyLoading.show(status: 'Mohon Tunggu');

    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json;charset=utf-8",
    );

    Dio dio = Dio(options);

    try {
      Response response = await dio.get(apiUrl);

      Api? apiResponse;

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        apiResponse = Api.result(listData);
        EasyLoading.dismiss();
        return apiResponse;
      } else {
        g.Get.snackbar(
          "Gagal",
          "Gagal Mengambil Data",
          backgroundColor: Colors.red[800],
          colorText: Colors.white,
        );
      }
      EasyLoading.dismiss();
      return null;
    } catch (e) {
      print(e);
      g.Get.snackbar(
        "Gagal",
        "Gagal Mengambil Data",
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
      );
      EasyLoading.dismiss();
      return null;
    }
  }
}
