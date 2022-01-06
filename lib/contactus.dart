import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api/api_config.dart';
import 'bottombar.dart';
import 'dashboard.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  TextEditingController _message = TextEditingController();

  var baseUrl = ApiConfig().baseurl;
  var Contact =ApiConfig().api_contactus;
  String? studId,token;
  Future<void>getId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id =prefs.getString("personId");
    String SavedValue =prefs.getString("token");
    setState(() {
      studId = id;
      token = SavedValue;
    });
  }
  @override
  void initState() {
    super.initState();
    getId();

  }

  Future<void> sendMessage(studId,token) async {


    String url = baseUrl + Contact;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);

    Map<String,String> headers = {
      ApiConfig().x_api_key: ApiConfig().x_api_key_value,
      "Authorization": token,
      'Content-Type': 'application/json'
    };

    String body = jsonEncode({

      "userId": studId,
      "description":_message.text

    });
    print("Body "+body.toString());
    var response =
    await http.post(Uri.parse(requestUrl), body: body, headers: headers);
    print("fvdshfbhgdf" + response.body);
    var jsonData = jsonDecode(response.body);
    print("COntact Response" + response.body);
    print("Header" + headers.toString());

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
        var Bottom = 0;
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => bottomBar(bottom: Bottom)));


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color(0xFFe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0,
        // double
        automaticallyImplyLeading: false,
        title: Text('Contact us',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: Builder(
          builder: (context) =>
              IconButton(padding: const EdgeInsets.all(18),
                icon: Image.asset('assets/Home/Vector.png'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),

      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Image.asset('assets/contact/01.png'),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 10),
                alignment: Alignment.centerLeft,
                child: Text('Express Yourself !',style: TextStyle(
                  fontSize: 20,
                ),),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: TextField(
                  controller: _message,
                  decoration: InputDecoration(
                    hintText: 'Text Here',
                    labelStyle: TextStyle(color: Color(0xFF606060) ),
                    fillColor: Colors.white,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFe81818), width: 2.0),
                      // #c01211
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  maxLength: 250,
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                width: 300,
                child: FlatButton(
                  // height: 50,
                  child:  Text('Send', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                  color: Color(0xFFe81818),
                  textColor: Colors.white,
                  onPressed: () {
                    sendMessage(studId,token);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                  ),
                ),
              ),

            ],
          )
      ),

    );
  }
}