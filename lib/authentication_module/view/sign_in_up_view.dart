import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/client_login_controller.dart';
import 'package:school_management/utils/components/core_messenger.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

import '../../constants.dart';

final _clientLoginController = Get.put(ClientLoginController());

class SignInUpView extends StatefulWidget {
  const SignInUpView({super.key});

  @override
  State<SignInUpView> createState() => _SignInUpViewState();
}

class _SignInUpViewState extends State<SignInUpView> {
  bool isLogin = true;
  bool useEmail = true;
  bool showPassword = false;

  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  // ---------------------------------------------------------
  // VALIDATION FUNCTION
  // ---------------------------------------------------------
  bool validateForm() {
    if (isLogin) {
      // LOGIN MODE
      if (useEmail) {
        if (emailCtrl.text.isEmpty) {
          _showError("Please enter your email");
          return false;
        }
        if (!emailCtrl.text.contains("@")) {
          _showError("Please enter a valid email");
          return false;
        }
      } else {
        if (phoneCtrl.text.isEmpty) {
          _showError("Please enter your phone number");
          return false;
        }
        if (phoneCtrl.text.length < 10) {
          _showError("Phone number must be 10 digits");
          return false;
        }
      }

      if (passCtrl.text.isEmpty) {
        _showError("Please enter your password");
        return false;
      }
    } else {
      // SIGNUP MODE
      if (nameCtrl.text.isEmpty) {
        _showError("Please enter your full name");
        return false;
      }
      if (emailCtrl.text.isEmpty) {
        _showError("Please enter email");
        return false;
      }
      if (!emailCtrl.text.contains("@")) {
        _showError("Please enter a valid email");
        return false;
      }
      if (passCtrl.text.length < 6) {
        _showError("Password must be at least 6 characters");
        return false;
      }
    }

    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  // ---------------------------------------------------------
  // UI STARTS HERE
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0A24), Color(0xFF22003D), Color(0xFF0F0A24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Purple Orb
            Positioned(
              top: 100,
              left: 30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Pink Orb
            Positioned(
              bottom: 120,
              right: 30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                      Text(
                        isLogin ? "Welcome Back!" : "Join CineMarathi",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        isLogin
                            ? "Sign in to continue your journey"
                            : "Create your account and get started",
                        style: TextStyle(color: Colors.grey.shade300),
                      ),

                      const SizedBox(height: 25),

                      // Email / Phone Switch
                      // if (isLogin)
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white.withOpacity(0.05),
                      //       borderRadius: BorderRadius.circular(14),
                      //       border: Border.all(color: Colors.white.withOpacity(0.12)),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         _toggleButton(
                      //           title: "Email",
                      //           selected: useEmail,
                      //           onTap: () => setState(() => useEmail = true),
                      //         ),
                      //         _toggleButton(
                      //           title: "Phone",
                      //           selected: !useEmail,
                      //           onTap: () => setState(() => useEmail = false),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      const SizedBox(height: 20),

                      // SIGNUP: Full Name
                      if (!isLogin) _buildInput("Full Name", Icons.person, nameCtrl),

                      // Email Login / Signup Email
                      if (useEmail || !isLogin) _buildInput("Email Address", Icons.mail, emailCtrl),

                      // Phone Login Only
                      if (!useEmail && isLogin) _buildInput("Phone Number", Icons.phone, phoneCtrl),

                      _buildPassword(),

                      if (isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.purple.shade300),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // CTA Button
                      _mainButton(isLogin ? "Sign In" : "Sign Up", () async {
                        if (!validateForm()) return;

                        logger.i(isLogin);

                        if (isLogin) {
                          final status = await _clientLoginController.clientLogin(
                            email: emailCtrl.text,
                            password: passCtrl.text,
                          );

                          if (status == 1) {
                            emailCtrl.clear();
                            passCtrl.clear();
                            MyNavigator.popUntilAndPushNamed(GoPaths.landingPage);
                            return;
                          }

                          return;
                        }

                        // return;
                        if (!isLogin) {
                          MyNavigator.pushNamed(
                            GoPaths.profileSetUp,
                            extra: {
                              "email": emailCtrl.text,
                              "fullName": nameCtrl.text,
                              "password": passCtrl.text,
                            },
                          );
                        }

                        return;
                      }),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin ? "Don't have an account? " : "Already have an account? ",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => isLogin = !isLogin),
                            child: Text(
                              isLogin ? "Sign Up" : "Sign In",
                              style: TextStyle(
                                color: Colors.purple.shade300,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // WIDGET HELPERS
  // ---------------------------------------------------------
  Widget _toggleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected ? const LinearGradient(colors: [Colors.purple, Colors.pink]) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: selected ? Colors.white : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: TextFormField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              fillColor: Colors.transparent,
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.grey.shade300)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: TextField(
            controller: passCtrl,
            obscureText: !showPassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => showPassword = !showPassword),
                child: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
              border: InputBorder.none,
              hintText: "•••••••",
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _mainButton(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.purple, Colors.pinkAccent]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}
