import 'dart:convert';

import 'package:accounting_quiz/Api/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyStats extends StatefulWidget {
  const MyStats({Key? key}) : super(key: key);

  @override
  State<MyStats> createState() => _MyStatsState();
}


class _MyStatsState extends State<MyStats> {
  var preferences;
  List mainData = [];
  bool loading = true;
  String? firName,lasName,email,profilePic, Id,token;
  Future getData() async{
    preferences = await SharedPreferences.getInstance();
    var getFirName = preferences.getString('firstname01');
    var getLasName = preferences.getString('lastName01');
    var getEmail = preferences.getString('email01');
    var getprofilepic = preferences.getString('profilePic');
    var getpersonId = preferences.getString('personId');
    var savedValue = preferences.getString('token');
    setState(() {
      token = savedValue.toString();
      firName = getFirName.toString();
      lasName = getLasName.toString();
      email = getEmail.toString();
      profilePic = getprofilepic.toString();
      Id = getpersonId.toString();

    });
    getResults(token,Id);

    print("First Name > $firName LastName > $lasName Email > $email");
  }
  @override
  void initState() {
    super.initState();
    getData();

  }
var result,date,time,marks01,numResults,data01;
  Future<void> getResults(token,Id) async {

    String url = ApiConfig().baseurl + ApiConfig().api_get_resultList+"/$Id";
    var requestUrl = url;
    print("myStatus url " + requestUrl);
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
        var res =jsonData['data'][0]['result'][0]['completed_date'];
        var num =jsonData['data'][0]['result'];
        var data =jsonData['data'];
        var mar =jsonData['data'][0]['result'][0]['marks'];
        setState(() {
          mainData.addAll(jsonData['data']);
          // result= res.toString();
          // marks01 = mar;
          // data01 = data;
          // numResults = num;
          // date = result.split('T');
          // time = date[1].toString().split('.');
          loading = false;
        });
        print(" Result : "+date.toString()+"date "+time.toString());
        print(" Result : "+mainData.length.toString());

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
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(

        backgroundColor:const Color(0xffe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0, // double
        automaticallyImplyLeading: false,
        title: Text('My Stats',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold) ,),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(padding: const EdgeInsets.all(18),
            icon: Image.asset('assets/Home/Vector.png'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: Column(
          children:  [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(profilePic!),
                  // backgroundImage:NetworkImage(profilepic),
                ),
                title: Text('$firName $lasName',style:TextStyle(fontSize: 20),maxLines: 1,),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$email',style:TextStyle(fontSize: 16),maxLines: 1,)
                  ],
                ),
                isThreeLine: true,
              ),
            ),

            loading == true? Center(
              child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator()),
            ): Container(
              height: height*0.90,
              child: Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mainData.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Container(
                        // height: 35,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                              width: width*0.90,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: Color(0XFFededed),
                                        height: 60,
                                        width: 60,
                                        child: Image.asset('assets/MyStats/calander.png',),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(mainData[Index]['result'][0]['completed_date'].split('T')[0].toString(), style: TextStyle(fontSize: 18,color: Color(0xff4a4a4a),),),
                                            Text(mainData[Index]['result'][0]['completed_date'].split('T')[1].split('.')[0].toString(),style: TextStyle(color: Color(0xff8f8f8f),fontSize: 14 ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    height: 55,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfad0d1),
                                      border: Border.all(
                                        color: Color(0xFFf06083),
                                        width: 1,
                                      ),
                                      borderRadius: new BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                child: Image.asset('assets/MyStats/badge.png')),
                                          ],
                                        ),
                                        Container(
                                          // margin:EdgeInsets.all(5),
                                          height: 55,
                                          width: 1,
                                          color: Color(0xFFf06083),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                margin:EdgeInsets.only(left: 10),
                                                child: Text('Win Points')),
                                            Text(mainData[Index]['result'][0]['marks'].toString(),style: TextStyle(fontSize: 24,color: Color(0xffe21a1a),))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
