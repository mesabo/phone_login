import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/home_screen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpControllerScreen extends StatefulWidget {
  OtpControllerScreen({this.phone = '', this.codeDigit = ''});

  String phone;
  String codeDigit;

  @override
  _OtpControllerScreenState createState() => _OtpControllerScreenState();
}

class _OtpControllerScreenState extends State<OtpControllerScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinCodecontroller = TextEditingController();
  final _focuseNode = FocusNode();

  String verificationCode = '';

  final BoxDecoration _pinotpDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
  );

  @override
  void initState() {
    verifyPhoneNumber();
    super.initState();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigit}-${widget.phone}",
        verificationCompleted: (phoneAuthCredential) async {
          await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential)
              .then((value) {
            if (value.user != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ));
        },
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/otp.png'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhoneNumber();
                },
                child: Text(
                  "Verifying : ${widget.codeDigit}-${widget.phone}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(fontSize: 25, color: Colors.white),
              eachFieldWidth: 40,
              eachFieldHeight: 55,
              focusNode: _focuseNode,
              controller: _pinCodecontroller,
              submittedFieldDecoration: _pinotpDecoration,
              selectedFieldDecoration: _pinotpDecoration,
              followingFieldDecoration: _pinotpDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode, smsCode: pin))
                      .then((value) {
                    if (value.user != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('OTP invalid'),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
