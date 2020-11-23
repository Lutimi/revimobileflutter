import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:TS_AppsMovil/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/User.dart';

class DriverList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriverList();
}

class _DriverList extends State<DriverList> {
  final HttpService httpService = HttpService();
  List<User> drivers;

  Future<List<User>> getDrivers() async {
    this.drivers = await httpService.getDrivers();
    return this.drivers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getDrivers(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              //provider.getData(context);
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text('Nombres'),
                          tooltip: 'represents first name of the user'),
                      DataColumn(
                          label: Text('Apellidos'),
                          tooltip: 'represents last name of the user'),
                      DataColumn(
                          label: Text('Vehiculo'),
                          tooltip: 'represents email address of the user'),
                      DataColumn(
                          label: Text('Phone'),
                          tooltip: 'represents phone number of the user'),
                    ],
                    rows: this
                        .drivers
                        .map((data) =>
                            // we return a DataRow every time
                            DataRow(
                                // List<DataCell> cells is required in every row
                                cells: [
                                  /*DataCell((data.verified)
                                    ? Icon(
                                        Icons.verified_user,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.cancel, color: Colors.red)),*/
                                  // I want to display a green color icon when user is verified and red when unverified

                                  DataCell(
                                    customRowDataIcon(
                                        Icons.person, data.firstName),
                                  ),
                                  DataCell(Text(data.lastName)),
                                  DataCell(Text(data.email)),
                                  DataCell(Text(data.lastName)),
                                ]))
                        .toList(),
                  ),
                ),
              );
            }
            // when we have the json loaded... let's put the data into a data table widget
          },
        ),
      ),
    );
  }
}
