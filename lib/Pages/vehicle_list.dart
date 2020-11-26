

import 'package:TS_AppsMovil/Model/Vehicle.dart';
import 'package:TS_AppsMovil/Pages/create_vehicle_screen.dart';
import 'package:TS_AppsMovil/Pages/update_vehicle_screen.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class VehicleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VehicleView();
}

class _VehicleView extends State<VehicleView> {
  final HttpService httpService = HttpService();

  List<Vehicle> vehicles;
  Future<Vehicle> _futureSub ;

 @override
 void initState() {
   super.initState();
   _futureSub ;
 }

  Future<List<Vehicle>> getVehicles() async {
    this.vehicles = await httpService.getVehicles();
    return this.vehicles;
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
                            title: Text('Placa :' + values[index].placa, style:TextStyle(color:Colors.black, fontSize: 16.0, )),
                           subtitle: Text('Color: ' + values[index].color, style:TextStyle(color:Colors.grey, fontSize: 14.0, )),
                           onTap: (){

                            },),
                          Row(
                            children: <Widget>[
                              Icon(Icons.app_blocking_sharp, color: Colors.grey),
                              Text("  Fecha Adquisicion: " + values[index].fechaFabricacion, style:TextStyle(color:Colors.cyan, fontSize: 14.0)),
                            ],
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
                        children: <Widget>[

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Text('Cancelar', style:TextStyle(color:Colors.white, fontSize: 14.0)),
                                color: Colors.redAccent,
                                onPressed: () {
                                  setState(() {
                                    debugPrint(values[index].vehiculoId.toString());
                                    _futureSub = httpService.deleteVehicle(values[index].vehiculoId.toString());
                                  });
                                },
                              ),
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Text('Actualizar', style:TextStyle(color:Colors.white, fontSize: 14.0)),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {//debugPrint(values[index].id.toString());

                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => UpdateVehicle(id : values[index].vehiculoId)));



                                  });
                                },
                              ),
                            ],
                          ),


                        ],
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
        title: Text('Vehicles'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add',
              //onPressed: scaffoldKey.currentState.showSnachBar(snackBar);
              onPressed: () {

                 Navigator.push(context,
                 MaterialPageRoute(
                 builder: (BuildContext context) => RegVehicle()));

              })
        ],
      ),

      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: getVehicles(),
              initialData: [],
              builder: (context, snapshot) {
                return createSubsListView(context, snapshot);
              }),
        ),
      ]),
    );
  }
}


