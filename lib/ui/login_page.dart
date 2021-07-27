import 'package:corontor_indonesia/constants/routes.dart';
import 'package:corontor_indonesia/ui/widget/loading_card.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final RxBool _hidePass = true.obs;
  final RxBool _isLoading = false.obs;
  final Rx<AutovalidateMode> _avm = AutovalidateMode.disabled.obs;
  String? _email, _pass;

  bool _validate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      return true;
    }
    _avm.value = AutovalidateMode.onUserInteraction;
    return false;
  }

  Future<void> _submit(Future signIn) async {
    try {
      _isLoading.value = true;
      await signIn;
      Get.offAllNamed(Routes.home);
    } catch (e) {
      print(e);
      Get.dialog(AlertDialog(
        title: Text(context.l10n.alert),
        content: Text('$e'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.l10n.ok),
          )
        ],
      ));
    }
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(4.0)),
                  onTap: () => _submit(_auth.signInAnonymously()),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(context.l10n.skip),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.l10n.signIn,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textScaleFactor: 3.5,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Obx(
                    () => Form(
                      key: _formKey,
                      autovalidateMode: _avm.value,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val?.isEmpty ?? true
                                ? context.l10n.fieldRequired
                                : !val!.isEmail
                                    ? context.l10n.invalidT('Email')
                                    : null,
                            onSaved: (val) => _email = val?.trim(),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () => _hidePass.toggle(),
                                icon: Icon(_hidePass.value
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            obscureText: _hidePass.value,
                            validator: (val) => val?.isEmpty ?? true
                                ? context.l10n.fieldRequired
                                : null,
                            onSaved: (val) => _pass = val,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validate()) {
                          _submit(_auth.signInWithEmailAndPassword(
                              email: _email!, password: _pass!));
                        }
                      },
                      child: Center(
                        child: Text(context.l10n.signIn),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${context.l10n.dontHaveAcc} '),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(4),
                        ),
                        onPressed: () => Get.toNamed(Routes.register),
                        child: Text('${context.l10n.signUp}.'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Obx(() => _isLoading.value ? LoadingCard() : Container()),
        ],
      ),
    );
  }
}
