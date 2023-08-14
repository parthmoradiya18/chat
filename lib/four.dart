

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
class chat extends StatefulWidget {
  String sender;
  String receiver;
  chat(this.sender,this.receiver);
  @override
  State<chat> createState() => _chatState();
}
class _chatState extends State<chat> {
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');
  TextEditingController t1 =TextEditingController();
  //final chatRef = firebase.database().ref("chat");
  List key=[];
  List val=[];
  List list=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        Map m=data as Map;
        key =m.keys.toList();
        val=m.values.toList();

      });
      print(val);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Chat On :${widget.receiver}",style: TextStyle(fontWeight: FontWeight.bold),),),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(child: Text("Sender : ${widget.sender}",style: TextStyle(fontWeight: FontWeight.bold),)),
          SizedBox(height: 30),
          Expanded(child: ListView.builder(
            itemCount: val.length,
            itemBuilder: (context, index) {
              print("Receiver : ${val[index]['reciever']}");
              print("Receiver : ${widget.receiver}");
              return ((
                  val[index]['reciever']==widget.receiver&&
                      val[index]['sender']==widget.sender)||
                  (val[index]['sender']==widget.receiver&&
                      val[index]['reciever']==widget.sender
                  )
              )?Card(
                shape: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: (val[index]['reciever']==widget.receiver)?
                Card(color: Colors.orange,
                  child: ListTile(onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text("Delete message ?"),

                        actions: [

                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 30,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                child: Text("CANCEL",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.pink),),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                FirebaseDatabase.instance
                                    .ref('chat')
                                    .child(key[index]).ref.remove();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 30,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                child: Text("OK",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.pink),),
                              ),
                            ),

                        ],
                      );
                    },);
                  },
                    trailing:Text("${val[index]['msg']}",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 20),),
                  ),
                ):
                Card(color: Colors.pinkAccent,
                  child: ListTile(
                    leading:Text("${val[index]['msg']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontStyle: FontStyle.italic),),
                  ),
                ),
              ):SizedBox();
            },)
          ),
          TextField(
            controller: t1,
            textAlign: TextAlign.center,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Enter Message",
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              icon: Icon(Icons.message_outlined),
              suffixIcon: IconButton(onPressed: () {
                DatabaseReference ref = FirebaseDatabase.instance.ref('chat').push();
                ref.set({
                  "msg":t1.text,
                  "reciever":"${widget.receiver}",
                  "sender":"${widget.sender}",
                  "time":"${DateTime.now()}"
                });
                t1.text="";
                setState(() {});
              },icon:Icon(Icons.send)),
            ),
          ),
        ],
      ),
    );
  }
}