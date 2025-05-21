import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  Future<void> _onSignUp() async {
    final empId = _employeeIdController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

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
      // Step 1: Create Firebase Auth user
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Step 2: Ensure user is signed in (wait until auth state is fully ready)
      await Future.delayed(Duration(milliseconds: 500));

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showMessage('User not signed in yet. Try again.');
        return;
      }

      // Step 3: Save profile to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set(<String, dynamic>{
        'employeeId': empId,
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'plant_given_date': null,
        'plant_location': null,
        'circumference_tree': 0.0,
        'height_tree': 0.0,
        'Plant_Age': 0,
        'agb_tree': 0.0,
        'distance': 0.0,
        'profile_picture_link': '',
        'plant_image_link': '',
        'description': '',
        'fuel_type': '',
        'transport_method': '',
        'isblocked': false,
      });

      _showMessage('Sign up successful!', Colors.green);
      debugPrint('Registered UID=${currentUser.uid}');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Signup error');
      debugPrint('FirebaseAuthException: ${e.message}');
    } catch (e, stackTrace) {
      _showMessage('Firestore write failed ,');
      debugPrint('Firestore error: $e');
      debugPrint('StackTrace: $stackTrace');
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
              const SizedBox(height: 20),
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your new account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                _employeeIdController,
                Icons.badge,
                'Enter your Employee ID',
              ),
              _buildTextField(
                _fullNameController,
                Icons.person,
                'Enter your full name',
              ),
              _buildTextField(
                _emailController,
                Icons.email,
                'Enter your email address',
              ),
              _buildTextField(
                _passwordController,
                Icons.lock,
                'Enter your password',
                obscureText: true,
              ),
              _buildTextField(
                _confirmPasswordController,
                Icons.lock,
                'Confirm your password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const Text(
                'By signing up you agree to our Terms of Use and Privacy Notice',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
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
                  child: const Text(
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
    TextEditingController controller,
    IconData icon,
    String hint, {
    bool obscureText = false,
  }) {
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
