import 'dart:ffi';

import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ShowComplaint extends StatelessWidget {
  Complaint complaint;

  ShowComplaint(this.complaint);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(complaint.title),
        SizedBox(
          height: 30,
        ),
        Text(complaint.description),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: complaint.images_url.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Image image = Image.network(complaint.images_url[index]);
              return Card(child: image);
            },
          ),
        ),
      ],
    );
  }
}
