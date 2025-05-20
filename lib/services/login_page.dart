import 'package:flutter/material.dart';
import 'package:plant_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Clip Path
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      // Plant Background Image
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/vector 1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Curved Bottom Overlay
                      Positioned(
                        bottom: -1,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Area
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Login Form
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Login Text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'login to your account',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Name Field
                  TextFormField(
                    controller: _employeeIdController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      hintText: 'Enter your Employee Id',
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.green.shade700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      hintText: '• • • • • • • • • •',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                        letterSpacing: 3,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.green.shade700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Remember Me and Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me Checkbox
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.85,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Forgot Password
                      Text(
                        'Forget Password ?',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Don't have account - Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bottom Indicator Line
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
