import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_project.dart';
import 'main.dart';

class ProjectPage extends StatefulWidget {
  final Record todo;
  ProjectPage({Key key, @required this.todo}) : super(key: key);
  @override
  _ProjectPageState createState() {
    return _ProjectPageState();
  }
}

class _ProjectPageState extends State<ProjectPage> {
  bool active_proj = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locate my tech - Project Edit')),
      body: _buildBody(context),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProjectFormPage()));
          },
          tooltip: "Increment Counter",
          child: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

// tells you what's in the database??
// gross af
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('projects').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

// gets the actual values on the page
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

// makes the actual page item
// does the incrementing stuff also
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    if (widget.todo.projects == record.reference.documentID) {
      print(widget.todo.projects);
      active_proj = true;
    } else {
      active_proj = false;
    }
    print(widget.todo.projects);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: active_proj ? Colors.grey : Colors.red),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name.toString()),
          trailing: IconButton(
            icon: new Icon(Icons.add),
            onPressed: () =>
            
             Firestore.instance
                .collection("components")
                .document(widget.todo.reference.documentID.toString())
                .updateData({"projects": record.reference.documentID}),
                
          ),
        ),
      ),
    );
  }
}

// Firestore.instance.collection(city).document('Attractions').updateData({"data": FieldValue.arrayUnion(obj)});
