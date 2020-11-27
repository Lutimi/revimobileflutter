
import 'package:TS_AppsMovil/Model/Cargo.dart';
import 'package:TS_AppsMovil/Model/Subscription.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MoneyMovView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MoneyMovView();
}

class _MoneyMovView extends State<MoneyMovView> {
  final HttpService httpService = HttpService();
  List<Cargo> cargoes;
  List<Subscription> subs;

  Future<List<Cargo>> getCargos() async {
    this.cargoes = await httpService.getCargoesById();
    return this.cargoes;
  }

  Future<List<Subscription>> getSubs() async {
    this.subs = await httpService.getSubsById();
    return this.subs;
  }


  Widget createCargoesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;


    return ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5,
            child: Container(
              height:120.0,
              child: Row(
                children: <Widget>[

                  Container(
                    height: 120,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ListTile(
                            title: Text(values[index].description, style:TextStyle(color:Colors.black, fontSize: 16.0, )),
                            subtitle: Text('Costo :' + values[index].servicePrice.toString() + "\n" + "Fecha: " + values[index].startTime.toString(), style:TextStyle(color:Colors.grey, fontSize: 14.0, )),
                            onTap: (){

                            },),

                        ],
                      ),
                    ),
                  ),
                  //-------------------------

                ],
              ),
            ),
          );

        }
    );
  }

  Widget createSubsListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5,
            child: Container(
              height:120.0,
              child: Row(
                children: <Widget>[

                  Container(
                    height: 120,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ListTile(
                            title: Text(values[index].plan, style:TextStyle(color:Colors.black, fontSize: 16.0, )),
                            subtitle: Text('Costo :' + values[index].price.toString() + "\n" + "Estado: " + values[index].state, style:TextStyle(color:Colors.grey, fontSize: 14.0, )),


                          ),
                        ],
                      ),
                    ),
                  ),
                  //-------------------------
                  Container(
                    height: 150,
                    width: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),

      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: getCargos(),
              initialData: [],
              builder: (context, snapshot) {
                return createCargoesListView(context, snapshot);
              }),
        ),
        Row(
          children: [
             Container(

              color: Colors.amber,
              height: 50,
            ),
          ],
        ),
        Expanded(

          child: FutureBuilder(
              future: getSubs(),
              initialData: [],
              builder: (context, snapshot) {
                return createSubsListView(context, snapshot);
              }),
        ),
      ]),
    );
  }
}

  //@override
  //Widget build(BuildContext context) {
  //  return new Scaffold(
  //      body: Container(
  //          child: FutureBuilder(
  //              future: getSubs(),
  //              builder: (context, snapshot) {
  //                if (snapshot.data == null) {
  //                  return Center(child: CircularProgressIndicator());
  //                } else {
  //                  return SingleChildScrollView(
  //                    scrollDirection: Axis.horizontal,
  //                    child: SingleChildScrollView(
  //                      child: DataTable(
  //                        columns: [
  //                          DataColumn(
  //                              label: Text('Usuario'),
  //                              tooltip: 'represents first name of the user'),
  //                          DataColumn(
  //                              label: Text('Favorito'),
  //                              tooltip: 'represents first name of the user'),
//
  //                        ],
  //                        rows: this
  //                            .subs
  //                            .map((data) => DataRow(cells: [
  //                          DataCell(Text(data.plan)),
  //                          DataCell(Text(data.state)),
//
  //                        ]))
  //                            .toList(),
  //                      ),
  //                    ),
  //                  );
  //                }
  //              })));
  //}
//}