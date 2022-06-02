import 'dart:convert';

import 'package:escore/api/api.dart';
import 'package:escore/helper/session.dart';
import 'package:escore/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestApi {

  BuildContext context;

  RestApi(this.context);

  updateToken({onResponse, onError}) async {
    await _makeGetRequest('${Api.host}/private/updatetoken', onResponse, onError);
  }

  login(params, {onResponse, onError}) async {
    await _makePostRequest('${Api.host}/auth/login', params, onResponse, onError);
  }

  register(params, {onResponse, onError}) async {
    await _makePostRequest('${Api.host}/auth/register', params, onResponse, onError);
  }

  logout({onResponse, onError}) async {
    await _makeGetRequest('${Api.host}/private/logout', onResponse, onError);
  }

  verifyEmail(params, {onResponse, onError}) async {
    await _makePostRequest('${Api.host}/auth/verifyemail', params, onResponse, onError);
  }

  posts({onResponse, onError}) async {
    await _makeGetRequest('${Api.host}/private/post/all', onResponse, onError);
  }

  createPost(value, params, {onResponse, onError}) async {
    await _makeMultipartRequest('${Api.host}/private/post/create', value, params, onResponse, onError);
  }

  _makePostRequest(url, params, onResponse, onError) async {
    var res = await http.post(
      Uri.parse(url),
      headers: await Session().cookie(),
      body: json.encode(params),
    ).catchError((err) {
      onError(err.toString());
    });
    await Session().setCookie(res);
    if(res.statusCode == 200){
      try{
        var data = json.decode(res.body);
        onResponse(data);
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    } else if(res.statusCode == 401) {
      _redirectLogin();
    } else {
      try{
        var data = json.decode(res.body);
        onError('${data['message']}');
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    }
  }

  _makeGetRequest(url, onResponse, onError) async {
    var res = await http.get(
      Uri.parse(url),
      headers: await Session().cookie(),
    ).catchError((err) {
      onError(err.toString());
    });
    await Session().setCookie(res);
    if(res.statusCode == 200){
      try{
        var data = json.decode(res.body);
        onResponse(data);
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    } else if(res.statusCode == 401) {
      _redirectLogin();
    } else {
      try{
        var data = json.decode(res.body);
        onError('${data['message']}');
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    }
  }

  _makeMultipartRequest(url, List<http.MultipartFile> files, params, onResponse, onError) async {
    var res = http.MultipartRequest(
        'POST',
        Uri.parse(url)
    );
    res.files.addAll(files);
    res.headers.addAll(await Session().cookie());
    if(params != null) res.fields.addAll(params);
    var req = await res.send();
    if(req.statusCode == 200){
      onResponse();
    } else if(req.statusCode == 401) {
      _redirectLogin();
    } else {
      onError('Error ${req.statusCode}');
    }
  }

  _redirectLogin(){
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()
    ));
  }

}