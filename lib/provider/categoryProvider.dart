import 'package:admin_app/custom_http/custom_http_request.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];
  getCategoryData(bool isLoading) async {
    isLoading = true;
    categoryList = await CustomeHttpRequest.getCategory();
    isLoading = false;
    notifyListeners();
  }
}
