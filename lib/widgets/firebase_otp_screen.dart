
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class FirebaseOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final VoidCallback onSuccess;
  final String previousRoute;

  const FirebaseOtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
    required this.onSuccess,
    required this.previousRoute,
  }) : super(key: key);

  @override
  _FirebaseOtpScreenState createState() =>
      _FirebaseOtpScreenState();
}

class _FirebaseOtpScreenState extends State<FirebaseOtpScreen> {

  final auth = FirebaseAuth.instance;

  TextEditingController textEditingController = TextEditingController();

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = '';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  Future<bool> _verifyOtp() async{
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: currentText
    );

    // Sign the user in (or link) with the credential
    try{
      await auth.signInWithCredential(credential);
      return true;
    } catch (e){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        key: scaffoldKey,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: <Widget>[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text(
                  'Xác thực OTP',
                  style: theme.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: 'Nhập mã OTP được gửi đến ',
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ],
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.normal
                    )
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 60,
                      fieldWidth: 30,
                      activeColor: theme.colorScheme.secondary,
                      inactiveColor: Colors.black,
                      selectedColor: theme.colorScheme.secondary
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    textStyle: const TextStyle(fontSize: 20, height: 1.6),
                    // backgroundColor: Colors.blue.shade50,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? 'Mã OTP không chính xác' : '',
                  style: theme.textTheme.subtitle1?.copyWith(
                    color: Colors.red
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length != 6) {
                      errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                      setState(() {
                        hasError = true;
                      });
                    } else {

                      final result = await _verifyOtp();
                      if(result) {
                        switch(widget.previousRoute){
                          case ROUTE_REGISTER:
                            widget.onSuccess();
                            Navigator.pop(context);
                            break;
                          case ROUTE_PASSWORD_FORGOT:
                            Navigator.pop(context);
                            widget.onSuccess();
                            break;
                          default:
                            break;
                        }
                      } else {
                        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      'Xác Nhận'.toUpperCase(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text('Xóa'),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }
}