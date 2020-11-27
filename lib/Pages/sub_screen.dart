

import 'package:TS_AppsMovil/Model/Subscription.dart';
import 'package:TS_AppsMovil/Pages/plan_screen.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SubView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubView();
}

class _SubView extends State<SubView> {
  final HttpService httpService = HttpService();

  List<Subscription> subs;
  Future<Subscription> _futureSub ;

 @override
 void initState() {
   super.initState();
   _futureSub ;//= httpService.fetchSub(1.toString());
 }

  Future<List<Subscription>> getSubs() async {
    this.subs = await httpService.getSubsById();
    return this.subs;
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
                           subtitle: Text('Costo :' + values[index].price.toString(), style:TextStyle(color:Colors.grey, fontSize: 14.0, )),
                           onTap: (){

                            },),
                          Row(
                            children: <Widget>[
                              Icon(Icons.app_blocking_sharp, color: Colors.grey),
                              Text("  Status: " + values[index].state, style:TextStyle(color:Colors.cyan, fontSize: 14.0)),
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
                                    // debugPrint(values[index].id.toString());
                                    _futureSub = httpService.deleteSub(values[index].id);
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Text('Cambiar', style:TextStyle(color:Colors.white, fontSize: 14.0)),
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {//debugPrint(values[index].id.toString());
                                    if (values[index].state == 'Actived') {
                                      _futureSub = httpService.putSubDisable(values[index].id) ;
                                    }
                                    else {
                                      _futureSub = httpService.putSubEnable(values[index].id);
                                    }

                                    
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
        title: Text('Subscriptions'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add',
              //onPressed: scaffoldKey.currentState.showSnachBar(snackBar);
              onPressed: () {

                  Navigator.push(context,
                  MaterialPageRoute(
                  builder: (BuildContext context) => PlanView()));

              })
        ],
      ),

      body: Column(children: [
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


