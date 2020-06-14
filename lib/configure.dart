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

  Widget _buildConfigureBody(BuildContext context) {
    bool edit;
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Text(widget.todo.name),
        IconButton(
          icon: edit ? new Icon(Icons.check): new Icon(Icons.edit),
          onPressed: () => setState(() {
            if (edit) {
              edit = false;
            }else{
              edit=true;
            }
          }),
        )
      ]),
      Row(children: <Widget>[
        Text(widget.todo.description.toString()),
        IconButton(
          icon: new Icon(Icons.edit),
          onPressed: () => Navigator.pop(context),
        )
      ]),
      Row(children: <Widget>[
        Text(widget.todo.quantity.toString()),
        IconButton(
          icon: new Icon(Icons.edit),
          onPressed: () => Navigator.pop(context),
        )
      ])
    ]);
  }

// tells you what's in the database??
// gross af
  // Widget _buildConfigureBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('components').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();

  //       return _buildConfigureList(context, snapshot.data.documents);
  //     },
  //   );
  // }

// gets the actual values on the page
  Widget _buildConfigureList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

// makes the actual page item
// does the incrementing stuff also
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.quantity.toString()),
          onTap: () => record.reference
              .updateData({'quantity': FieldValue.increment(1)}),
        ),
      ),
    );
  }
}
