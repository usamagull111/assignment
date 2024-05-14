import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/controllers/routes.dart';
import 'package:assignment/models/sign_in_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: const Text('Sign In'),
        ),
        body: Consumer<SignInModel>(
          builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(16.0.r),
              child: customSingleChildScrollView(
                child: customColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    customSizedBox(height: 40.h),
                    customText(
                        title: "Hello Again!".toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                        )),
                    customSizedBox(height: 0.003),
                    customText(
                      title: "Welcome Back You've Been Missed!",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    customSizedBox(height: 60.h),
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
                          model.signIn().then((value) {
                            Future.delayed(const Duration(seconds: 1));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Logged in Successfully'),
                                  duration: Duration(seconds: 2)),
                            );
                            Navigator.pushNamed(context, RouteNames.home);
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Login Failed: ${error.toString()}'),
                                  duration: const Duration(seconds: 2)),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid email or password"),
                                duration: Duration(seconds: 2)),
                          );
                        }
                      },
                      child: Text('Sign In', style: TextStyle(fontSize: 14.sp)),
                    ),
                    customSizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteNames.signUp),
                      child: Text('Don\'t have an account? Sign Up',
                          style: TextStyle(fontSize: 14.sp)),
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
