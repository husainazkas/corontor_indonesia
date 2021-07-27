import 'package:corontor_indonesia/constants/routes.dart';
import 'package:corontor_indonesia/cubit/all_cubit_state.dart';
import 'package:corontor_indonesia/cubit/profile_cubit.dart';
import 'package:corontor_indonesia/ui/widget/loading_card.dart';
import 'package:corontor_indonesia/ui/widget/profile_item.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileCubit _cubit = ProfileCubit();

  @override
  void initState() {
    _cubit.stream.listen((event) async {
      if (event != CubitState.loading) {
        if (event == CubitState.failed) {
          await Get.dialog(
            AlertDialog(
              title: Text(context.l10n.alert),
              content: Text(_cubit.error!.toString()),
              actions: [
                TextButton(
                    onPressed: () => Get.back(), child: Text(context.l10n.ok))
              ],
            ),
            barrierDismissible: false,
          );
        }
        Get.offAllNamed(Routes.login);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(context.l10n.profile)),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 36.0),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _auth.currentUser!.photoURL != null
                      ? NetworkImage(_auth.currentUser!.photoURL!)
                      : null,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 12.0),
                const Divider(),
                const SizedBox(height: 12.0),
                _body(),
              ],
            ),
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => _cubit,
          child: BlocBuilder<ProfileCubit, CubitState?>(
            bloc: _cubit,
            builder: (context, state) {
              if (state == CubitState.loading) return LoadingCard();
              return Container();
            },
          ),
        )
      ],
    );
  }

  Widget _body() {
    if (_auth.currentUser!.isAnonymous) {
      return Column(
        children: [
          Text(context.l10n.youNotLoggedIn),
          TextButton(
            onPressed: () => _cubit.callFunction(_auth.signOut),
            child: Text('${context.l10n.signIn} ${context.l10n.now}!'),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileItem(
            title: context.l10n.fullName,
            value: _auth.currentUser!.displayName!),
        const SizedBox(height: 12.0),
        ProfileItem(title: 'Email', value: _auth.currentUser!.email!),
        const SizedBox(height: 12.0),
        const Divider(),
        const SizedBox(height: 12.0),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.red[300]),
            onPressed: () async {
              final sureToDelete = await Get.dialog<bool>(AlertDialog(
                title: Text(context.l10n.alert),
                content: Text(context.l10n.areYouSureDeleteAcc),
                actions: [
                  TextButton(
                      style: TextButton.styleFrom(primary: Colors.red[300]),
                      onPressed: () => Get.back(result: true),
                      child: Text(context.l10n.yes)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red[300]),
                      onPressed: () => Get.back(result: false),
                      child: Text(context.l10n.no)),
                ],
              ));
              if (sureToDelete != null && sureToDelete)
                _cubit.callFunction(_auth.currentUser!.delete);
            },
            child: Text(context.l10n.deleteMyAcc),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red[300]),
            onPressed: () => _cubit.callFunction(_auth.signOut),
            child: Text(context.l10n.logout),
          ),
        ),
      ],
    );
  }
}
