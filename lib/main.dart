import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    //use this controller to get what user typed
    final _textController = TextEditingController();

    String userName;
    String userTag;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Find your LOL profiles!"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text("Search Your PlayerName#Tag", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ))
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenWidth / 2,
                      child: TextField(
                        controller: _textController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your user name',
                            
                          ),
                        ),
                    ),
                  ),
          
                  Text("#"),
  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tag',
                        )
                      )
                    ),
                  )
                ],
              ),
              MaterialButton(
                onPressed: () {},
                color: Colors.blue,
                child: Text('Search', style: TextStyle(color: Colors.white))
              )
            ],
          ),
        )
      )
    );
  }
}