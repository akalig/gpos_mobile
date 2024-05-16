import 'package:flutter/material.dart';
import '../components/authentication_textfield.dart';
import '../components/register_button.dart';
import '../database/database_helper.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController companyNameController;
  late TextEditingController companyAddressController;
  late TextEditingController companyTypeController;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController suffixNameController;
  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late TextEditingController userTypeController;
  late TextEditingController confirmPasswordController;

  bool isLoading = false;

  /// * ADD USER CLASS **
  Future<void> _addUserAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is not match.'),
        ),
      );

      return;
    }

    if (companyNameController.text == '' ||
        companyAddressController.text == '' ||
        companyTypeController.text == '' ||
        firstNameController.text == '' ||
        lastNameController.text == '' ||
        userNameController.text == '' ||
        passwordController.text == '' ||
        userTypeController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Some fields are missing, please complete all the fields.'),
        ),
      );

      return;
    }

    await SQLHelper.createUserAccount(
      companyNameController.text,
      companyAddressController.text,
      companyTypeController.text,
      firstNameController.text,
      middleNameController.text,
      lastNameController.text,
      middleNameController.text,
      userNameController.text,
      passwordController.text,
      userTypeController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
    companyAddressController = TextEditingController();
    companyTypeController = TextEditingController();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    suffixNameController = TextEditingController();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    userTypeController = TextEditingController();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    companyTypeController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
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
              controller: firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthenticationTextField(
              controller: middleNameController,
              hintText: 'Middle Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthenticationTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthenticationTextField(
              controller: suffixNameController,
              hintText: 'Suffix Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthenticationTextField(
              controller: userTypeController,
              hintText: 'User Type',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            AuthenticationTextField(
              controller: userNameController,
              hintText: 'Username',
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
            RegisterButton(
              onTap: () async {
                await _addUserAccount();
              },
            ),

            const SizedBox(height: 25),
            isLoading ? const CircularProgressIndicator() : Container(),
            // Display loading indicator when isLoading is true
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
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
