import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/screens/home/showComplaint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ComplaintsList extends StatefulWidget {
  @override
  _ComplaintsListState createState() => _ComplaintsListState();
}

class _ComplaintsListState extends State<ComplaintsList> {

  @override
  Widget build(BuildContext context) {

    final myComplaints = Provider.of<List<Complaint>>(context);
    return myComplaints!=null ? ListView.builder(
        itemCount: myComplaints.length,
        itemBuilder: (context, index) {
          Complaint complaint = myComplaints[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: () {Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShowComplaint(complaint)));},
              child: Card(
                elevation: 2,
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  title: Text(complaint.title),
                  subtitle: Text(complaint.description),
                ),
              ),
            ),
          );
        }) : Center(child: Text('No Complaints yet'),);
  }
}