import 'package:TS_AppsMovil/Model/Favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';

class FavoriteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavouriteList();
}

class _FavouriteList extends State<FavoriteList> {
  final HttpService httpService = HttpService();
  List<Favorite> favorites;

  Future<List<Favorite>> getFavorites() async {
    this.favorites = await httpService.getFavorites();
    return this.favorites;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            child: FutureBuilder(
                future: getFavorites(),
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
                                label: Text('Usuario'),
                                tooltip: 'represents first name of the user'),
                            DataColumn(
                                label: Text('Favorito'),
                                tooltip: 'represents first name of the user'),
                            DataColumn(
                                label: Text('Fecha'),
                                tooltip: 'represents first name of the user'),
                          ],
                          rows: this
                              .favorites
                              .map((data) => DataRow(cells: [
                                    DataCell(Text(data.user)),
                                    DataCell(Text(data.favourited)),
                                    DataCell(Text(data.since.toString())),
                                  ]))
                              .toList(),
                        ),
                      ),
                    );
                  }
                })));
  }
}
