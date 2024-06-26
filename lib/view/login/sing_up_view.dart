import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common/extension.dart';
import '../../common_widget/round_button.dart';
import 'login_view.dart';

import '../../common/globs.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    
  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = FirebaseAuth.instance.currentUser;
      CollectionReference ref = firebaseFirestore.collection('users');
      ref.doc(user!.uid).set({
        'name': txtName.text, 
        'mobile': txtMobile.text,
        'address': txtAddress.text, 
        'email': emailController.text, 
        'profile_url': '',
      });
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginView(),  // Navigate to OnBoardingView after successful login
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  void btnSignUp() {

    if (txtName.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterName, () {});
      return;
    }

    if (!emailController.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtMobile.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterMobile, () {});
      return;
    }

    if (txtAddress.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterAddress, () {});
      return;
    }

    if (passwordController.text.length < 6) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    if (passwordController.text != passwordController.text) {
      mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
      return;
    }

    endEditing();


    registerUser();
    // serviceCallSignUp({
    //   "name": txtName.text,

    //   "mobile": txtMobile.text,
    //   "email": emailController.text,
    //   "address": txtAddress.text,
    //   "password": passwordController.text,
    //   "push_token": "",
    //   "device_type": Platform.isAndroid ? "A" : "I"
    // });
  }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Add your details to sign up",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Name",
                controller: txtName,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Mobile No",
                controller: txtMobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Address",
                controller: txtAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
               const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Confirm Password",
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(title: "Sign Up", onPressed: () {
                btnSignUp();
                //  Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const OTPView(),
                //       ),
                //     );
              }),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Action
  // void btnSignUp() {

  //   if (txtName.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterName, () {});
  //     return;
  //   }

  //   if (!emailController.text.isEmail) {
  //     mdShowAlert(Globs.appName, MSG.enterEmail, () {});
  //     return;
  //   }

  //   if (txtMobile.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterMobile, () {});
  //     return;
  //   }

  //   if (txtAddress.text.isEmpty) {
  //     mdShowAlert(Globs.appName, MSG.enterAddress, () {});
  //     return;
  //   }

  //   if (passwordController.text.length < 6) {
  //     mdShowAlert(Globs.appName, MSG.enterPassword, () {});
  //     return;
  //   }

  //   if (passwordController.text != passwordController.text) {
  //     mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
  //     return;
  //   }

  //   endEditing();


  //   registerUser();
  //   // serviceCallSignUp({
  //   //   "name": txtName.text,

  //   //   "mobile": txtMobile.text,
  //   //   "email": emailController.text,
  //   //   "address": txtAddress.text,
  //   //   "password": passwordController.text,
  //   //   "push_token": "",
  //   //   "device_type": Platform.isAndroid ? "A" : "I"
  //   // });
  // }

  //TODO: ServiceCall

  // void serviceCallSignUp(Map<String, dynamic> parameter) {
  //   Globs.showHUD();

  //   ServiceCall.post(parameter, SVKey.svSignUp,
  //       withSuccess: (responseObj) async {
  //     Globs.hideHUD();
  //     if (responseObj[KKey.status] == "1") {
  //       Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
  //       Globs.udBoolSet(true, Globs.userLogin);
        
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const OnBoardingView(),
  //           ),
  //           (route) => false);
  //     } else {
  //       mdShowAlert(Globs.appName,
  //           responseObj[KKey.message] as String? ?? MSG.fail, () {});
  //     }
  //   }, failure: (err) async {
  //     Globs.hideHUD();
  //     mdShowAlert(Globs.appName, err.toString(), () {});
  //   });
  // }

}
