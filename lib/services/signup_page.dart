//New Code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for each TextField
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, [Color backgroundColor = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Simple email validation regex
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailRegex.hasMatch(email);
  }

  Future<void> _onSignUp() async {
    final empId = _employeeIdController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    // — your existing validations…
    if (empId.isEmpty) {
      _showMessage('Employee ID cannot be empty');
      return;
    }
    if (!_isValidEmail(email)) {
      _showMessage('Invalid email');
      return;
    }
    if (password.isEmpty || confirm.isEmpty) {
      _showMessage('Password required');
      return;
    }
    if (password != confirm) {
      _showMessage('Passwords do not match');
      return;
    }

    try {
      // 1) Create Auth user
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2) Write profile to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'employeeId': empId,
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showMessage('Sign up successful!', Colors.green);
      debugPrint('Registered UID=${cred.user!.uid}');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Signup error');
    } catch (e) {
      _showMessage('Unexpected error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'create your new account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                  _employeeIdController, Icons.badge, 'Enter your Employee Id'),
              _buildTextField(
                  _fullNameController, Icons.person, 'Enter your full name'),
              _buildTextField(
                  _emailController, Icons.email, 'Enter your email address'),
              _buildTextField(
                  _passwordController, Icons.lock, 'Enter your password',
                  obscureText: true),
              _buildTextField(_confirmPasswordController, Icons.lock,
                  'Confirm your password',
                  obscureText: true),
              SizedBox(height: 10),
              Text(
                'By signing you agree to our Terms of Use and Privacy Notice',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green[700]),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
