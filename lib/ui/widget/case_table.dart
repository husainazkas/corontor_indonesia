import 'package:corontor_indonesia/model/covid_province.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaseTable extends StatelessWidget {
  CaseTable({Key? key, required this.data}) : super(key: key);

  final List<CovidProvince> data;
  final NumberFormat _format = NumberFormat.decimalPattern('id');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Per ${context.l10n.province}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: Theme.of(context).iconTheme.color!))),
          child: Row(
            children: [
              Expanded(
                child: Text(context.l10n.province, textScaleFactor: 1.1),
              ),
              Expanded(
                child: Text(
                  context.l10n.death,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                ),
              ),
              Expanded(
                child: Text(
                  context.l10n.active,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                ),
              ),
              Expanded(
                child: Text(
                  context.l10n.recovered,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.1,
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(child: Text(data[index].attributes!.province)),
                Expanded(
                  child: Text(_format.format(data[index].attributes!.deaths),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(_format.format(data[index].attributes!.active),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(_format.format(data[index].attributes!.recovered),
                      textAlign: TextAlign.center),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
