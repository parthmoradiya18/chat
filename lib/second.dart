
import 'package:country_picker/country_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class new_user extends StatefulWidget {
  const new_user({Key? key}) : super(key: key);

  @override
  State<new_user> createState() => _new_userState();
}

class _new_userState extends State<new_user> {
  TextEditingController t1 =TextEditingController();
  TextEditingController t2 =TextEditingController();
  TextEditingController t3 =TextEditingController();
  TextEditingController t4 =TextEditingController();
  TextEditingController t5 =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("New User Chat",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Register",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:30),),
            SizedBox(height: 20),
            TextField(
              controller: t1,
              decoration: InputDecoration(
                labelText: "Enter Name :",
                hintText: "Please Enter Name :",
                suffixIcon: Icon(Icons.drive_file_rename_outline_sharp),
                border: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(10)),

                ),
              ),
            ),
            SizedBox(height:5),
            TextField(
              controller: t2,
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true, // optional. Shows phone code before the country name.
                  onSelect: (Country country) {
                    t2.text=country.phoneCode;
                    print('Select country: ${country.displayName}');
                  },
                );
              },
              decoration: InputDecoration(
                labelText: "Enter Contact :",
                hintText: "Please Enter Name :",
                suffixIcon: Icon(Icons.contact_emergency_sharp),
                border: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: t3,
              decoration: InputDecoration(
                labelText: "Enter Email Id :",
                hintText: "Please Enter Email_Id :",
                suffixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(10)),

                ),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: t4,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Enter Email Password :",
                hintText: "Please Enter Password :",
                suffixIcon: Icon(Icons.password),
                border: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(10)),

                ),
              ),
            ),
            SizedBox(height: 5),

            ElevatedButton(onPressed: () async {

              DatabaseReference ref = FirebaseDatabase.instance.ref("parth").push();
              await ref.set({
                "name": t1.text,
                "contact":t2.text,
                "email":t3.text,
                "password":t4.text,

              });
              t1.text="";
              t2.text="";
              t3.text="";
              t4.text="";
              Navigator.push(context,MaterialPageRoute(builder: (context) {
                return login();
              },));
            },child:Text("Submit")),
          ],
        ),
      ),
    );
  }
}