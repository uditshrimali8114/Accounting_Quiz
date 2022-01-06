import 'dart:convert';

import 'package:accounting_quiz/Api/api_config.dart';
import 'package:accounting_quiz/demo.dart';
import 'package:accounting_quiz/login.dart';
import 'package:accounting_quiz/my_stats.dart';
import 'package:accounting_quiz/quiz.dart';
import 'package:accounting_quiz/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'contactus.dart';
import 'myprofile.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var token;
  var firstname,email, profilepic,lastName,QuizId,Id,profilePic;
  var preferences;
  bool loading = true;
  Future getToken() async{
    preferences = await SharedPreferences.getInstance();
    var savedValue = preferences.getString('token');
    var proPic = preferences.getString('profilepic');
    print("Saved Value DB"+ savedValue);
    setState(() {
      token = savedValue;
      getProfileData(token);
      profilepic = proPic;
      print("Profile link "+profilepic);
    });
  }

  var baseUrl = ApiConfig().baseurl;
  var profile = ApiConfig().api_profile;
  @override
  void initState() {
    super.initState();
    getToken();

  }

  Future<void> getProfileData(token) async {

    String url = baseUrl + profile;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token
    };

    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);
    print("Profile api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Profile Api result" + response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        print("Token: "+token);
       String firname01= jsonData['data']['firstName'];
       String lastname01= jsonData['data']['lastName'];
       String email01= jsonData['data']['emailAddress'];
       String personId= jsonData['data']['_id'];
       String propic= jsonData['data']['profilePhoto'];
       SharedPreferences prefs = await SharedPreferences.getInstance();
       setState(() {
         firstname = firname01;
         lastName = lastname01;
         email = email01;
         Id = personId;
         profilePic = propic;
         loading = false;

         prefs.setString("personId", Id);
         prefs.setString("firstname01", firstname.toString());
         prefs.setString("lastName01", lastName.toString());
         prefs.setString("email01", email.toString());
         prefs.setString("profilePic", profilePic.toString());

       });
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

  Future<void> createQuiz(token,Id) async {

    // String url = baseUrl + profile;
    var requestUrl = ApiConfig().baseurl+ApiConfig().api_create_quiz;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    String body = jsonEncode({
      "userId": Id
    });
    print('Create Quiz Body' + body);
    var response =
    await http.post(Uri.parse(requestUrl),body:body, headers: headers);
    // print("Profile api" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Quiz Create " + response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "API Hitt",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // print("Token: "+token);
        String quizId= jsonData['data']['_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          QuizId = prefs.setString("quizid", quizId);
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Quiz()));
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
      appBar: AppBar(

        backgroundColor: Color(0xFFe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0, // double
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          height: 55,
            child: Image.asset('assets/Splash/trainer.png',height: 55,
        ),
        // centerTitle: true,
        // padding: Builder(
        //   builder: (context) => IconButton(padding: const EdgeInsets.all(18),
        //     icon: Image.asset('assets/Home/Vector.png'),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //   ),
        // ),

      ),
      ),

      body: SingleChildScrollView(
          child: Center(
            child:loading == true? Center(
              child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator()),
            ): Container(
              width: 360,
              alignment: Alignment.center,
              child: Column(
                children:  [
              Card(
              child: ListTile(
              leading: CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(profilePic),
                // backgroundImage:NetworkImage(profilepic),
              ),
        title: Text('$firstname $lastName',style:TextStyle(fontSize: 20),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: false,),
        subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email??"-",style:TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,)
              ],
        ),
        isThreeLine: true,
      ),
              ),

                  GestureDetector(
                    onTap: (){
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Quiz()));
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyStats()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 7.5),
                              width: double.maxFinite,
                              // height: 105,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: ExactAssetImage('assets/Home/bg1.jpg'),
                                    ),
                                  ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFFfc8285),
                                      width: 8,
                                    )
                                ),
                                child: Image.asset('assets/Home/stats.png',),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('My Stats', style: TextStyle(fontSize: 24,color: Color(0xfffefefd),fontWeight: FontWeight.bold),),

                                Text('Following your performances',style: TextStyle(color:Color(0xfffefefd),fontSize: 14 ),),
                                Text(' and visualize your results',style: TextStyle(color:Color(0xfffefefd),fontSize: 14 ),),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyProfile()));
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => MyStatefulWidget()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 7.5),
                      width: double.maxFinite,
                      // height: 105,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: ExactAssetImage('assets/Home/bg2.jpg'),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF5dd7b8),
                                      width: 8,
                                    )
                                ),
                                child: Image.asset('assets/Home/profile.png',),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('My Profile', style: TextStyle(fontSize: 24,color: Color(0xfffefefd),fontWeight: FontWeight.bold),),

                                Text('Edit and update your profile',style: TextStyle(color:Color(0xfffefefd),fontSize: 14 ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ContactUs()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 7.5),
                      width: double.maxFinite,
                      // height: 105,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: ExactAssetImage('assets/Home/bg3.jpg'),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF61c0f0),
                                      width: 8,
                                    )
                                ),
                                child: Image.asset('assets/Home/contact.png',),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Contact us', style: TextStyle(fontSize: 24,color: Color(0xfffefefd),fontWeight: FontWeight.bold),),

                                Text('Send us an email',style: TextStyle(color:Color(0xfffefefd),fontSize: 14 ),),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: FlatButton(
                      height: 50,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // padding: EdgeInsets.all(5),
                            height: 30,
                            // width: 45,
                            child: Image.asset('assets/Home/play.png'),
                          ),
                          Text('Play', style: TextStyle(fontSize: 18.0,color: Color(0xFF404040)),),

                        ],
                      ),
                      color: Color(0xFFefefef),
                      onPressed: () {
                        createQuiz(token,Id);
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => Quiz()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: FlatButton(
                      height: 50,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Logout', style: TextStyle(fontSize: 18.0,color: Color(0xFF404040)),),

                        ],
                      ),
                      color: Color(0xFFefefef),
                      onPressed: () {
                        preferences.clear();
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Login()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
      ),

    );
  }
}



