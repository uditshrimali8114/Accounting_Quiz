
import 'package:accounting_quiz/myprofile.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';


// Stateful widget created
class bottomBar extends StatefulWidget {
  int bottom;
  bottomBar({required this.bottom});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<bottomBar> {
// index given for tabs
  int currentIndex = 0;
  int _selectedItemIndex = 1;
  final List pages = [
    Dashboard(),
    MyProfile()
  ];
  setBottomBarIndex(index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedItemIndex = widget.bottom == null ? 0 : widget.bottom;
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: pages[_selectedItemIndex],

      // floating action button in center
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setBottomBarIndex(2);
      //   },
      //   child:  Container(
      //     width: 100.0,
      //     height: 100.0,
      //     decoration: BoxDecoration(
      //       // color: BackColorCard,
      //       color: Colors.white.withOpacity(1),
      //       boxShadow: [
      //         BoxShadow(
      //             color: Colors.grey.shade200
      //                 .withOpacity(.1),
      //             blurRadius: 4,
      //             spreadRadius: 3)
      //       ],
      //       border: Border.all(
      //         width: 5,
      //         color: Colors.grey,
      //       ),
      //       borderRadius: BorderRadius.circular(50.0),
      //     ),
      //     padding: EdgeInsets.all(5),
      //     child: Image.asset("assets/images/home.png",
      //       height: 25,
      //       width: 25,),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom app bar
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        // shape: CircularNotchedRectangle(),
        child: Container(
          // margin: EdgeInsets.only(left: 20,right: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey,width: 0.5),
              // borderRadius: BorderRadius.circular(30)
          ),
          height: 55,
          // padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // button 1
              Expanded(

                flex: 5,
                child:  GestureDetector(
                  onTap: (){
                    // setBottomBarIndex(0);
                    // print("Profile Clicked");
                  },
                  child: Container(
                    // F0F0F0
                    color:_selectedItemIndex==0?Color(0xFFF0F0F0):Colors.white,
                    child: IconButton(
                      icon:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Image.asset('assets/Home/Home.png',height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // SizedBox(width: 5,),
                          Container(child: Text('Home',style: TextStyle(color: Color(0xff708090),fontSize: 14),))
                        ],
                      ),
                      onPressed: () {
                        setBottomBarIndex(0);
                        print("Home Clicked");
                      },
                      splashColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
              child:  GestureDetector(
                onTap: (){
                  // setBottomBarIndex(1);

                },
                child: Container(
                  color:_selectedItemIndex==1?Color(0xFFF0F0F0):Colors.white,
                  child: IconButton(
                    icon:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Image.asset('assets/Home/User.png',height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // SizedBox(width: 5,),
                        Container(child: Text('Profile',style: TextStyle(color: Color(0xff708090),fontSize: 14),))
                      ],
                    ),
                    onPressed: () {
                      setBottomBarIndex(1);
                      print("Profile Clicked");
                    },
                    splashColor: Colors.white,
                  ),
                ),
              ),

              ),

            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildNavBarItem(IconData icon, Text text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
          print("_selectedItemIndex"+_selectedItemIndex.toString());
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        //  border:
        //     Border(bottom: BorderSide(width: 4, color: kSecondaryLightColor)),
        //     gradient: LinearGradient(colors: [
        //       kSecondaryLightColor.withOpacity(0.3),
        //       kSecondaryLightColor.withOpacity(0.016),
        //     ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
        //     : BoxDecoration( ),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              color:  _selectedItemIndex==index
                  ? Colors.red
                  : Colors.blueAccent[500],
            ),

          ],
        ),
      ),
    );
  }
}
