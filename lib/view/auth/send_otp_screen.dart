import 'package:election_booth/resources/ElbtextField.dart';
import 'package:election_booth/resources/elb_button.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SendOtpScreen extends StatefulWidget {
  static const String routeName = 'send_otp_screen';

  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isOtpSent = ValueNotifier<bool>(false);
  GlobalKey<FormState> mobileKey = GlobalKey();
  GlobalKey<FormState> otpKey = GlobalKey();

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    isPasswordVisible.dispose();
    isOtpSent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOtpSent.value) {
          isOtpSent.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/send_otp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: ValueListenableBuilder(
                        valueListenable: isOtpSent,
                        builder: (c, otpSent, ch) {
                          return isOtpSent.value
                              ? _buildOTPEntryField()
                              : _buildSendOTPButton();
                        })),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NamedRoutes.signup);
                  },
                  child: const Text(
                    'Dont have account? Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSendOTPButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: mobileKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter your mobile number to continue',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElbTextField(
                controller: _mobileController,
                hintText: 'Mobile',
                inputColor: Colors.white,
                hintColor: Colors.black38,
                prefixIcon: const Icon(
                  Icons.call_rounded,
                  color: Colors.white,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
                labelColor: Colors.white,
                customValidator: (value) {
                  RegExp mobileRegex = RegExp(r'^[5-9]\d{9}$');

                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile number";
                  } else if (!mobileRegex.hasMatch(value)) {
                    return "Enter a valid 10-digit mobile number starting with 6-9";
                  }
                  return null;
                },
                labelText: 'Mobile Number'),
            const SizedBox(
              height: 20,
            ),
            Consumer<AuthProvider>(builder: (w, pr, c) {
              return ElbButton(
                  text: 'Send OTP',
                  isLoading: pr.loading,
                  onPressed: () async {
                    if (mobileKey.currentState!.validate()) {
                      isOtpSent.value = await pr.sendOtp(
                          context: context,
                          mobileNumber: _mobileController.text);
                    }
                  });
            })
          ],
        ),
      ),
    );
  }

  Widget _buildOTPEntryField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: otpKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter OTP received on your mobile number',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ValueListenableBuilder(
                valueListenable: isPasswordVisible,
                builder: (context, visible, ch) {
                  return ElbTextField(
                      controller: _otpController,
                      hintText: 'OTP',
                      inputColor: Colors.white,
                      keyboardType: TextInputType.number,
                      labelColor: Colors.white,
                      hintColor: Colors.black38,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      obscureText: isPasswordVisible.value,
                      suffixIcon: InkWell(
                        onTap: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                        child: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: Colors.white,
                        ),
                      ),
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter otp";
                        }
                        return null;
                      },
                      labelText: 'Enter OTP');
                }),
            const SizedBox(
              height: 20,
            ),
            Consumer<AuthProvider>(builder: (context, pr, child) {
              return ElbButton(
                  text: 'Verify',
                  isLoading: pr.loading,
                  onPressed: () async {
                    if (otpKey.currentState!.validate()) {
                      bool res = await pr.verifyOtp(
                          context: context,
                          mobileNumber: _mobileController.text,
                          otp: _otpController.text);

                      res
                          ? () => Navigator.pushNamedAndRemoveUntil(
                              context, NamedRoutes.home, (_) => false)
                          : null;
                    }
                  });
            })
          ],
        ),
      ),
    );
  }
}
