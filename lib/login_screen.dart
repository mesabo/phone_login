import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/otp_controller.dart';

class LoginSreen extends StatefulWidget {
  const LoginSreen({Key? key}) : super(key: key);

  @override
  _LoginSreenState createState() => _LoginSreenState();
}

class _LoginSreenState extends State<LoginSreen> {
  String dialcodedigit = '+00';

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Image.asset('images/login.jpg'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Phone OTP authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: 100,
              child: CountryCodePicker(
                onChanged: (value) {
                  setState(() {
                    dialcodedigit = value.dialCode!;
                  });
                },
                initialSelection: "IT",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: ["+225", "CIV", "+1", "US"],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  prefix: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(dialcodedigit),
                  ),
                ),
                maxLength: 14,
                keyboardType: TextInputType.phone,
                controller: _controller,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OtpControllerScreen(
                          phone: _controller.text, codeDigit: dialcodedigit),
                    ));
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
