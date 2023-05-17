import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'controller.dart';
import 'model_for_display.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<Welcome> futureWelcomeData;
  final TextEditingController controller = TextEditingController();

  var data;
  var name;
  var address;

  @override
  void initState() {
    super.initState();
    futureWelcomeData = fetchWelcomeData('');
  }

  Future<Welcome> fetchWelcomeData(String phoneNumber) async {
    final response =
    await http.get(Uri.parse('http://192.168.1.46:5000/api/search/searchByPhone?data_Phonenumber=$phoneNumber'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(response.body);
      final result = DisplayDataFromJson(response.body);

      setState(() {
        name = result.data.dataName;
        address = result.data.dataAddress.toString();

        data = result.sales.dataSalesSalesmethod;

      });

      print(response.body);
      return Welcome.fromJson(jsonData);
    } else {
      throw Exception('Failed to load welcome data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futureWelcomeData = fetchWelcomeData(controller.text);
                });
              },
              child: Text('Search'),
            ),
            // Text(
            //     'name : ${data.data.dataName.toString()}'),
            Text(
              "name: ${name}",
              style: TextStyle(
                fontSize: 16
              ),
            ),
            Text(
              "sales: ${address}",
              style: TextStyle(
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
