import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import 'package:simple_loginpage/components/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? backgroundImageUrl;
  String? textForTheDay;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _userNameError;
  String? _passwordError;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    fetchRandomImage();
    fetchRandomVerse(); // Fetch random verse when the widget initializes
  }

  Future<void> fetchRandomImage() async {
    final response = await http.get(Uri.parse('https://picsum.photos/200/300'));
    if (response.statusCode == 200) {
      setState(() {
        backgroundImageUrl = response.request!.url.toString();
      });
    } else {
      throw Exception('Failed to load random image');
    }
  }

  Future<void> fetchRandomVerse() async {
    final response = await http
        .get(Uri.parse('https://bibleversegenerator.com/hope-verses'));
    if (response.statusCode == 200) {
      setState(() {
        textForTheDay = response.request!.url.toString();
      });
    } else {
      throw Exception('Failed to load random verse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.white, // Default background color
            ),
            if (backgroundImageUrl != null)
              Image.network(
                backgroundImageUrl!,
                fit: BoxFit.cover,
              ),
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                child: Container(
                  width: 280,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                  ),
                  child: FlipCard(
                    fill: Fill.fillBack,
                    direction: FlipDirection.HORIZONTAL,
                    side: CardSide.FRONT,
                    front: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome to My App",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 34),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Center(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(fontSize: 34),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  // Customize border color
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Optional: Customize border radius
                                ),
                                errorText: _userNameError,
                                // Display error message below field
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 0.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username cannot be empty';
                                }
                                return null; // Return null if no error
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, size: 20),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorText: _passwordError,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isObscure =
                                          !_isObscure; // Toggle password visibility
                                    });
                                  },
                                  child: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              obscureText: _isObscure,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                onSubmit();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              child: Text("Login"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    autoFlipDuration: const Duration(seconds: 5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    setState(() {
      _userNameError =
          _userNameController.text.isEmpty ? 'Username cannot be empty' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    });

    if (_userNameError == null && _passwordError == null) {
      // Perform login/authentication logic here
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
