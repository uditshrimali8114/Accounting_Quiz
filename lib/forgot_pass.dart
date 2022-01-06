import 'dart:convert';

import 'package:accounting_quiz/Api/api_config.dart';
import 'package:accounting_quiz/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  var _pref;
  var baseUrl = ApiConfig().baseurl;
  var register = ApiConfig().api_forgetPass;
  TextEditingController _email = TextEditingController();

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

    String email = _email.text;

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
    });
    print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body, headers: headers);

    var jsonData = jsonDecode(response.body);
    print("fvdshfbhgdf" + response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPassword()),
        );
        var otp =jsonData['data']['otp'];
        var _mail =jsonData['data']['email'];
        _pref =await SharedPreferences.getInstance();
        _pref.setString("otp",otp);
        _pref.setString("email",_mail);
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

                  // margin: const EdgeInsets.only(top: 55),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/Login/5.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(padding: EdgeInsets.all(40),
                      child: Image.asset('assets/Forgot Password/1.png')),
                ),
                const SizedBox(height: 25,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Email Address",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      hintText: "accountingquiz@gmail.com",
                      labelStyle: TextStyle(color:Color(0xFF525252) ),
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 2.0),
                        // #c01211
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      //Validator
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a email!';
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