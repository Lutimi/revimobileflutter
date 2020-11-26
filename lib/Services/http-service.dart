
import 'package:TS_AppsMovil/Model/Category.dart';
import 'package:TS_AppsMovil/Model/Company.dart';
import 'package:TS_AppsMovil/Model/Driver.dart';


import 'package:TS_AppsMovil/Model/Resource.dart';
import 'package:TS_AppsMovil/Model/SignUp.dart';

import 'package:TS_AppsMovil/Model/Vehicle.dart';


import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class HttpService {
  final String apiUrl = "https://revifastapi2020isw.azurewebsites.net/";
  final String n = "https://ts-opensource-be.herokuapp.com/";

  Map<String, String> headers = {"Content-type": "application/json"};

  Future<void> deleteUser(int id) async {
    var res = await http.delete("$apiUrl/$id");

    if (res.statusCode == 200) {
      print("Deleted");
    }
  }


  Future getConfigurationByUserId(int id) async {
    var response = await http.get("$n" + "api/configurations/users/$id");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }


  Future<Resource> getUser(int id) async {
    var res = await http.get("$n" + "api/users/$id");

    if (res.statusCode == 200) {
      print(res.body);
      return Resource.fromJson(json.decode(res.body));
    } else {
      throw 'cant get users';
    }
  }

  Future signIn(String email, String password) async {
    Map obj = {
      'email': email,
      'password': password,
    };
    var body = json.encode(obj);

    final response = await http.post("$n" + "api/authentication/sign-in",
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      String responseBody = response.body;

      debugPrint("responseBody : " + responseBody);
      return json.decode(response.body);
    }
  }


  Future<List<Driver>> getDrivers() async {
    try {
      final response =
          await http.get("$apiUrl" + "api/Conductores/List", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getDrivers : " + responseBody);
        final List<Driver> drivers = DriverFromJson(response.body);

        return drivers;
      }
      return null;
    } catch (e) {


      return List<Driver>();
    }
  }



  Future<List<Category>> getCategories() async { //Cargo
    try {
      final response =
      await http.get("$apiUrl" + "api/Categorias/List", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getCategories : " + responseBody);
        final List<Category> categories = categoryFromJson(response.body);

        return categories;
      }
      return null;
    } catch (e) {


      return List<Category>();
    }
  }


  Future<List<Company>> getCompanies() async { //Fav
    try {
      final response =
      await http.get("$apiUrl" + "api/Empresas/List", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getCompanies : " + responseBody);
        final List<Company> companies = companyFromJson(response.body);

        return companies;
      }
      return null;
    } catch (e) {


      return List<Company>();
    }
  }


  Future signUp(Signup signup) async {
    var body = json.encode(signup);

    final response = await http.post("$n" + "api/authentication/sign-up",
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      String responseBody = response.body;
      debugPrint("responseBody : " + responseBody);
      debugPrint(response.statusCode.toString());
      return json.decode(response.body);
    }
  }



  Future<List<Resource>> getUsers() async {
    final res = await http.get(n + "api/users");

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Resource> users =
          body.map((dynamic item) => Resource.fromJson(item)).toList();

      return users;
    } else {
      throw 'cant get post.';
    }
  }




  Future<Vehicle> deleteVehicle(String id) async {
    final http.Response response = await http.delete(
        apiUrl + "api/Vehiculoes/Delete/" + "$id",
        headers: this.headers
    );
    debugPrint("responseBody : " + response.body);

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete');
    }
  }




  Future<Vehicle> createVehicle(String placa, String color, String fecha, int coid, int caid, int mid) async {
    final http.Response response = await http.post(
      apiUrl + "api/Vehiculoes/Create",
      headers: this.headers,

      body: jsonEncode(

          {

        'placa': placa,
        'color': color,
        'fechaFabricacion': fecha,
        'conductorId': coid,
        'categoriaId': caid,
        'modeloId': mid

      }),
    );


    if (response.statusCode == 201) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {


      }
  }


  Future<Vehicle> putVehicle(String id, int idn, String placa, String color, String fecha, int coid, int caid, int mid) async {
    final http.Response response = await http.put(
      apiUrl + "api/Vehiculoes/Update/" + "$id",
      headers: this.headers,

      body: jsonEncode(

          {
            'vehiculoId': idn,
            'placa': placa,
            'color': color,
            'fechaFabricacion': fecha,
            'conductorId': coid,
            'categoriaId': caid,
            'modeloId': mid

          }),
    );

    debugPrint(id);

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update');

    }
  }


  Future<List<Vehicle>> getVehicles() async {
    try {
      final response =
      await http.get("$apiUrl" + "api/Vehiculoes/List", headers: this.headers);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint("getVehicles : " + responseBody);
        final List<Vehicle> vehicles = vehicleFromJson(response.body);

        return vehicles;
      }
      return null;
    } catch (e) {


      return List<Vehicle>();
    }
  }
}










