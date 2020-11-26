import 'package:TS_AppsMovil/Model/Category.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CategoryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  final HttpService httpService = HttpService();

  List<Category> cats;
  Future<Category> _futureSub ;

  @override
  void initState() {
    super.initState();
    _futureSub ;//= httpService.fetchSub(1.toString());
  }

  Future<List<Category>> getCategories() async {
    this.cats = await httpService.getCategories();
    return this.cats;
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
                            title: Text(values[index].nombre, style:TextStyle(color:Colors.black, fontSize: 16.0, )),
                            subtitle: Text('Descripcion:' + values[index].descripcion, style:TextStyle(color:Colors.grey, fontSize: 14.0, )),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: getCategories(),
              initialData: [],
              builder: (context, snapshot) {
                return createSubsListView(context, snapshot);
              }),
        ),
      ]),
    );
  }
}
