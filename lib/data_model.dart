// import 'dart:convert';
//
// import 'package:http/http.dart'as http;
// import 'dart:js';
//
// import 'package:accounting_quiz/register.dart';
// import 'package:flutter/material.dart';
//
// Future<void> postRegisterData() async {
//   // this.preferences = await SharedPreferences.getInstance();
//   String url = baseUrl + register;
//   var requestUrl = url;
//   print("listEmployeeurl--> " + requestUrl);
//
//   var headers = {
//     'x-api-key':
//     'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
//     'Content-Type': 'application/json'
//   };
//
//   String body = jsonEncode({
//     "firstName": firstname,
//     "lastName":lastname,
//     "email":email,
//     "password":pass,
//     "passwordConfirm":confirmpass,
//     "roleId" : "5f4b48ae0df2531f0acc8d43"
//   });
//
//   var response =
//   await http.post(Uri.parse(requestUrl), body: body, headers: headers);
//   var jsonData = jsonDecode(response.body);
//   print("fvdshfbhgdf" + response.body);
//   print("fvdshfbhgdfHeader" + headers.toString());
//
//   if (response.statusCode == 200) {
//     if (jsonData['status'] == 200) {
//
//       Fluttertoast.showToast(
//           msg: jsonData["message"],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.SNACKBAR,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Register()),
//       );
//     } else {
//       Fluttertoast.showToast(
//           msg: jsonData["message"],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.SNACKBAR,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }
// }

//####################################### old Code########################################
// Future<void> submitData(String firstname, String lastname,String email, String pass, String confirmpass) async {
//   var response = await http.post(Uri.https('quizaccounting.adiyogitechnology.com:4009/v1', '/register'), body:{
//     "firstName": firstname, "lastName":lastname, "email":email, "password":pass, "passwordConfirm":confirmpass, "roleId" : "5f4b48ae0df2531f0acc8d43"
//   },
//   );
//   print("Submit Called");
//
//   var data = response.body;
//   print(data);
//
//   if (response.statusCode==200){
//     String responseStr = response.body;
//
//   }
//   else print("Data not Found");
// }