

import 'package:TS_AppsMovil/Model/Plan.dart';
import 'package:TS_AppsMovil/Model/Subscription.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class PlanView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanView();
}

class _PlanView extends State<PlanView> {
  final HttpService httpService = HttpService();

  List<Plan> plans;
  Future<Subscription> _futureSub ;

 @override
 void initState() {
   super.initState();

 }

  Future<List<Plan>> getPlans() async {
    this.plans = await httpService.getPlans();
    return this.plans;
  }


  Widget createSubsListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;


    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {

              return Card(
                elevation: 5,
                child: Container(
                  height:80.0,
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
                                title: Text(values[index].planName, style:TextStyle(color:Colors.black, fontSize: 16.0, )),
                                subtitle: Text('Cost : ' + values[index].price.toString() + '\nTax : ' + values[index].tax.toString(), style:TextStyle(color:Colors.blueGrey, fontSize: 14.0, )),
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
                                    child: Text('Suscribe', style:TextStyle(color:Colors.white, fontSize: 14.0)),
                                    color: Colors.lightGreen,
                                    onPressed: () {
                                      setState(() {
                                        // debugPrint(values[index].id.toString());
                                        _futureSub = httpService.createSubscription(4, values[index].id);
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
        title: Text('Plans avaliable'),
        actions: <Widget>[

        ],
      ),

      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: getPlans(),
              initialData: [],
              builder: (context, snapshot) {
                return createSubsListView(context, snapshot);
              }),
        ),
      ]),
    );
  }
}


