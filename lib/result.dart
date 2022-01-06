import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api/api_config.dart';
import 'bottombar.dart';

class Result extends StatefulWidget {
  final QuizId;
  const Result(this.QuizId);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  var preferences;
  var token,userId,QuizId,Question,question_id,lastQuestion,marks;

  Future getToken() async{
    preferences = await SharedPreferences.getInstance();
    var savedValue = preferences.getString('token');
    var personId = preferences.getString('personId');
    var quizId = preferences.getString('quizid');
    print("Saved Value DB"+ savedValue);

    setState(() {
      token = savedValue;
      userId = personId;
      QuizId = quizId;


    });
    showResults(token,userId);
  }

  @override
  void initState() {
    super.initState();

    getToken();

  }
bool loading = true;
var marks01;
  Future<void> showResults(token,userId) async{
    String url = ApiConfig().baseurl + ApiConfig().api_post_result;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: " + token.toString());
    Map<String, String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token,
      'Content-Type': 'application/json'
      // "userId":userId
    };
    String body = jsonEncode({
      "userId": userId,
      "quizId":widget.QuizId
    });
    print("Body Start Quiz" + body);
    var response =
    await http.post(Uri.parse(requestUrl), body: body, headers: headers);
    print("Question API Res" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {

      if (jsonData['status'] == 200) {
        loading= false;
        // Fluttertoast.showToast(
        //     msg: jsonData["message"] + "API Hitt",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // print("Token: "+token);
        var num =jsonData['data']['result'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          marks01 = num;
        });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Result(marks)));
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0,
        // double
        automaticallyImplyLeading: false,
        title: Text('Result Screen',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: Builder(
          builder: (context) =>
              IconButton(padding: const EdgeInsets.all(18),
                icon: Image.asset('assets/Home/Vector.png'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) =>  bottomBar(bottom: 0)),
                          (Route<dynamic> route) => false);
                },
              ),
        ),

      ),

      body: SingleChildScrollView(
          child:loading == true? Center(
            child: Container(
                margin: EdgeInsets.only(top: 100),
                child: CircularProgressIndicator()),
          ): Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image : new DecorationImage(
                    image: new ExactAssetImage('assets/result/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Image.asset('assets/result/pic.png'),
              ),
              Container(

                margin: EdgeInsets.only(top: 55),
                child: Text('You have earn ${marks01[0]['marks'].toString()} points',style: TextStyle(
                  fontSize: 24,
                ),),
              ),
              SizedBox(
                height: 25,
              ),

            ],
          )
      ),

    );
  }
}
// numResults[0]['marks'].toString()