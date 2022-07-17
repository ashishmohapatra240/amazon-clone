import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/utils.dart';
import '../../../provider/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: () {
            for (var data in jsonDecode(res.body)) {
              productList.add(
                Product.fromJson(
                  jsonEncode(
                    data,
                  ),
                ),
              );
            }
          });
    } catch (e) {
      // print(e.toString());
      showSnackbar(context, e.toString());
    }
    return productList;
  }
}
