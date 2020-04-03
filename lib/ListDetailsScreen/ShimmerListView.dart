import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/*class ShimmerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: DelayedList(), //ShimmerLayout()
            );
          }),
    );
  }
}*/

class DelayedList extends StatefulWidget {
  @override
  _DelayedStateList createState() => _DelayedStateList();
}

class _DelayedStateList extends State<DelayedList> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Timer mTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
//    return isLoading ? ShimmerLayout() : ShimmerLayout();
  return  ShimmerLayout();
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        color: Colors.white,
        elevation: 50.0,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0),
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              buildingRowItem("", ""),
              Divider(
                color: Colors.black,
              ),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              buildingRowItem("", ""),
              sizedBoxHeight(),
              Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Shimmer.fromColors(
                      child: Container(
                        height: 25,
                        width: 100,
                        color: Colors.grey,
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.white,
                      period: Duration(milliseconds: 950),
                    ),
                  )
                ],
              ),
              sizedBoxHeight()
            ],
          ),
        ));
  }

  Widget buildingRowItem(String key, String value) {
    return Container(
        child: Shimmer.fromColors(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 15,
                  width: 100,
                  color: Colors.grey,
                ),
                Container(
                  height: 15,
                  width: 50,
                  color: Colors.grey,
                )
              ],
            ),
            baseColor: Colors.grey[300],
            highlightColor: Colors.white,
            period: Duration(milliseconds: 950)));
  }

  Widget buildingTopRowItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$key ",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Gibson',
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Colors.black)),
        RichText(
            text: TextSpan(children: [
          WidgetSpan(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Image(
                image: AssetImage("assets/images/ic_clock.png"),
                width: 16,
                height: 16),
          )),
          TextSpan(
              text: " $value",
              style: TextStyle(
                  fontFamily: 'Gibson',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  color: Colors.black)),
        ])),
      ],
    );
  }

  Widget sizedBoxHeight() {
    return SizedBox(
      height: 10,
    );
  }
}
