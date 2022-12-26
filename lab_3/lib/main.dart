
import 'package:flutter/material.dart';

import 'model/event_model.dart';
import 'widget/new_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Event planner',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
              titleSmall: const TextStyle()
          )
      ),
      // A widget which will be started on application startup
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<EventModel> _userEvents = [
    EventModel("MIS - Kol1", DateTime(2023, 1, 20, 16, 30)),
    EventModel("MIS - Kol2", DateTime(2023, 1, 28, 16, 30)),
  ];

  void _addItemFunction(BuildContext ct) {
    showDialog (
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Wrap(
                  children: [
                    NewEvent(_addNewItemToList)
                  ]
              )
          );
        });
  }

  void _addNewItemToList(EventModel event) {
    setState(() {
      _userEvents.add(event);
    });
  }

  void _deleteItem(String eventTitle) {
    setState(() {
      _userEvents.removeWhere((elem) => elem.eventTitle == eventTitle);
    });
  }

  Widget _createBody() {
    return Center(
      child: _userEvents.isEmpty
          ? const Text("No elements")
          : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),
            child: ListTile(
              title: Text(_userEvents[index].eventTitle),
              subtitle: Text(_userEvents[index].eventDateTime.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteItem(_userEvents[index].eventTitle),
              ),
            ),
          );
        },
        itemCount: _userEvents.length,
      ),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      // The title text which will be shown on the action bar
        title: const Text("Event Planner"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }
}
