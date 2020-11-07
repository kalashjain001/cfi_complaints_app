import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    return StreamProvider<List<Complaint>>.value(
      value: DatabaseService(user.uid).myComplaints,
      child: Home(),
    );
  }
}
