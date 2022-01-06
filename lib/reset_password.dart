import 'dart:convert';

import 'package:accounting_quiz/Api/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isObscure = false;
  var _pref;
  var baseUrl = ApiConfig().baseurl;
  var register = ApiConfig().api_resetPass;
  TextEditingController _newPass = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    else{
      sendEmail();
    }
  }
  Future<void> sendEmail() async {

    _pref =await SharedPreferences.getInstance();
    var email = _pref.getString('email');
    var otp = _pref.getString('otp');

    String newpass = _newPass.text;

    String url = baseUrl + register;
    var requestUrl = url;
    print("url--> " + requestUrl);

    var headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Content-Type': 'application/json'
    };

    String body = jsonEncode({
      "email": email,
      "otp": otp,
      "password":newpass
    });

    var response =
    await http.post(Uri.parse(requestUrl), body: body, headers: headers);

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        // Fluttertoast.showToast(
        //     msg: jsonData["message"],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        Fluttertoast.showToast(
            msg: jsonData["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 55),
                  child: Image.asset('assets/Forgot Password/1.png'),
                ),
                const SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: TextFormField(
                    controller: _newPass,
                    decoration: InputDecoration(
                      labelText: "Enter New Password",
                      hintText: '********',
                      labelStyle: TextStyle(color: Color(0xFF8785aa) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 2.0),
                        // #c01211
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Color(0xFFe81818),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                    ),

                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {},
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value!.isEmpty|| value.length < 8) {
                        return 'Enter a valid password!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: FlatButton(
                    height: 50,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Send me reset password link', style: TextStyle(fontSize: 16.0,color: Colors.white),),
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5,
                                  color: const Color(0xFFee5c5d)
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: Image.asset('assets/Register/Back.png'),
                        )
                      ],
                    ),
                    color: const Color(0xFFe81818),
                    textColor: Colors.white,
                    onPressed:() => _submit(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

              ],
            ),
          )
      ),
    );
  }
}