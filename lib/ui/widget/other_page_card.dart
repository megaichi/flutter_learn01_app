import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherPageCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;

  OtherPageCard({Key key, this.title, this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(6.0),
        child: InkWell(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.92,
              height: 60,
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(width: 8),
                  Text(
                    this.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
          onTap: this.onTap,
        ),
      ),
    );
  }
}
