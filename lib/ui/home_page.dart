import 'package:corontor_indonesia/constants/routes.dart';
import 'package:corontor_indonesia/cubit/all_cubit_state.dart';
import 'package:corontor_indonesia/cubit/home_cubit.dart';
import 'package:corontor_indonesia/ui/widget/case_card.dart';
import 'package:corontor_indonesia/ui/widget/case_table.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit _cubit = HomeCubit();

  @override
  void initState() {
    _cubit.fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corontor Indonesia'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => Get.toNamed(val),
            itemBuilder: (context) => {
              context.l10n.profile: Routes.profile,
              context.l10n.settings: Routes.settings
            }
                .map((k, v) => MapEntry(
                    k, PopupMenuItem<String>(value: v, child: Text(k))))
                .values
                .toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _cubit.fetchData(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.l10n.covidGrowth,
                      style: Get.textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.l10n.allIndonesia,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                BlocProvider<HomeCubit>(
                  create: (context) => _cubit,
                  child: BlocBuilder<HomeCubit, CubitState?>(
                      builder: (context, state) {
                    if (state != null) {
                      switch (state) {
                        case CubitState.loading:
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            FutureBuilder(
                                future: Future<bool>.delayed(
                                    Duration(seconds: 5), () => true),
                                builder: (context, _) {
                                  if (_.hasData)
                                    return Text(context.l10n.takeAMinute);
                                  return Container();
                                })
                          ]);
                        case CubitState.failed:
                          return Column(
                            children: [
                              Text(
                                  '${_cubit.nationalErr}\n\n${_cubit.provinceErr}'),
                              TextButton(
                                  onPressed: () => _cubit.fetchData(),
                                  child: Text(context.l10n.tryAgain)),
                            ],
                          );
                        case CubitState.success:
                          List<Widget> children = [];

                          if (_cubit.national != null &&
                              _cubit.national!.isNotEmpty) {
                            final data = _cubit.national!.single;
                            children.add(Row(children: [
                              CaseCard(
                                title: context.l10n.death,
                                value: data.deaths,
                                cardMargin: const EdgeInsets.only(right: 8.0),
                                labelBgColor: Colors.red,
                              ),
                              CaseCard(
                                title: context.l10n.active,
                                value: data.active,
                                labelBgColor: Colors.amber[700],
                              ),
                              CaseCard(
                                title: context.l10n.recovered,
                                value: data.recovered,
                                cardMargin: const EdgeInsets.only(left: 8.0),
                                labelBgColor: Colors.green,
                              ),
                            ]));
                          }

                          if (_cubit.province != null &&
                              _cubit.province!.isNotEmpty) {
                            children.add(CaseTable(data: _cubit.province!));
                          }

                          if (children.isEmpty) {
                            return Center(child: Text(context.l10n.noData));
                          }
                          return Column(children: children);
                      }
                    }
                    return Container();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
