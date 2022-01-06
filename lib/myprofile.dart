import 'package:accounting_quiz/Api/api_config.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:accounting_quiz/dashboard.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottombar.dart';
enum SingingCharacter { Male, Female, Undisclosed }

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  String? _selectedlanguage = 'any time';
  String _singleValue = "Text alignment right";
  var _formKey = GlobalKey<FormState>();
  List <String> countryItems = [
    'India',
    'Spain'
  ] ;
  List <String> stateItems = [
   'Rajasthan',
    'Punjab'
  ] ;
  List <String> cityItems = [
    'Jodhpur',
    'Jaipur'
  ] ;

  var countryValue ;
  var stateValue ;
  var cityValue ;
  File? imageCapture;
  bool loading = true;
  var firstname,email, profilepic,lastName,mob,oldProfilePic,firname01,lastname01,email01,mobile,city01,gender,state01,country01,city01Id,state01Id,country01Id;
var selectedCountryId;
var selectedStateId;
var selectedCityId;
  var preferences;
  var token;
  var getCity;
  var getGender;
  List countryList = [];
  List stateList = [];
  List cityList = [];
  var profile = ApiConfig().api_profile;
  var baseUrl = ApiConfig().baseurl;
  var country = ApiConfig().api_countries;
  var state = ApiConfig().api_states;
  var updateProfile = "/profile-update";
  get jsonData => null;

  Future getToken() async{
    preferences = await SharedPreferences.getInstance();
    var savedValue = preferences.getString('token');
    // var proPic = preferences.getString('profilepic');
    print("Saved Value DB"+ savedValue);
    setState(() {
      // oldProfilePic = proPic;
      token = savedValue;
      getProfileData(token);
      countryData(token);
    });
  }

  // String city = cityValue.toString();
  @override
  void initState() {
    super.initState();
    getToken();
 }



  // void _submit() {
  //
  //     UpdateProfile(token);
  //
  // }
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
    print("Profile Api result1" + response.body);
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
        print("Token: "+token);
        firname01= jsonData['data']['firstName'];
        lastname01= jsonData['data']['lastName'];
        email01= jsonData['data']['emailAddress'];
        mobile = jsonData['data']['phoneNo'];
        city01Id =jsonData['data']['city'];
        state01Id =jsonData['data']['state'];
        country01Id =jsonData['data']['country'];
        country01 =jsonData['data']['countryName'];
        city01 =jsonData['data']['cityName'];
        state01 =jsonData['data']['stateName'];
        gender =jsonData['data']['gender'];
        String propic= jsonData['data']['profilePhoto'];
        setState(() {
          firstname = firname01;
          lastName = lastname01;
          email = email01;
          mob = mobile;
          getCity = city01;
          getGender = gender;
          oldProfilePic = propic;
          loading = false;
          _firstName.text = firstname;
          _lastName.text = lastName;
          _phone.text = mob;
          _email.text = email;

        });
        _RadioValue(getGender);
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


  int radioValue = -1;
  var _gender;
  void _handleRadioValueChanged(value) {
    if (value == 0){
      setState(() {
        radioValue = value;
        _gender = 'Male';
        print(_gender);
    }
    );}
    if(value == 1){
      setState(() {
        radioValue = value;
        _gender = 'Female';
        print(_gender);
    }
      );
  } if(value == 2){
      setState(() {
        radioValue = value;
        _gender = 'Undisclosed';
        print(_gender);
      }
      );
    }
      }
  void _RadioValue(getGender){
    if(getGender== "Male"){
      setState(() {
        radioValue = 0;
      });
    }
    if(getGender== "Female"){
      setState(() {
        radioValue = 1;
      });
    }
    if(getGender== "Undisclosed"){
      setState(() {
        radioValue = 2;
      });
    }
  }

  void selectFrontCamera() async {
    print("imagepicker ");
    var imagepicker = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      imageCapture = imagepicker as File;
    });
    print("imagepicker " + imagepicker.path);
  }
  // imageCapture!,File imageFile,
  Upload(token) async {


    String url = ApiConfig().baseurl + ApiConfig().api_updateProfile;
    print("baseUpdate "+url);
    Map<String,String> headers = {
      'x-api-key': 'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      "firstName": _firstName.text == ""? firstname : _firstName.text,
      "lastName": _lastName.text == ""? lastName : _lastName.text,
      "emailAddress": _email.text == ""? email : _email.text,
      "phoneNo": _phone.text == ""? mob : _phone.text,
      "country":selectedCountryId== null? "": selectedCountryId.toString(),
      "state":selectedStateId== null? "": selectedStateId.toString(),
      "city":selectedCityId== null? "": selectedCityId.toString(),
      "gender": _gender == null ? "Male" : _gender
    });

    if (imageCapture == null) {
      // request.files.add(await http.MultipartFile.fromPath('profilePhoto', ));
      // request.headers.addAll(headers);
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'profilePhoto', imageCapture!.path));
    }

      //request.files.add(await http.MultipartFile.fromPath('profilePhoto', imageCapture!.path== null?"":imageCapture!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var Bottom = 0;
      Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => bottomBar(bottom: Bottom)));
    }
    else {
      print(response.reasonPhrase);
    }
  }


  @override
  Widget build(BuildContext context) {

    SingingCharacter? _character = SingingCharacter.Male;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color(0xFFe81818),
        foregroundColor: Colors.white,
        toolbarHeight: 70.0,
        // double
        automaticallyImplyLeading: false,
        title: Text('My Profile',
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
        ): Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: imageCapture == null? DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(oldProfilePic),
                      ):DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: FileImage(File(imageCapture!.path)),
                      ),
                      border: Border.all(
                        color:Colors.white,
                        width: 8,
                      )
                  ),
                  child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        //Container
                        Positioned(
                            top: 65,
                            left: 75,
                            right: 1,
                            child: GestureDetector(
                              onTap: selectFrontCamera,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFc01211),
                                ),
                                child: Icon(Icons.camera_alt,color: Colors.white),
                              ),
                            )),
                      ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15,top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text("First Name",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: _firstName,
                      decoration: InputDecoration(
                        hintText: firstname ==""?"Enter name":firstname,
                      labelStyle: TextStyle(color: Color(0xFF606060) ),
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
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Enter First Name!';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15,top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text("Last Name",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: _lastName,
                    decoration: InputDecoration(
                      hintText: lastName==""?"Enter last name":lastName,
                      labelStyle: TextStyle(color: Color(0xFF606060) ),
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
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Enter Last Name!';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15,top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text("Your Number",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(
                      // labelText: "Your Number",
                      hintText: mob==""?"Enter mobile no.":mob,
                      labelStyle: TextStyle(color: Color(0xFF606060) ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFe81818), width: 2.0),
                        // #c01211
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      //Validator
                    },
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Enter Mobile Number';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15,top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text("Email Address",style: TextStyle(color:Color(0xFF525252)),),),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      // labelText: "Email Address",
                      hintText: email==""?"Enter email address":email,
                      labelStyle: TextStyle(color: Color(0xFF606060) ),
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
                    // validator: (value) {
                    //   if (value!.isEmpty ||
                    //       !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    //           .hasMatch(value)) {
                    //     return 'Enter a valid email!';
                    //   }
                    //   return null;
                    // },
                  ),
                ),


                Column(
                  children: [
                    Container(
                      // width: size.width * 0.70,
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(country01==""?"Select country":country01.toString(),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400)),
                        value: countryValue,
                        items: countryList.map((explist) {
                          print("array " + explist.toString());
                          return DropdownMenuItem(
                            value: explist['name'],
                            child: Text(explist['name']),
                            onTap: () {
                              selectedCountryId = explist['_id'];
                              print("country"+selectedCountryId);
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          fetchState(selectedCountryId);
                          setState(() {
                            countryValue = value.toString();
                            if (selectedCountryId == 0) {
                              selectedCountryId = null;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      // width: size.width * 0.70,
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(state01==""?"Select state":state01.toString(),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400)),
                        value: stateValue,
                        items: stateList.map((explist) {
                          print("array " + explist.toString());
                          return DropdownMenuItem(
                            value: explist['name'],
                            child: Text(explist['name']),
                            onTap: () {
                              selectedStateId = explist['_id'];
                              print("country1"+selectedStateId);
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          fetchCity(selectedStateId);
                          setState(() {
                            stateValue = value.toString();
                            if (selectedStateId == 0) {
                              selectedStateId = null;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      // width: size.width * 0.70,
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(city01==""?"Select city":city01.toString(),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400)),
                        value: cityValue,
                        items: cityList.map((explist) {
                          print("array " + explist.toString());
                          return DropdownMenuItem(
                            value: explist['name'],
                            child: Text(explist['name']),
                            onTap: () {
                              selectedCityId = explist['_id'];
                              print("country2"+selectedCityId);
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          fetchCity(selectedCityId);
                          setState(() {
                            cityValue = value.toString();
                            if (selectedCityId == 0) {
                              // selectedCityId = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),

               SizedBox(
                 height: 15,
               ),

               Row(children: [
                 Container(
                   margin: EdgeInsets.only(top: 10,left: 15),
                     child: Text('Gender',style: TextStyle(fontSize: 16,color: Color(0xFF606060)),))

               ],),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                      activeColor: Color(0xFFe81818),
                      value: 0,
                      groupValue: radioValue,
                      onChanged: _handleRadioValueChanged),
                  Text('Male'),
                  Radio(
                      activeColor: Color(0xFFe81818),
                      value: 1,
                      groupValue: radioValue,
                      onChanged: _handleRadioValueChanged),
                  Text('Female'),
                  Radio(
                      activeColor: Color(0xFFe81818),
                      value: 2,
                      groupValue: radioValue,
                      onChanged: _handleRadioValueChanged),
                  Text('Undisclosed'),
                ]),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                  width: 300,
                  child: FlatButton(
                    height: 50,
                    child:  Text('Save Change', style: TextStyle(fontSize: 25.0,color: Colors.white),),
                    color: Color(0xFFe81818),
                    textColor: Colors.white,
                    onPressed: () {
                      Upload(token);
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Dashboard()));
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
  Future<void> countryData(token) async {

    String url = baseUrl + country;
    var requestUrl = url;
    print("listEmployeeurl--> " + requestUrl);
    print("Token: "+token.toString());
    Map<String,String> headers = {
      'x-api-key':
      'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
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
        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "API Hitt",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        countryList= jsonData['data'];
        print(countryList);
        setState(() {

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
        print("Token: "+token);
      }
    }
  }

  Future fetchState(selectedCountryId) async{

    String url = baseUrl + country + "/" + selectedCountryId + "/" + "states";

    Map<String, String> queryParameter = {"status": "1"};
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = url + '?' + queryString;
    print("listEmployeeurl--> " + requestUrl);
    Map<String,String> headers = {
      'x-api-key':
      'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
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
        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "state",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        stateList= jsonData['data'];
        print(stateList);
        setState(() {

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

  Future fetchCity(selectedStateId) async{
    String url = baseUrl + state + "/" + selectedStateId + "/cities";

    Map<String, String> queryParameter = {"status": "1"};
    String queryString = Uri(queryParameters: queryParameter).query;
    var requestUrl = url + '?' + queryString;
    print("listEmployeeurl--> " + requestUrl);
    Map<String,String> headers = {
      'x-api-key':
      'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e',
      'Authorization': token
    };
    // /states/<stateId>/cities

    var response =
    await http.get(Uri.parse(requestUrl), headers: headers);
    print("city" + response.body);
    var jsonData = jsonDecode(response.body);
    print("city  " + response.body);
    print("Header" + headers.toString());

    if (response.statusCode == 200) {
      if (jsonData['status'] == 200) {
        // Fluttertoast.showToast(
        //     msg: jsonData["message"]+ "state",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        cityList= jsonData['data'];
        print(cityList);
        setState(() {

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

}