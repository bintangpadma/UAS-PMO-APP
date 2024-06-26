import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/helpers/upload_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtProfileUrl = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    txtName.dispose();
    txtMobile.dispose();
    txtAddress.dispose();
    txtEmail.dispose();
    txtProfileUrl.dispose();
    super.dispose();
  }
  
  void loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference userRef = db.collection("users").doc(user.uid);

      try {
        DocumentSnapshot doc = await userRef.get();
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          txtName.text = data['name'];
          txtMobile.text = data['mobile'];
          txtAddress.text = data['address'];
          txtEmail.text = data['email'];
          txtProfileUrl.text = data['profile_url'];
        });
      } catch (e) {
        print("Error completing: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; 
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection("users").doc(user!.uid);

    void updateProfile() async {
      String profileUrl = await uploadSingleImage(image, "users");
      await userRef.update({
        "name": txtName.text,
        "mobile": txtMobile.text,
        "address": txtAddress.text,
        "profile_url": profileUrl,
      });
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrderView()));
                  },
                  icon: Image.asset(
                    "assets/img/shopping_cart.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColor.placeholder,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(File(image!.path),
                        width: 100, height: 100, fit: BoxFit.cover),
                  )
                : txtProfileUrl.text != "" ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(txtProfileUrl.text,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ) : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
          ),
          TextButton.icon(
            onPressed: () async {
              final pickedImage = await picker.pickImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                setState(() {
                  image = pickedImage;
                });
              }
            },
            icon: Icon(
              Icons.edit,
              color: TColor.primary,
              size: 12,
            ),
            label: Text(
              "Edit Profile",
              style: TextStyle(color: TColor.primary, fontSize: 12),
            ),
          ),
          Text(
            "Hi there ${txtName.text}!",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Sign Out",
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Name",
              hintText: "Enter Name",
              controller: txtName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              // keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Address",
              hintText: "Enter Address",
              controller: txtAddress,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtPassword,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //   child: RoundTitleTextfield(
          //     title: "Confirm Password",
          //     hintText: "* * * * * *",
          //     obscureText: true,
          //     controller: txtConfirmPassword,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(title: "Save", onPressed: updateProfile),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }
}
