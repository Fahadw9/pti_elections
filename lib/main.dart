// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTI Elections 2024',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String naConstituency = '';
  String candidateName = '';
  String constituencyName = '';

  Future<void> fetchData() async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('your_data_collection')
        .doc('tL95HSeLCyMN821zy0Vp')
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      var constituency = data['constituencies'].firstWhere(
        (constituency) =>
            constituency['ConstituencyNo'] == naConstituency,
        orElse: () => null,
      );

      if (constituency != null) {
        setState(() {
          candidateName = constituency['CandidateName'];
          constituencyName = constituency['ConstituencyName'];
        });
      } else {
        setState(() {
          candidateName = '';
          constituencyName = '';
        });
      }
    } else {
      setState(() {
        candidateName = '';
        constituencyName = '';
      });
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching data: $error');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PTI Elections 2024'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  naConstituency = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter your NA constituency (e.g., NA-128)',
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(candidateName),
                    subtitle: Text('Constituency Name: $constituencyName'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Either you surrender or you fight for your freedom till death. What will I do? I ask myself this question. And my belief is LA ILLAH IL’ALLAH. There is no God but One. We will fight. - Imran Khan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/a/a1/Imran_Khan.jpg',
                    height: 300,
                    width: 300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Fetch Data',
        child: const Icon(Icons.search),
      ),
    );
  }
}
