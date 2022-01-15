import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_flutter_project/model/user_response_model.dart';

class UserRespository {
  Future<List<UserResponse>> getUserList() async {
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final http.Response response = await http.get(url);
    debugPrint('method called');
    List<UserResponse> userResponseList = [];
    if (response.statusCode == 200) {
      // return UserResponseList.fromJson(json.decode(response.body));
      // print(json.decode(response.body));
      for (var item in json.decode(response.body)) {
        userResponseList.add(UserResponse.fromJson(item));
      }
      // print('userResponseList =>${userResponseList}');
      return userResponseList;
    } else {
      throw Exception("Failed to load user");
    }
  }
}
