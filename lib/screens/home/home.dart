import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/screens/home/myComplaintsList.dart';
import 'package:cfi_complaints_app/screens/home/newComplaint.dart';
import 'package:cfi_complaints_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cfi_complaints_app/services/auth.dart';


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final AuthService _auth = AuthService();
    final List<Tab> myTabs = <Tab>[
      Tab(text: 'New Complaint'),
      Tab(text: 'My Complaints'),
    ];

    return StreamProvider<List<Complaint>>.value(
      value: DatabaseService(user.uid).myComplaints,
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(

          appBar: AppBar(
            title: Text('Complaints'),
            bottom: TabBar(
              tabs: myTabs,
            ),
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person),
                  label: Text('logout'))
            ],
          ),
          body: TabBarView(
            children: myTabs.map((Tab tab) {
              final String label = tab.text;
              return label == 'New Complaint' ? NewComplaint() : ComplaintsList();
            }).toList(),
          ),
        ),
      )
    );
  }
}
