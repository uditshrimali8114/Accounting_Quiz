import 'dart:convert';
import 'package:accounting_quiz/Api/api_config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:accounting_quiz/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var token,userId,QuizId,Question,question_id,lastQuestion,marks;
  bool loading = true;
  String ? jsonFruits;
  double? _progressValue = 0.0;
  var preferences;
  String? jsonTags;
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
      getQuestionStates(token,userId);
      startQuiz(token, userId, QuizId);

    });
  }

  @override
  void initState() {
    super.initState();

    getToken();

  }
  List<String> labelArr = [];
  List<String> nameArr = [];
  List<String> debitArr = [];
  List<String> creditArr = [];

  int? numQues,submitCount=0;

  List<Tag> tags = [];
  final TextEditingController label = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController debit = TextEditingController();
  final TextEditingController credit = TextEditingController();

  // if(lastQuestion==0){}
  Future<void> getQuestionStates(token,userId) async {

    String url = ApiConfig().baseurl + ApiConfig().api_question_states + "?userId=" + userId;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token
    };

    var response =
    await http.get(Uri.parse(requestUrl), headers: headers );
    print("Question States res" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Profile Api result" + response.body);
    print("Header" + headers.toString());
    print("requestUrl asdf"+requestUrl);
    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        loading = false;
        int num= jsonData['data']['totalQuestion'];
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {

          numQues = num;
          //_progressValue = numQues== null? 1 : 1/numQues!;
        });
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

  Future<void> startQuiz(token,userId,QuizId) async {
     String url = ApiConfig().baseurl + ApiConfig().api_start_quiz;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token,
      'Content-Type': 'application/json'
      // "userId":userId
    };
    String body = jsonEncode({
      "quizId": QuizId,
      "userId": userId
    });
    print("Body Start Quiz" + body);
    var response =
    await http.post(Uri.parse(requestUrl),body:body, headers: headers);
    print("Question API Res" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        loading = false;
        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "API Hitt",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // print("Token: "+token);
        String ques= jsonData['data']['question'];
        String quesId= jsonData['data']['questionId'];
        var lastques= jsonData['data']['lastQuestion'];

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {

          lastQuestion = lastques;
                  labelArr.clear();
                  nameArr.clear();
                  debitArr.clear();
                  creditArr.clear();
                  tags.clear();
          question_id = quesId;
          Question = ques.replaceAll("<p>","") .replaceAll("</p>", "").replaceAll("<strong>", "")
              .replaceAll("<br>", "").replaceAll("</strong>", "")
              .replaceAll("</br>", "").toString();
        });
        print("Last ques "+lastQuestion.toString());

        if(lastQuestion==1){
                  completeQuiz(token, userId);
        }

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Quiz()));
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



  Future<void> _submitAnswer(token,userId,QuizId,tags,question_id) async {

    // String url = baseUrl + profile;
    var requestUrl = ApiConfig().baseurl+ ApiConfig().api_submit_ans;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      ApiConfig().x_api_key:
      ApiConfig().x_api_key_value,
      'Authorization': token,
      'Content-Type': 'application/json'
      // "userId":userId
    };
    String body = jsonEncode({
      "quizId": QuizId,
      "userId": userId,
      "questionId": question_id,
      "resumeQuiz": 0,
      "submitAnswer":tags
    });
    print("Submit Quiz Body" + body);
    var response =
    await http.put(Uri.parse(requestUrl),body:body, headers: headers);
    print("Submit Quiz Res" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        print("submit_success"+lastQuestion.toString());


          startQuiz(token,userId,QuizId);

        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "API Hitt",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        print("Token: "+token);

      } else {
        print("submit_error"+lastQuestion);
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

  Future<void> completeQuiz(token,userId) async{
    String url = ApiConfig().baseurl + ApiConfig().api_complete_quiz;
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
      "quizId": QuizId
    });
    print("Body Start Quiz" + body);
    var response =
    await http.put(Uri.parse(requestUrl), body: body, headers: headers);
    print("Question API Res" + response.body);
    var jsonData = jsonDecode(response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        print("complete_success");
        // showResults(token,userId);
        // Fluttertoast.showToast(
        //     msg: jsonData["message"] ,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        //
        // showResults(token,userId,QuizId);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Result(QuizId)));
      } else {
        print("complete_error");
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
  String? marks01;
  Future<void> showResults(token,userId,QuizId) async{
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
      "quizId": QuizId
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

  Future<void> getName(token) async {

    String url = ApiConfig().baseurl + ApiConfig().api_label_code + label.text.toString();
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
        // Fluttertoast.showToast(msg: "Success",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // print("Token: "+token);
        String firname01= jsonData['data']['name'];
        // String lastname01= jsonData['data']['lastName'];
        // String email01= jsonData['data']['email'];
        // String personId= jsonData['data']['_id'];
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          name.text = firname01 ;
          // lastName = lastname01;
          // email = email01;
          // Id = personId;
          // prefs.setString("personId", Id);
          // prefs.setString("firstname01", firstname.toString());
          // prefs.setString("lastName01", lastName.toString());
          // prefs.setString("email01", email.toString());

        });
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



  String? newDate ;
  // bool flag= true;
  // bool flag1= true;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        newDate = selectedDate.toLocal().toString().split(' ')[0];

        labelArr.add(" ");
        nameArr.add(newDate.toString());
        debitArr.add(" ");
        creditArr.add(" ");
        newDate= null;

      });
  }
  List<String> allData = [];

  // void datainList() {
  //   for(int i = 0; i==labelArr.length;i++){
  //     allData.addAll([labelArr[i],nameArr[i],debitArr[i],creditArr[i]]);
  //
  //   }
  //   json.encode(allData);
  // }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Please Enter Answer',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
  var size,height,width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0,
        // double
        automaticallyImplyLeading: false,
        title: Text('Quiz',
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
        child:loading == true? Center(
          child: Container(
              margin: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator()),
        ): Container(
          height: height*0.90,
          child: Column(
            children: [
              Container(
                // height: 20,
                margin: EdgeInsets.all(10),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xFF404040),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe81818)),
                  value: _progressValue,
                )
              ),
              Container(
                height: 20,
                padding: EdgeInsets.only(left:10, right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1'),
                    Text('$numQues'== null? "-":'$numQues'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                // padding: EdgeInsets.only(left:20, right:20),
                // height: 80,
                // width: 330,
                // color: Colors.amber,

                child: Card(

                  child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Html(data:Question.toString())),
                ),
              ),
              //Add Row Button
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15),
                  child: FlatButton(
                    child:  const Text('Add Date', style: TextStyle(fontSize: 15.0,color: Colors.white),),
                    color:  Color(0xFF404040),
                    textColor: Colors.white,
                    onPressed: () {_selectDate(context);
                      setState(() {

                      });

                      // setState(() {
                      // row = row+1;
                      // print("Row" + row.toString());
                      // });
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),

                ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: FlatButton(
                      child:  const Text('Add values', style: TextStyle(fontSize: 15.0,color: Colors.white),),
                      color:  Color(0xFF404040),
                      textColor: Colors.white,
                      onPressed: () {
                        showDialog(context: context,
                            builder: (context){
                              return AlertDialog(
                                // backgroundColor: Color(0xFFe81818),
                                content: Container(
                                  height: height*.50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //Rockstar
                                    children: [
                                      TextFormField(
                                        controller: label,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Account",
                                        ),
                                      ),
                                      TextFormField(
                                        onTap: (){
                                          getName(token);
                                        },
                                        controller: name,
                                        decoration: InputDecoration(
                                            hintText: "Label"
                                        ),
                                      ),
                                      TextFormField(

                                        // enabled:  flag1,
                                        keyboardType: TextInputType.number,
                                        controller: debit,
                                        decoration: InputDecoration(
                                            hintText: "Debit"
                                        ),
                                      ),
                                      TextFormField(
                                        // enabled:  flag,
                                        keyboardType: TextInputType.number,
                                        controller: credit,
                                        decoration: InputDecoration(
                                            hintText: "Credit"
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: (){
                                          setState(() {
                                            labelArr.add(label.text);
                                            nameArr.add(name.text);
                                            debitArr.add(debit.text.isEmpty ? "0": debit.text );
                                            creditArr.add(credit.text.isEmpty? "0": credit.text);

                                            // labelArr1.add('"label":'+label.text);
                                            // nameArr1.add('"name": "${name.text}"');
                                            // debitArr1.add('"Debit":'+debit.text);
                                            // creditArr1.add('"credit":'+credit.text);
                                          });
                                          Navigator.pop(context);
                                          label.clear();
                                          name.clear();
                                          debit.clear();
                                          credit.clear();
                                        },
                                        child: Text("Add Row",style: TextStyle(color: Colors.white),),
                                        color:Color(0xFF404040),

                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => Dashboard()));
                      },

                    ),

                    ),
                ],
              ),

              //Answer Table
              Container(
                  height: 20,
                margin: EdgeInsets.all(15),
                  alignment: Alignment.bottomLeft,
                  child: Text("Answer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
              Container(
                height: 40,
                margin: EdgeInsets.only(left: 5,right: 5),
                  color:Color(0xff414141),
                  child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Account",style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text("Label",style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text("Debit",style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text("Credit",style: TextStyle(color: Colors.white,fontSize: 16),),

                ],
              ) ),

              Expanded(
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: labelArr.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Container(
                        height: 35,
                        decoration:BoxDecoration(
                            border: Border.all(width: 1)
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 5,bottom: 5),
                                alignment: Alignment.center,
                                width:width*0.23,
                                child: Text(labelArr[Index])),
                            Container(
                              color: Colors.black,
                              width: 1,
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 5,bottom: 5),
                                width:width*0.23,
                                child: Text(nameArr[Index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,)),
                            Container(
                              color: Colors.black,
                              width: 1,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5,bottom: 5),
                                alignment: Alignment.center,
                                width:width*0.23,
                                child: Text(debitArr[Index],)),
                            Container(
                              color: Colors.black,
                              width: 1,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5,bottom: 5),
                                width:width*0.23,
                                alignment: Alignment.center,
                                child: Text(creditArr[Index])),
                          ],
                        ),
                      );
                    }
                ),
              ),
              Container(
                width: 350,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    // Container(
                    //   width:70,
                    //   child: TextFormField(
                    //     controller: label,
                    //     decoration: InputDecoration(
                    //       hintText: "Label"
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width:70,
                    //   child: TextFormField(
                    //     onTap: (){
                    //       getName(token);
                    //     },
                    //     controller: name,
                    //     decoration: InputDecoration(
                    //         hintText: "Name"
                    //     ),
                    //   ),
                    // ),
                    // Container(width:70,
                    //   child: TextFormField(
                    //     controller: debit,
                    //     decoration: InputDecoration(
                    //         hintText: "Debit"
                    //     ),
                    //   ),
                    // ),
                    // Container(width:70,
                    //   child: TextFormField(
                    //     controller: credit,
                    //     decoration: InputDecoration(
                    //         hintText: "Credit"
                    //     ),
                    //   ),
                    // ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 50, 5, 20),
                width: 320,
                child: FlatButton(
                  height: 40,
                  child:  Text('Submit', style: TextStyle(fontSize: 18.0,color: Colors.white),),
                  color: Color(0xFFe81818),
                  textColor: Colors.white,
                  onPressed: () {

                    setState(() {

                    });

                    for(int i = 0 ;i<labelArr.length;i++){
                      print(i);
                      tags.addAll([Tag(labelArr[i],nameArr[i],debitArr[i],creditArr[i])]);
                      print("tags"+tags.toString());

                    }
                    jsonTags= jsonEncode(tags);
                    print("====="+jsonTags.toString());
                    if (nameArr.length==0){
                      showToast();
                    }else{

                      _submitAnswer(token,userId,QuizId,tags,question_id);

                      submitCount = submitCount!+1;
                      _progressValue = submitCount!/numQues!;

                      // if(numQues!<submitCount!)
                      // {
                      //
                      //   _submitAnswer(token,userId,QuizId,tags,question_id);
                      //   print("Helonnnnnnnn======");
                      // }
                      // else{
                      //   print("Helonnnnnnnn======Else");
                      // }


                    }

                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
              //
              // FlatButton(
              //   height: 40,
              //   child:  Text('right', style: TextStyle(fontSize: 18.0,color: Colors.white),),
              //   color: Color(0xFFe81818),
              //   textColor: Colors.white,
              //   onPressed: () {
              //     showDialog(context: context,
              //         builder: (BuildContext context){
              //       return AlertDialog(
              //        backgroundColor: Color(0xff16c698),
              //         content: Container(
              //           height: 200,
              //           child: Column(
              //             children: [
              //               Container(
              //                 height: 90,
              //                 width: 90,
              //                 padding: EdgeInsets.all(8.0),
              //                 margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              //                 decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: Colors.white,
              //                     border: Border.all(
              //                       color: Color(0xFF5cd8b8),
              //                       width: 8,
              //                     )
              //                 ),
              //                 child: Image.asset('assets/popup/right.png',),
              //               ),
              //               Container(
              //                 margin: EdgeInsets.only(top: 30),
              //                 child: Text('Congratulations',style: TextStyle(color: Colors.white,fontSize: 30),),),
              //               Container(
              //                 // margin: EdgeInsets.only(top: 30),
              //                 child: Text('Answer is Right',style: TextStyle(color: Colors.white,fontSize: 20),),),
              //             ],
              //           ),
              //         ),
              //       );
              //         }
              //         );
              //   },
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(2)
              //   ),
              // ),
              // FlatButton(
              //   height: 40,
              //   child:  Text('Wrong', style: TextStyle(fontSize: 18.0,color: Colors.white),),
              //   color: Color(0xFFe81818),
              //   textColor: Colors.white,
              //   onPressed: () {
              //     showDialog(context: context,
              //         builder: (BuildContext context){
              //           return AlertDialog(
              //             backgroundColor: Color(0xffe81818),
              //             content: Container(
              //               height: 200,
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     height: 90,
              //                     width: 90,
              //                     padding: EdgeInsets.all(8.0),
              //                     margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              //                     decoration: BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         color: Colors.white,
              //                         border: Border.all(
              //                           color: Color(0xFFec5d5e),
              //                           width: 8,
              //                         )
              //                     ),
              //                     child: Image.asset('assets/popup/wrong.png',),
              //                   ),
              //                   Container(
              //                     margin: EdgeInsets.only(top: 30),
              //                     child: Text('Ohhhnooo',style: TextStyle(color: Colors.white,fontSize: 30),),),
              //                   Container(
              //                     // margin: EdgeInsets.only(top: 30),
              //                     child: Text('Answer is Wrong',style: TextStyle(color: Colors.white,fontSize: 20),),),
              //                 ],
              //               ),
              //             ),
              //           );
              //         }
              //     );
              //   },
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(2)
              //   ),
              // ),
            ],
          ),
        ),
      ),

    );
  }

  progressValue(submit){

  }


}
class Tag {
  String name,quantity,debit,credit;
  //String name;


  Tag(this.name, this.quantity,this.debit,this.credit);
  //Tag(this.name);

  Map toJson() => {
    'label': name,
    'name': quantity,
    'debit': debit,
    'credit': credit,

  };
}