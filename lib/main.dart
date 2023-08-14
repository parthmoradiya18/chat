import 'package:chat/second.dart';
import 'package:chat/three.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: login(),debugShowCheckedModeBanner: false,
  ));
}
class login extends StatefulWidget {
  static SharedPreferences? prefs;
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController t1 =TextEditingController();
  TextEditingController t2 =TextEditingController();
  @override



  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }
  get() async {
    login.prefs = await SharedPreferences.getInstance();
    if(login.prefs!.get("status")==true){
      Navigator.push(context,MaterialPageRoute(builder: (context) {
        return user();
      },));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            SizedBox(width: 60),
            Text("Login Chat Page",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
          ],
        ),
      ),
      body:Column(
        children: [
          SizedBox(height: 50),
          TextField(
            controller: t1,
            decoration: InputDecoration(
              labelText: "Enter Name :",
              suffixIcon: Icon(Icons.drive_file_rename_outline_sharp),
              hintStyle: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: t2,
            decoration: InputDecoration(
              labelText: "Enter Contact :",
              suffixIcon: Icon(Icons.contact_emergency_sharp),
              hintStyle: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),

            ),
          ),
          ElevatedButton(onPressed: () async {
            DatabaseReference starCountRef = FirebaseDatabase.instance.ref('parth');
            starCountRef.onValue.listen((DatabaseEvent event) {
              final data = event.snapshot.value;
              Map m=data as Map;
              List l=m.values.toList();
              bool t=false;
              for(int i=0;i<l.length;i++){

                if(l[i]['name']==t1.text && l[i]['contact']==t2.text){
                  t  =true;
                  break;
                }

              }
              if(t==true){
                login.prefs!.setString("contact",t2.text);
                login.prefs!.setBool("status",true);
                Navigator.push(context,MaterialPageRoute(builder: (context) {
                  return user();
                },));
              }
              else{
                showDialog(context: context,builder:(context) {
                  return AlertDialog(
                    backgroundColor: Colors.black54,
                    icon: Icon(Icons.crisis_alert_rounded,color: Colors.white,size: 30),
                    title: Text("Wrong UserName and Mobile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      },child:Text("Ok")),
                    ],
                  );
                },);
                //* print("Wrong UserName and Mobile");
              }
              t1.text='';
              t2.text='';
            });
          },child:Text("Submit")),
          TextButton(onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return new_user();
            },));
          },child:Text("New Users")),
        ],
      ),
    );
  }
}