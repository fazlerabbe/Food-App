import 'dart:convert';

import 'package:admin_app/widget/custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/category_model.dart';

class CustomeHttpRequest {
  static Future<Map<String, String>> getHeaderWithToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer ${sharedPreferences.getString("token")}"
    };
    return header;
  }

  static Future<dynamic> getCategory() async {
    CategoryModel? categoryModel;

    List<CategoryModel> categoryList = [];
    try {
      var url = "${baseUrl}category";
      // var responce = await http.get(Uri.parse(url));

      var responce = await http.get(Uri.parse(url),
          headers: await CustomeHttpRequest.getHeaderWithToken());

      print("mmmmmm${responce.body}");
      if (responce.statusCode == 200) {
        var data = jsonDecode(responce.body);
        print("data is ${data}");
        for (var i in data) {
          categoryModel = CategoryModel.fromJson(i);

          categoryList.add(categoryModel);
        }
      }
      print('statas code is ${responce.statusCode}');
    } catch (e) {
      print("some think is wrong $e");
    }
    return categoryList;
  }

  static Future<bool> deleteCategoryData({int? id}) async {
    var uri = "${baseUrl}category/${id}/delete";
    var responce =
        await http.delete(Uri.parse(uri), headers: await getHeaderWithToken());
    final data = jsonDecode(responce.body);
    print("responce data$data");
    if (responce.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
