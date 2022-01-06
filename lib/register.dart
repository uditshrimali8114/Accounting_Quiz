import 'dart:convert';
import 'package:accounting_quiz/Api/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'login.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool _isObscure = true;
  bool _isObscured = true;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  var baseUrl = ApiConfig().baseurl;
  var register = ApiConfig().api_register;

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    else{
      postRegisterData();
    }
  }

    Future<void> postRegisterData() async {
      String firstname = _firstName.text;
      String lastname = _lastName.text;
      String email = _email.text;
      String pass = _pass.text;
      String confirmpass = _confirmPass.text;
      String url = baseUrl + register;
      var requestUrl = url;
      print("listEmployeeurl--> " + requestUrl);

      var headers = {
        'x-api-key':
        'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
       'Content-Type': 'application/json'
      };

      String body = jsonEncode({
        "firstName": firstname,
        "lastName": lastname,
        "email": email,
        "password": pass,
        "passwordConfirm": confirmpass,
        "approve": 1,
        "roleId": "5f4b48af0df2531f0acc8d46"
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
          // Fluttertoast.showToast(
          //     msg: jsonData["message"+ " Please Login"],
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.SNACKBAR,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  Login()),
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
                  // margin: const EdgeInsets.only(top: 55),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/Login/5.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Image.asset('assets/Register/Frame.png'),
                ),
                SizedBox(height: height*0.05,),
                //Toggle Button
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
                      GestureDetector(
                        onTap:() {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 40,
                          // decoration: BoxDecoration(
                          //     color:Color(0xFFe81818),
                          //     borderRadius: BorderRadius.all(Radius.circular(25))
                          // ),
                          child: Text('Login',style: TextStyle(fontSize: 18),),),
                      ),
                      Container(
                          width: 148,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:Color(0xFFe81818),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Text('Register',style: TextStyle(fontSize: 18,color: Colors.white),))
                    ],
                  ),
                ),
                SizedBox(height: height*0.03,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("First Name",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _firstName,

                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Color(0xFF525252) ),
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
                        return 'Enter First Name!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.02,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Last Name",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _lastName,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Color(0xFF525252) ),
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
                        return 'Enter Last Name!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.02,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Email Address",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Color(0xFF525252) ),
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
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.02,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Password",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _pass,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Color(0xFF525252) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 2.0),
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
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password must be in 8 character';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.02,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Confirm Password",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    controller: _confirmPass,
                    decoration: InputDecoration(

                      labelStyle: const TextStyle(color: Color(0xFF525252) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 2.0),
                        // #c01211
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Color(0xFFe81818),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          }),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {},
                    obscureText: _isObscured,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password must be in 8 character';
                      }
                      if(value != _pass.text) {
                    return 'Password Not Match';
                  }
                  return null;
                    },
                  ),
                ),
                SizedBox(height: height*0.01,),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: FlatButton(
                    height: height*0.06,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Create Account', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                        Container(
                          padding: const EdgeInsets.all(3),
                          height: 30,
                          width: 30,
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
                    // onPressed:  () async {
                    //   String firstname = _firstName.text;
                    //   String lastname = _lastName.text;
                    //   String email = _lastName.text;
                    //   String pass = _lastName.text;
                    //   String confirmpass = _lastName.text;
                    //
                    //   DataModel? data = await submitData(
                    //       firstname, lastname, email, pass, confirmpass);
                    //   setState(() {
                    //     _dataModel = data!;
                    //   });
                    // },
                    onPressed:() => _submit(),
                    // {
                    //   Navigator.push(
                    //       context, MaterialPageRoute(builder: (context) => Dashboard()));
                    // },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                ),
               SizedBox(height: height*0.01,),

                GestureDetector(
                  onTap: (){Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Login()));} ,
                  child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
      children: <TextSpan>[

        TextSpan(text: 'Already have a Account?',style: TextStyle(fontSize: 14)),
        TextSpan(text: '  Login', style: TextStyle(fontSize: 16,color: Color(0xFFe81818),),),

      ],
    ),
    ),
                ),
                SizedBox(height: height*0.03,),
              ],
            ),
          )
      ),
    );
  }
}







