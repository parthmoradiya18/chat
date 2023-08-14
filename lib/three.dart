import 'package:chat/four.dart';
import 'package:chat/main.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class user extends StatefulWidget {
  const user({Key? key}) : super(key: key);

  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  List val=[];
  List key=[];
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('parth');
  String mob="";
  String nem="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      mob=login.prefs!.getString("contact")??"";
      print(mob);
      print(nem);
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title:Row(
            children: [
              Text("Contact:${mob}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ],
          ),
          actions: [
            IconButton(onPressed: () {
              login.prefs!.remove("status");
              login.prefs!.remove("status");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return login();
              },));
            },icon:Icon(Icons.logout,color: Colors.black,)),
          ],
        ),
        backgroundColor: Colors.black12,
        body: StreamBuilder(
          stream: starCountRef.onValue,
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.active){
              starCountRef.onValue.listen((DatabaseEvent event) {
                setState(() {
                  final data = snapshot.data!.snapshot.value;
                  Map m=data as Map;
                  key = m.keys.toList();
                  val =m.values.toList();
                });
              });
            }
            if(val!=null){
              return SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: val.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion:DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              FirebaseDatabase.instance
                                  .ref('parth')
                                  .child(key[index]).ref.remove();
                              setState(() {});
                            },
                            icon: Icons.delete,
                            label: "Delete",
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                      child:(mob!=val[index]['contact'])?Card(
                        shape: OutlineInputBorder(
                          gapPadding: 5,
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) {
                              return chat(mob,"${val[index]['contact']}");
                            },));
                          },
                          title:Text("${val[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle:Text("${val[index]['contact']}"),
                        ),
                      ):Text(""),
                    );
                  },),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      onWillPop:() async{
        Navigator.push(context,MaterialPageRoute(builder: (context) {
          return user();
        },));
        return true;
      },
    );
  }
}