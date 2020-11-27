//import 'package:TropsSmart/Authentication.dart';
import 'package:TS_AppsMovil/Model/Cargo.dart';
import 'package:TS_AppsMovil/Model/Driver.dart';
import 'package:TS_AppsMovil/Model/Favorite.dart';
import 'package:TS_AppsMovil/Model/Plan.dart';
import 'package:TS_AppsMovil/Model/Resource.dart';
import 'package:TS_AppsMovil/Model/SignUp.dart';
import 'package:TS_AppsMovil/Model/Subscription.dart';

import 'package:TS_AppsMovil/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiUrl = "https://ts-opensource-be.herokuapp.com/";

  Map<String, String> headers = {"Content-type": "application/json"};

  Future<void> deleteUser(int id) async {
    var res = await http.delete("$apiUrl/$id");

    if (res.statusCode == 200) {
      print("Deleted");
    }
  }

  //devolver configuracion por id de usuario
  Future getConfigurationByUserId(int id) async {
    var response = await http.get("$apiUrl" + "api/configurations/users/$id");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  //Devolver 1 solo elemento
  Future<Resource> getUser(int id) async {
    var res = await http.get("$apiUrl" + "api/users/$id");

    if (res.statusCode == 200) {
      print(res.body);
      return Resource.fromJson(json.decode(res.body));
    } else {
      throw 'cant get users';
    }
  }

  //Login
  Future signIn(String email, String password) async {
    Map obj = {
      'email': email,
      'password': password,
    };
    var body = json.encode(obj);

    final response = await http.post("$apiUrl" + "api/authentication/sign-in",
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      String responseBody = response.body;

      debugPrint("responseBody : " + responseBody);

      debugPrint("statusCODEEEEEEEEEE : " + response.statusCode.toString());

      return json.decode(response.body);
    }
  }

  //Devolver usuarios de tipo driver
  Future<List<User>> getDrivers() async {
    try {
      final response =
          await http.get("$apiUrl" + "api/users/type/2", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getDrivers : " + responseBody);
        Map<String, dynamic> decoded = json.decode(responseBody);
        List<User> driverList = List<User>.from(
            decoded['resourceList'].map((x) => User.fromJson(x)));
        return driverList;
      }
      return null;
    } catch (e) {
      return List<User>();
    }
  }

  //Devolver usuarios de tipo customer
  Future<List<User>> getCustomers() async {
    try {
      final response =
          await http.get("$apiUrl" + "api/users/type/1", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        Map<String, dynamic> decoded = json.decode(responseBody);
        List<User> customerList = List<User>.from(
            decoded['resourceList'].map((x) => User.fromJson(x)));
        return customerList;
      }
      return null;
    } catch (e) {
      return List<User>();
    }
  }

  //Obtener todos los cargos
  Future<List<Cargo>> getCargoes() async {
    try {
      final response =
          await http.get("$apiUrl" + "api/cargoes", headers: this.headers);
      if (response.statusCode == 200) {
        debugPrint("Status code 200");
        String responseBody = response.body;
        debugPrint("getCargoes : " + responseBody);
        //Map<String, dynamic> decoded = json.decode(responseBody.trim());
        //List<Cargo> cargoList = List<Cargo>.from(
        //    decoded['resourceList'].map((x) => Cargo.fromJson(x)));
        Map<String, dynamic> decoded = json.decode(responseBody);
        debugPrint(responseBody);
        List<Cargo> cargoList = List<Cargo>.from(
            decoded['resourceList'].map((x) => Cargo.fromJson(x)));
        return cargoList;
      }
      return null;
    } catch (e) {
      return List<Cargo>();
    }
  }

  //Obtener todos los favoritos
  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await http.get("$apiUrl" + "api/users/favorites",
          headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getDrivers : " + responseBody);
        Map<String, dynamic> decoded = json.decode(responseBody.trim());
        List<Favorite> favoriteList = List<Favorite>.from(
            decoded['resourceList'].map((x) => Favorite.fromJson(x)));
        return favoriteList;
      }
      return null;
    } catch (e) {
      return List<Favorite>();
    }
  }

  //Registrar nuevo usuario
  Future signUp(Signup signup) async {
    var body = json.encode(signup);

    final response = await http.post("$apiUrl" + "api/authentication/sign-up",
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      String responseBody = response.body;
      debugPrint("responseBody : " + responseBody);
      debugPrint("statusCODEEEEEEEEEE : " + response.statusCode.toString());
      return json.decode(response.body);
    }
  }

  Future<List<Driver>> getDriversfixed() async {
    try {
      final response =
          await http.get("$apiUrl" + "api/drivers", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getDrivers : " + responseBody);
        Map<String, dynamic> decoded = json.decode(responseBody.trim());
        List<Driver> driverList = List<Driver>.from(
            decoded['resourceList'].map((x) => Driver.fromJson(x)));

        return driverList;
      }
      return null;
    } catch (e) {
      return List<Driver>();
    }
  }

  Future<List<Resource>> getUsers() async {
    final res = await http.get(apiUrl + "api/users");

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Resource> users =
          body.map((dynamic item) => Resource.fromJson(item)).toList();

      return users;
    } else {
      throw 'cant get post.';
    }
  }

  Future<List<Cargo>> getCargoesById() async {
    int idS = 1;
    try {
      final response =
      await http.get("$apiUrl" + "api/cargoes/customers/" + "$idS", headers: this.headers);
      if (response.statusCode == 200) {
        debugPrint("Status code 200");
        String responseBody = response.body;
        debugPrint("getCargoes : " + responseBody);
        //Map<String, dynamic> decoded = json.decode(responseBody.trim());
        //List<Cargo> cargoList = List<Cargo>.from(
        //    decoded['resourceList'].map((x) => Cargo.fromJson(x)));
        Map<String, dynamic> decoded = json.decode(responseBody);
        debugPrint(responseBody);
        List<Cargo> cargoList = List<Cargo>.from(
            decoded['resourceList'].map((x) => Cargo.fromJson(x)));
        return cargoList;
      }
      return null;
    } catch (e) {
      return List<Cargo>();
    }
  }


  Future<List<Plan>> getPlans() async {
    try {
      final response =
      await http.get("$apiUrl" + "api/plans", headers: this.headers);
      if (response.statusCode == 200) {
        debugPrint("Status code 200");
        String responseBody = response.body;
        debugPrint("getPlans : " + responseBody);

        Map<String, dynamic> decoded = json.decode(responseBody);
        debugPrint(responseBody);
        List<Plan> cargoList = List<Plan>.from(
            decoded['resourceList'].map((x) => Plan.fromJson(x)));
        return cargoList;
      }
      return null;
    } catch (e) {
      return List<Plan>();
    }
  }


  Future<Subscription> deleteSub(int id) async {
    final http.Response response = await http.delete(
        apiUrl + "api/subscriptions/" + "$id",
        headers: this.headers
    );

    if (response.statusCode == 200) {
      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete');
    }
  }


  Future<List<Favorite>> postFavorites(String user, String favourited, DateTime since) async {
    final res = await http.post(apiUrl + "api/users/1/favorites/2");

    final response = await http.post(res, body: {
      "user": "user",
      "favourited": "favourited",
      "since": "since"
    });

    if(response.statusCode == 200){
      debugPrint("statusCODE : " + response.statusCode.toString());
      return json.decode(response.body);
    }else{
      return null;
    }
  }



  Future<Subscription> createSubscription(int id, int id2) async {
    id = 4;
    final http.Response response = await http.post(
      apiUrl + "api/subscriptions/users/" + "$id" + "/plans/" + "$id2",
      headers: this.headers,

      body: jsonEncode(<String, String>{

      }),
    );

    debugPrint(apiUrl + "api/subscriptions/users/" + "$id" + "/plans/" + "$id2");
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create');
    }
  }

  Future<Subscription> putSubDisable(int id) async {
    final http.Response response = await http.put(
      apiUrl + "api/subscriptions/" + "$id" + "/disable",
      headers: this.headers,

    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update Subscription.');
    }
  }


  Future<Subscription> putSubEnable(int id) async {

    final http.Response response = await http.put(
      apiUrl + "api/subscriptions/" + "$id" + "/enable",
      headers: this.headers,

      // body: jsonEncode(<String, String>{
      //   'state' : state
      // }),
    );

    debugPrint(apiUrl + "api/subscriptions/" + "$id" + "/enable");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      //return Subscription.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update Subscription.');
    }
  }

  Future<List<Subscription>> getSubsById() async {
    int idS = 4;
    try {
      final response =
      await http.get("$apiUrl" + "api/subscriptions/users/" + "$idS", headers: this.headers);
      if (response.statusCode == 200) {
        debugPrint("Status code 200");
        String responseBody = response.body;
        debugPrint("getSubs : " + responseBody);
        //Map<String, dynamic> decoded = json.decode(responseBody.trim());
        //List<Cargo> cargoList = List<Cargo>.from(
        //    decoded['resourceList'].map((x) => Cargo.fromJson(x)));
        Map<String, dynamic> decoded = json.decode(responseBody);
        debugPrint(responseBody);
        List<Subscription> subList = List<Subscription>.from(
            decoded['resourceList'].map((x) => Subscription.fromJson(x)));
        return subList;
      }
      return null;
    } catch (e) {
      return List<Subscription>();
    }
  }

  //Future<Subscription> fetchSub(String id) async {
  //  final response =
  //  await http.get(apiUrl + "/api/subscriptions/" + "$id");
//
  //  if (response.statusCode == 200) {
  //    // If the server did return a 200 OK response,
  //    // then parse the JSON.
  //    return Subscription.fromJson(jsonDecode(response.body));
  //  } else {
  //    // If the server did not return a 200 OK response,
  //    // then throw an exception.
  //    throw Exception('Failed to load Subscription');
  //  }
  //}


  }





