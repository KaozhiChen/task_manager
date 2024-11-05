// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SignUpBottomSheet extends StatefulWidget {
  const SignUpBottomSheet({super.key});

  @override
  State<SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
  // form state
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 36,
            right: 36,
            top: 24,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // form area
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //email
                      TextFormField(
                        controller: _emailController,
                        cursorColor: labelColor,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: labelColor),
                            floatingLabelStyle: TextStyle(color: labelColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primary))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // email
                      const SizedBox(
                        height: 16,
                      ),
                      //password
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: labelColor,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: labelColor),
                            floatingLabelStyle: TextStyle(color: labelColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primary))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Sign Up Button
                InkWell(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      // signup successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Signup successful!")),
                      );

                      // close bottom sheet
                      Navigator.pop(context);
                    } catch (e) {
                      // fail to signup
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Signup failed: ${e.toString()}")),
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(colors: [secondary, primary]),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
