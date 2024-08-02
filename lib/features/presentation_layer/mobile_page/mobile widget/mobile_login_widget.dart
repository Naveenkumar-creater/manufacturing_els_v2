import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/utilities/customwidgets/custom_textform_field.dart';
import '../../api_services/login_di.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  State<MobileLogin> createState() => _LoginState();
}

class _LoginState extends State<MobileLogin> {
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
      print('MobileLogin Error: $error'); // Print the error for debugging purposes
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
            SizedBox(
              height: 50.h,
              child: CustomTextFormfield(
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
                  constrainBox: BoxConstraints(maxHeight:  60.h, maxWidth:  250.w),
                textStyle:TextStyle(color: Colors.black38, fontSize: 14.w) ,
                labelStyle: TextStyle(fontSize: 10.w),
                hintStyle:  TextStyle(color: Colors.black38, fontSize: 12.w),
                
              ),
            ),
           SizedBox(height: 20.h),
            SizedBox(
          height: 50.h,
              child: CustomTextFormfield(
                controller: passwordController,
                hintText: "Password",
                      constrainBox: BoxConstraints(maxHeight:  60.h, maxWidth:  250.w),
                textStyle:TextStyle(color: Colors.black38, fontSize: 14.w) ,
                labelStyle: TextStyle(fontSize: 12.w),
                hintStyle:  TextStyle(color: Colors.black38, fontSize: 12.w),
                
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
              
                    size: 15.w,
                  ),
                ),
              ),
            ),
         SizedBox(height: 20.h),
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
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:  Color(0xFF25476A),
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isTextVisible)
                           Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white,fontSize: 12.w),
                          ),
                        if (isCircularProgressIndicatorVisible)
                          SizedBox(
                            height: 40.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
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
