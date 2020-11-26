import 'package:TS_AppsMovil/Model/Company.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';

class CompanyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompanyList();
}

class _CompanyList extends State<CompanyList> {
  final HttpService httpService = HttpService();
  List<Company> companies;

  Future<List<Company>> getCompanies() async {
    this.companies = await httpService.getCompanies();
    return this.companies;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            child: FutureBuilder(
                future: getCompanies(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('Name'),
                                tooltip: ''),
                            DataColumn(
                                label: Text('Email'),
                                tooltip: ''),
                            DataColumn(
                                label: Text('Phone'),
                                tooltip: ''),
                          ],
                          rows: this
                              .companies
                              .map((data) => DataRow(cells: [
                                    DataCell(Text(data.nombre)),
                                    DataCell(Text(data.correo)),
                                    DataCell(Text(data.telefono.toString())),
                                  ]))
                              .toList(),
                        ),
                      ),
                    );
                  }
                })));
  }
}
