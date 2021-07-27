import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: themeData.dialogBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
