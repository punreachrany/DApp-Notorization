import 'package:Notorization/themes/colors.dart';
import 'package:flutter/material.dart';

class Developers extends StatefulWidget {
  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("Developers"),
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //       color: primaryColor,
              //       borderRadius: BorderRadius.circular(20)),
              //   child: Text(
              //     "TEAM AWESOME",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 25,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.asset("assets/images/Punreach.jpg"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Punreach RANY",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Frontend (Flutter)",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Solidity",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.asset("assets/images/Chu.png"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Heon Nam CHU",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Backend (Infura)",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Solidity",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
