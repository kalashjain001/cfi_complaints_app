import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/screens/home/showComplaint.dart';
import 'package:cfi_complaints_app/services/database.dart';
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
    int complaintCount = myComplaints != null ? myComplaints.length : 0;
    final user = Provider.of<User>(context);
    final DatabaseService db = DatabaseService(user.uid);

    return complaintCount != 0
        ? ListView.builder(
            itemCount: myComplaints.length,
            itemBuilder: (context, index) {
              Complaint complaint = myComplaints[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowComplaint(complaint)));
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      title: Text(complaint.title),
                      subtitle: Text(complaint.description),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Complaint?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await db.deleteComplaint(complaint);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            })
        : Center(
            child: Text('No Complaints yet'),
          );
  }
}
