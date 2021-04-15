import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _autenticando = false;


  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando ( bool valor ) {
    this.autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  // Getters del token de forma estática
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login( String email, String password ) async {

    //this.autenticando = true;
    this._autenticando = true;
    notifyListeners();
    
    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post(Uri.parse("${ Environment.apiURL }/login"),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    this._autenticando = false;
    notifyListeners();

    if (resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar Token en lugar seguro
      await this._guardarToken(loginResponse.token);

      return true;

    } else {
      return false;
    }
  }

  Future register( String nombre, String email, String password ) async {

    //this.autenticando = true;
    this._autenticando = true;
    notifyListeners();
    
    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final resp = await http.post(Uri.parse("${ Environment.apiURL }/login/new"),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    this._autenticando = false;
    notifyListeners();

    if (resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar Token en lugar seguro
      await this._guardarToken(loginResponse.token);

      return true;

    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future <bool> isLoggedIn() async {

    final token = await this._storage.read(key: 'token');

    final resp = await http.get(Uri.parse("${ Environment.apiURL }/login/renew"),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      }
    );


    if (resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      this.usuario = loginResponse.usuario;

      // Guardar Token en lugar seguro
      await this._guardarToken(loginResponse.token);

      return true;

    } else {
      this.logout();
      return false; 
    }
    

  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }



}