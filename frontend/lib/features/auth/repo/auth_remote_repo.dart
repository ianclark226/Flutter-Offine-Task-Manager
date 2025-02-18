import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepo {
  Future<UserModel> signUp( {
    required String name,
    required String email,
    required String password,

  }) async {
    try {
      final res = await http.post(Uri.parse('${Constants.backendUri}/auth/signup',
      ),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password
      }),
      );

      if(res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);

    } catch (error) {
      throw error.toString();
    }
  }

  Future<UserModel> login( {
    required String email,
    required String password,

  }) async {
    try {
      final res = await http.post(Uri.parse('${Constants.backendUri}/auth/login',
      ),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'password': password
      }),
      );

      if(res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);

    } catch (error) {
      throw error.toString();
    }
  }
}