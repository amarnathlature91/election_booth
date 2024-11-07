import 'package:election_booth/resources/ElbtextField.dart';
import 'package:election_booth/resources/elb_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/routes/named_routes.dart';
import '../../viewModel/AuthProvider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'signup_screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> signUpForm = GlobalKey();
  final bool _signinUp = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _middleNameNode = FocusNode();
  final FocusNode _mobileNameNode = FocusNode();

  // Future<void> signUp() async {
  //   try {
  //     setState(() {
  //       _signinUp = true;
  //     });
  //
  //     var res = await http.post(
  //       Uri.parse("http://192.168.1.38:8083/api/auth/committee/signup"),
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         'firstName': _firstNameController.text,
  //         'middleName': _middleNameController.text,
  //         'lastName': _lastNameController.text,
  //         'mobNo': _mobileController.text,
  //       }),
  //     );
  //     print(res.body);
  //     if (res.body.isNotEmpty) {
  //       var body = jsonDecode(res.body);
  //       if (body['message'].toString().toLowerCase().contains('success')) {
  //         Utils.showSuccess(context, body['message']);
  //         Navigator.pushNamed(context, NamedRoutes.sendOtp);
  //       }
  //
  //       if (body['message'].toString().toLowerCase().contains('error')) {
  //         Utils.showError(context, body['message']);
  //       }
  //     }
  //   } catch (e) {
  //     rethrow;
  //     //
  //   } finally {
  //     setState(() {
  //       _signinUp = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/send_otp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).viewInsets.bottom == 0
                        ? MediaQuery.of(context).size.height / 2.9
                        : 50,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: signUpForm,
                            child: Column(
                              children: [
                                ElbTextField(
                                  controller: _firstNameController,
                                  labelColor: Colors.white,
                                  inputColor: Colors.white,
                                  focusNode: _firstNameNode,
                                  hintText: 'Enter First Name',
                                  labelText: 'First Name',
                                  customValidator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                ElbTextField(
                                  controller: _middleNameController,
                                  hintText: 'Enter Middle Name',
                                  inputColor: Colors.white,
                                  focusNode: _middleNameNode,
                                  labelColor: Colors.white,
                                  labelText: 'Middle Name',
                                  customValidator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter middle name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                ElbTextField(
                                  controller: _lastNameController,
                                  hintText: 'Enter Last Name',
                                  labelColor: Colors.white,
                                  inputColor: Colors.white,
                                  focusNode: _lastNameNode,
                                  labelText: 'Last Name',
                                  customValidator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                ElbTextField(
                                  controller: _mobileController,
                                  hintText: 'Mobile',
                                  inputColor: Colors.white,
                                  labelColor: Colors.white,
                                  keyboardType: TextInputType.number,
                                  focusNode: _mobileNameNode,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  customValidator: (value) {
                                    RegExp mobileRegex =
                                        RegExp(r'^[5-9]\d{9}$');
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your mobile number";
                                    } else if (!mobileRegex.hasMatch(value)) {
                                      return "Enter a valid 10-digit mobile number starting with 6-9";
                                    }
                                    return null;
                                  },
                                  labelText: 'Mobile Number',
                                ),
                                const SizedBox(height: 15),
                                Consumer<AuthProvider>(
                                  builder: (context, pr, child) {
                                    return ElbButton(
                                      text: 'Sign Up',
                                      backgroundColor: const Color(0xFF5f2300),
                                      isLoading: pr.loading,
                                      onPressed: () {
                                        if (signUpForm.currentState!
                                            .validate()) {
                                          pr.signUp(
                                            context: context,
                                            firstName:
                                                _firstNameController.text,
                                            middleName:
                                                _middleNameController.text,
                                            lastname: _lastNameController.text,
                                            mobileNumber:
                                                _mobileController.text,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, NamedRoutes.sendOtp);
                                  },
                                  child: const Text(
                                    'Already have account? Login here',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
