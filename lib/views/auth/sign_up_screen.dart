

import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/controllers/routes.dart';
import 'package:assignment/models/sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupModel>(
      create: (_) => SignupModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: customText(title: 'Signup'),
        ),
        body: Consumer<SignupModel>(
          builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(16.0.r),
              child: customSingleChildScrollView(
                child: customColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    customSizedBox(
                            height: 80.h,
                          ),
                          customText(
                              title: "Create Account".toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w600,
                              )),
                          customSizedBox(height: 0.003),
                          customText(
                            title: "Let's Create Account Togather!",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          customSizedBox(height: 60.h),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) => model.name = value,
                    ),
                    customSizedBox(height: 8.h),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (value) => model.email = value,
                    ),
                    customSizedBox(height: 8.h),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (value) => model.password = value,
                    ),
                    customSizedBox(height: 80.h),
                    ElevatedButton(
                      onPressed: () {
                        if (model.validate()) {
                          model.signup().then((_) {
                              Future.delayed(const Duration(seconds: 1));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registered Successfully'), duration: Duration(seconds: 2)),
                            );
                            Navigator.pushNamed(context, RouteNames.home);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Registration Failed: ${error.toString()}'), duration: const Duration(seconds: 2)),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields correctly!'), duration: Duration(seconds: 2)),
                          );
                        }
                      },
                      child: customText(title: 'Signup', style: TextStyle(fontSize: 14.sp)),
                    ),
                    customSizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, RouteNames.signin),
                      child: Text('Already have an account? Sign In', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
