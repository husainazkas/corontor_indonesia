import 'package:corontor_indonesia/constants/routes.dart';
import 'package:corontor_indonesia/ui/widget/loading_card.dart';
import 'package:corontor_indonesia/utils/context_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passCtlr1 = TextEditingController();

  final RxBool _hidePass1 = true.obs;
  final RxBool _hidePass2 = true.obs;
  final RxBool _isLoading = false.obs;
  final Rx<AutovalidateMode> _avm = AutovalidateMode.disabled.obs;

  String? _name, _email, _pass;

  IconData _getVisibleIcon(bool isHidden) =>
      isHidden ? Icons.visibility_off : Icons.visibility;

  bool _validate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      return true;
    }
    _avm.value = AutovalidateMode.onUserInteraction;
    return false;
  }

  Future<void> _submit() async {
    if (_validate()) {
      try {
        _isLoading.value = true;

        final result = await _auth.createUserWithEmailAndPassword(
            email: _email!, password: _pass!);
        await result.user!.updateDisplayName(_name);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.l10n.signUp,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textScaleFactor: 3.5,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Obx(() => Form(
                        key: _formKey,
                        autovalidateMode: _avm.value,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: context.l10n.fullName,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (val) => val?.isEmpty ?? true
                                  ? context.l10n.fieldRequired
                                  : null,
                              onSaved: (val) => _name = val?.trim(),
                            ),
                            SizedBox(height: 12.0),
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
                            SizedBox(height: 12.0),
                            TextFormField(
                              controller: _passCtlr1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () => _hidePass1.toggle(),
                                  icon: Icon(_getVisibleIcon(_hidePass1.value)),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              obscureText: _hidePass1.value,
                              validator: (val) => val?.isEmpty ?? true
                                  ? context.l10n.fieldRequired
                                  : val!.length < 6
                                      ? context.l10n.minimPassLength
                                      : null,
                              onSaved: (val) => _pass = val,
                            ),
                            SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: context.l10n.confirmPass,
                                suffixIcon: IconButton(
                                  onPressed: () => _hidePass2.toggle(),
                                  icon: Icon(_getVisibleIcon(_hidePass2.value)),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              obscureText: _hidePass2.value,
                              validator: (val) => val?.isEmpty ?? true
                                  ? context.l10n.fieldRequired
                                  : val != _passCtlr1.text
                                      ? context.l10n.invalidT('Password')
                                      : null,
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Center(child: Text(context.l10n.signUp)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${context.l10n.alreadyHaveAcc} '),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(4),
                        ),
                        onPressed: () => Get.back(),
                        child: Text('${context.l10n.signIn}.'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(() => _isLoading.value ? LoadingCard() : Container())
        ],
      ),
    );
  }
}
