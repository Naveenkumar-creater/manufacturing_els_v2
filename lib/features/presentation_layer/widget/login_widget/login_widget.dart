import 'package:flutter/material.dart';
import 'package:prominous/constant/utilities/customwidgets/custom_textform_field.dart';
import 'package:prominous/features/presentation_layer/api_services/emp_details.dart';
import '../../api_services/login_di.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> LogininFormKey = GlobalKey<FormState>();
  final LoginApiService loginApiservice = LoginApiService();
  final FocusNode firstTextFieldFocus = FocusNode();
  final FocusNode secondTextFieldFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;
  bool isTextVisible = true;
  bool isCircularProgressIndicatorVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> logInUser() async {
    setState(() {
      isCircularProgressIndicatorVisible = true;
      isTextVisible = false;
    });

    try {
      await loginApiservice.login(
        context: context,
        loginId: emailController.text,
        password: passwordController.text,
      );

      
    } catch (error) {
      print('Login Error: $error'); // Print the error for debugging purposes
      setState(() {
        isCircularProgressIndicatorVisible = false;
        isTextVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: LogininFormKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 78, left: 25, right: 25),
        child: Column(
          children: [
            CustomTextFormfield(
              controller: emailController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(secondTextFieldFocus);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter EmployeId';
                }
                if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Email/Phone cannot contain special symbols';
                }
                if (value.contains(' ')) {
                  return 'Email/Phone cannot contain spaces';
                }
                return null;
              },
              hintText: "Enter Employee Id",
              focusNode: firstTextFieldFocus,
            ),
            const SizedBox(height: 30),
            CustomTextFormfield(
              controller: passwordController,
              hintText: "Password",
              focusNode: secondTextFieldFocus,
              onFieldSubmitted: (value) {
                if (LogininFormKey.currentState?.validate() == true) {
                  logInUser();
                }
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              isObscureText: isObscureText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: Icon(
                  isObscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined, // Toggle the visibility icon
                  color: const Color(0xFF25476A),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (LogininFormKey.currentState?.validate() == true) {
                      setState(() {
                        isTextVisible = false;
                        isCircularProgressIndicatorVisible = true;
                      });
                      logInUser();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF25476A),
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isTextVisible)
                          const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        if (isCircularProgressIndicatorVisible)
                          const CircularProgressIndicator(
                            color: Colors.white,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
