
import 'package:TS_AppsMovil/Model/Vehicle.dart';
import 'package:TS_AppsMovil/Services/http-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class UpdateVehicle extends StatefulWidget {


  final int id;

  UpdateVehicle({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateVehicle();
}

class _UpdateVehicle extends State<UpdateVehicle> {
  final HttpService httpService = HttpService();



  @override
  void initState() {
    super.initState();


  }

  final c0 = TextEditingController();
  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    c0.dispose();
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    c6.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[

            TextField(
              controller: c0,
              decoration: InputDecoration(
                  hintText: 'Nuevo ID'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: c1,
              decoration: InputDecoration(
                  hintText: 'Placa'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: c2,
              decoration: InputDecoration(
                  hintText: 'Color'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: c3,
              decoration: InputDecoration(
                  hintText: 'Fecha de Fabricación'
              ),
            ),


            Container(height: 8),

            TextField(
              controller: c4,
              decoration: InputDecoration(
                  hintText: 'ID del Conductor'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: c5,
              decoration: InputDecoration(
                  hintText: 'ID de la categoría'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: c6,
              decoration: InputDecoration(
                  hintText: 'ID de modelo'
              ),
            ),

            Container(height: 16),

            SizedBox(
                width: double.infinity,
                height: 35,
                child: RaisedButton(
                    child: Text(
                        'Actualizar', style: TextStyle(color: Colors.white)),
                    color: Theme
                        .of(context)
                        .primaryColor,
                    onPressed: () async {
                      httpService.putVehicle(widget.id.toString(), int.parse(c0.text), c1.text, c2.text, c3.text, int.parse(c4.text), int.parse(c5.text), int.parse(c6.text));

                    }
                )
            ),
          ],
        ),
      ),
    );
  }

}
