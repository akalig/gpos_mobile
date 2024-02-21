import 'package:flutter/material.dart';
import '../components/authentication_textfield.dart';
import '../components/register_button.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyTypeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          Text(
            'Register',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          AuthenticationTextField(
            controller: companyNameController,
            hintText: 'Company Name',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          AuthenticationTextField(
            controller: companyAddressController,
            hintText: 'Company Address',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          AuthenticationTextField(
            controller: companyTypeController,
            hintText: 'Company Type',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          AuthenticationTextField(
            controller: emailController,
            hintText: 'Email Address',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          AuthenticationTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          AuthenticationTextField(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: true,
          ),
          const SizedBox(height: 25),
          const RegisterButton(
            onTap: null,
          ),
          const SizedBox(height: 25),
          isLoading
              ? const CircularProgressIndicator()
              : Container(), // Display loading indicator when isLoading is true
          // not a member? register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Registered already?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text(
                  'Login here.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
