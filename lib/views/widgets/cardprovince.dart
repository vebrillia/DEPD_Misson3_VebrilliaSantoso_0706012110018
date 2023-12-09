import 'package:depd23_apifix/models/models.dart';
import 'package:flutter/material.dart';

class CardProvince extends StatefulWidget {
  final Province prov;
  const CardProvince(this.prov);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince> {
  @override
  Widget build(BuildContext context) {
    Province p = widget.prov;
    return Card(
      color: Color(0xFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text("${p.province}"),
        subtitle: Text("${p.province}"),
      ),
    );
  }
}
