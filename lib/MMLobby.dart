import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'MemoryMatch.dart';
import 'GridConq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'MemoryMatch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create.dart';
import 'join.dart';

import 'package:flutter/material.dart';
import 'create.dart';
import 'join.dart';

import 'package:flutter/material.dart';
import 'create.dart';
import 'join.dart';

class HomeScreen extends StatelessWidget {
  int gameno;
  HomeScreen({required this.gameno});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lobby',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'ReemKufiFun'),
        ),
        backgroundColor: Color.fromARGB(
            255, 255, 179, 2), // Use a contrasting color for the AppBar
        elevation: 4.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Add some space at the top
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateGameScreen(gameno: gameno, multi: true)),
                );
              },
              icon: Icon(Icons.add, size: 30, color: Colors.black),
              label: const Text('Create Game',
                  style: TextStyle(
                      fontFamily: 'ReemKufiFun', color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 255, 179, 2), // Button color
                //onPrimary: Colors.white, // Text color

                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ReemKufiFum'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JoinGameScreen(
                            gameno: gameno,
                          )),
                );
              },
              icon: const Icon(Icons.group_add, size: 30, color: Colors.black),
              label: const Text('Join Game',
                  style: TextStyle(
                      fontFamily: 'ReemKufiFun', color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 255, 179, 2), // Button color
                //onPrimary: Colors.white, // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ReemKufiFun'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
