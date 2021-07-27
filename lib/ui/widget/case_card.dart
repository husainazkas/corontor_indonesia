import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaseCard extends StatelessWidget {
  CaseCard({
    Key? key,
    required this.title,
    required this.value,
    this.cardMargin,
    this.labelBgColor,
  }) : super(key: key);

  final String title;
  final int value;
  final EdgeInsetsGeometry? cardMargin;
  final Color? labelBgColor;
  final NumberFormat _format = NumberFormat.decimalPattern('id');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: cardMargin,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Card(
                color: labelBgColor,
                margin: EdgeInsets.zero,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(title,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    _format.format(value),
                    textScaleFactor: 1.2,
                  ),
                  Text('Jiwa')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
