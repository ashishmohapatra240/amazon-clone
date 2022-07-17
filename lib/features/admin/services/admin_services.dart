import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dvypwlby2', 'oij7k8w0');
      List<String> imgUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imgUrls.add(res.secureUrl);

        Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imgUrls,
          category: category,
          price: price,
        );
        http.Response response = await http.post(
          Uri.parse('$uri/admin/add-product'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: product.toJson(),
        );
        httpErrorHandler(
            response: response,
            context: context,
            onSuccess: () {
              showSnackbar(context, 'Product Added Successfully');
              Navigator.pop(context);
            });
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  //get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-product'),
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

//delete product
  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
          {
            'id': product.id,
          },
        ),
      );
      print(response.body);
      httpErrorHandler(
          response: response,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
