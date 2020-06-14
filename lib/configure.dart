import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'add.dart';

class ConfigurePage extends StatefulWidget {
  final Record todo;
  ConfigurePage({Key key, @required this.todo}) : super(key: key);
  @override
  _ConfigurePageState createState() {
    return _ConfigurePageState();
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));
bool edit_name = false;
bool edit_desc = false;
bool edit_quan = false;

class _ConfigurePageState extends State<ConfigurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.todo.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Delete",
            onPressed: () {
              Firestore.instance
                  .collection("components")
                  .document(widget.todo.reference.documentID.toString())
                  .delete(); // the actual data from main.dart
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          )
        ],
      ),
      body: _buildConfigureBody(context),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          tooltip: "Save",
          child: Icon(Icons.check)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  final nameController = new TextEditingController();
final descriptionController = new TextEditingController();
final quantityController = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Widget _buildConfigureBody(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: edit_name
                ? Form(child: TextFormField(controller: nameController))
                : Text(
                    widget.todo.name,
                    textAlign: TextAlign.center,
                  )),
        Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(edit_name ? Icons.check : Icons.edit),
              onPressed: () => setState(() {
                if (edit_name) {
                  Firestore.instance
                      .collection("components")
                      .document(widget.todo.reference.documentID.toString())
                      .updateData({'name': nameController.text});
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
                
                edit_name = !edit_name;
              }),
            ))
      ]),
Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: edit_desc
                ? Form(child: TextFormField(controller: descriptionController))
                : Text(
                    widget.todo.description,
                    textAlign: TextAlign.center,
                  )),
        Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(edit_desc ? Icons.check : Icons.edit),
              onPressed: () => setState(() {
                if (edit_desc) {
                  Firestore.instance
                      .collection("components")
                      .document(widget.todo.reference.documentID.toString())
                      .updateData({'description': descriptionController.text});
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
                
                edit_desc = !edit_desc;
              }),
            ))
      ]),
Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: edit_quan
                ? Form(child: TextFormField(controller: quantityController))
                : Text(
                    widget.todo.quantity.toString(),
                    textAlign: TextAlign.center,
                  )),
        Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(edit_quan ? Icons.check : Icons.edit),
              onPressed: () => setState(() {
                if (edit_quan) {
                  Firestore.instance
                      .collection("components")
                      .document(widget.todo.reference.documentID.toString())
                      .updateData({'quantity': int.parse(quantityController.text)});
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
                
                edit_quan = !edit_quan;
              }),
            ))
      ])
    ]);
  }
}
