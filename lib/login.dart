import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'menu_page.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedOption = 'dine-in';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> sendData() async {
    final url =
        'http://10.0.2.2/blackcApi/login.php'; // Replace with your PHP API endpoint

    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': nameController.text,
        'phone_number': phoneNumberController.text,
        'option': selectedOption,
      },
    );

    if (response.statusCode == 200) {
      // Request successful, handle response if needed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPage(
            phoneNumber: phoneNumberController.text,
            name: nameController.text,
            opt: selectedOption,
          ),
        ),
      );
    } else {
      // Request failed, handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 70.0, left: 20.0, right: 20.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'lib/assets/logo.png',
                  width: 290,
                  height: 200, // Adjust the width as needed
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'Dine-in',
                    groupValue: selectedOption,
                    activeColor: Color.fromRGBO(180, 45, 46, 1),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  const Text('Dine-In'),
                  const SizedBox(width: 40),
                  Radio(
                    value: 'Take-away',
                    groupValue: selectedOption,
                    activeColor: Color.fromRGBO(180, 45, 46, 1),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  const Text('Take-Away'),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    sendData();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(180, 45, 46, 1),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
