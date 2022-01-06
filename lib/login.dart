
import 'dart:convert';

import 'package:accounting_quiz/Api/api_config.dart';
import 'package:accounting_quiz/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'bottombar.dart';
import 'forgot_pass.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool _isObscure = true;
var preferences;


  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  var baseUrl = ApiConfig().baseurl;
  var Login = ApiConfig().api_login;
  var verify = ApiConfig().api_verify;
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    else{
      postLoginData();
    }
  }
  //Login Api
  Future<void> postLoginData() async {

    String email = _email.text;
    String pass = _pass.text;

    String url = baseUrl + Login;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);

    var headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Content-Type': 'application/json'
    };

    String body = jsonEncode({

      "email": email,
      "password": pass,

    });
    print("Body response"+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body, headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);
    print("fvdshfbhgdf" + response.body);
    print("fvdshfbhgdfHeader" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {


        String proPic= jsonData['data']['profilePhoto'];
        preferences =await SharedPreferences.getInstance();
        preferences.setString("profilepic",proPic);
        var token =jsonData['data']['data']['authtoken'];
        print("Token: "+ token.toString());
        preferences =await SharedPreferences.getInstance();
        preferences.setString("token",token);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>  bottomBar(bottom: 0)),
                (Route<dynamic> route) => false);

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData["message"],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    }
  }

  //Verify otp


  //Design
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: height*0.05,
                ),
                Container(
                  // margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                      'assets/Login/5.png'),
                  fit: BoxFit.fill,
                ),
                  ),
                  child: Image.asset('assets/Register/Frame.png', width:width*0.99,
                      fit:BoxFit.fill),
                ),
                SizedBox(height: height*0.05,),
                Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFe81818),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 122,
                        height: 40,
                        decoration: BoxDecoration(
                          color:Color(0xFFe81818),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 18),),),
                      GestureDetector(
                        onTap: (){Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Register()));} ,
                        child: Container(
                            width: 122,
                            alignment: Alignment.center,
                            child: Text('Register',style: TextStyle(fontSize: 18,),)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height*0.04,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Email Address",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _email,
                    // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],
                    decoration: InputDecoration(
                      // labelText: "Email Address",
                      labelStyle: TextStyle(color: Color(0xFF525252) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
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
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.04,),
                Container(
                  margin: EdgeInsets.only(left: 15,),
                  alignment: Alignment.bottomLeft,
                  child: Text("Password",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _pass,
                    decoration: InputDecoration(
                      // labelText: "Password",
                      labelStyle: TextStyle(color: Color(0xFF525252) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 1.0),
                        // #c01211
                      ),
                      suffixIcon: IconButton(
                    icon: Icon(
                    _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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

                SizedBox(height: height*0.03,),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: FlatButton(
                    height: height*0.06,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Login', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                        Container(
                          padding: EdgeInsets.all(5),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Color(0xFFee5c5d)
                            ),
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          child: Image.asset('assets/Register/Back.png'),
                        )
                      ],
                    ),
                    color: Color(0xFFe81818),
                    textColor: Colors.white,
                    onPressed: () => _submit(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ForgotPass()));
                  },
                  child: Text('Forgot Your Password', style: TextStyle(fontSize: 16),),
                )
              ],
            ),
          )
      ),
    );
  }
}

