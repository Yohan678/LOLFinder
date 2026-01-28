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

  //use this controller to get what user typed
    final _nameTextController = TextEditingController(); //UN = UserName
    final _tagTextController = TextEditingController(); //UT = UserTag

    //Store user input into variables
    String userName = '';
    String userTag = '';

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Find your LOL profiles!"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // === Text Display Example ===

              Expanded(
                child: Center(
                  child: Text(
                    'User name is $userName and Tag is $userTag',
                    style: TextStyle(
                      fontSize: 30
                    )
                  )
                )
              ),

              // === Title Display ===
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

                  // === Username Text Input ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenWidth / 2,
                      child: TextField(
                        autocorrect: false,
                        controller: _nameTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your user name',
                            
                          ),
                        ),
                    ),
                  ),
          

                  Text("#"),


                  // === Tag TextInput ====
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        autocorrect: false,
                        controller: _tagTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tag',
                        )
                      )
                    ),
                  )
                ],
              ),
              
              // === Search Button ===
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: MaterialButton(
                  onPressed: () {
                    //update our string variable to get the new user input
                      setState(() {
                        userName = _nameTextController.text;
                        userTag = _tagTextController.text;
                      });
                  },
                  color: Colors.blue,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  )
                ),
              )
            ],
          ),
        )
      )
    );
  }
}