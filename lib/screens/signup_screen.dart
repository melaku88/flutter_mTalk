import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:m_talk/models/user_model.dart';
import 'package:m_talk/screens/home_screen.dart';
import 'package:m_talk/screens/login_screen.dart';
import 'package:m_talk/utilis/snackbar.dart';
import 'package:m_talk/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  // ====================================================================

  var mq;
  bool isPasswordVisible = false;
  bool _isloading = false;
  File? selectedImage;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat(reverse: true);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // handle password visibility
  void handlePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  // // choose profile picture
  // chooseProfilePic() async {
  //   try {
  //     final pickedImage =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedImage == null) {
  //       return;
  //     } else {
  //       final tempImage = File(pickedImage.path);
  //       setState(() {
  //         selectedImage = tempImage;
  //       });
  //     }
  //   } on PlatformException catch (e) {
  //     return e;
  //   }
  // }

  // handle registration
  signupUser() async {
    setState(() {
      _isloading = true;
    });
    FocusScope.of(context).unfocus();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        if (email.contains('@')) {
          if (email.split('@')[0].isNotEmpty) {
            if (password.length >= 6) {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, password: password);

              // Reference ref = FirebaseStorage.instance
              //     .ref()
              //     .child('profilePic')
              //     .child('/${DateTime.now()}.jpg');
              // UploadTask task = ref.putFile(File(selectedImage!.path));
              // TaskSnapshot snapshot = await task.whenComplete(() => null);
              // String downloadUrl = await snapshot.ref.getDownloadURL();

              // await APIs.signupUser(username, email, password, downloadUrl);

              // UserModel userModel =
              //     UserModel(username, email, '', downloadUrl);
              final time = DateTime.now().millisecondsSinceEpoch.toString();
              final userData = UserModel(
                  id: auth.currentUser!.uid,
                  username: username,
                  email: email,
                  profilePic: '',
                  about: 'Hey, I\'am Using MT',
                  isOnline: false,
                  createdAt: time,
                  lastActive: time,
                  pushToken: '');

              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(auth.currentUser!.uid)
                  .set(userData.toJson()).then(
                      (value) {
                setState(() {
                  _isloading = false;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                });
              });
            } else {
              setState(() {
                _isloading = false;
              });
              HandleSnackbar.snackBar(
                  context, 'your password must have more than 5 charactrs');
            }
          } else {
            setState(() {
              _isloading = false;
            });
            HandleSnackbar.snackBar(context,
                'There must be atleast 1 character before "@" in your email');
          }
        } else {
          setState(() {
            _isloading = false;
          });
          HandleSnackbar.snackBar(context, 'Please enter a valid email!');
        }
      } else {
        setState(() {
          _isloading = false;
        });
        HandleSnackbar
            .snackBar(context, 'All fields are required!');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isloading = false;
      });
      HandleSnackbar.snackBar(context, e.code);
    }
  }

  // ====================================================================
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Already have an account?', style: TextStyle(fontSize: 15.0),),
        leading: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'images/icon.png',
            height: 30.0,
            width: 30.0,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              'LOGIN',
              style: TextStyle(color: Color.fromARGB(255, 62, 184, 240)),
            ),
          )
        ],
      ),
      body: InkWell(
        onTap: () {
        FocusScope.of(context).unfocus();
      },
        child: SingleChildScrollView(
          child: Container(
            width: mq.width,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    children: [
        
                      Image.asset(
                        'images/signup3.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Create new account with your email:',
                  style: TextStyle(color: Colors.lightBlue, letterSpacing: 1),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Column(
                  children: [
                    MyTextField(
                      onTap: () {},
                      lable: 'Username',
                      controller: usernameController,
                      obsecure: false,
                      textInputType: TextInputType.text,
                      hintText: 'enter your username',
                      icon: Icons.person_outlined,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    MyTextField(
                      onTap: () {},
                      lable: 'Email',
                      controller: emailController,
                      obsecure: false,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'enter your valid email',
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    MyTextField(
                      onTap: () {
                        handlePasswordVisibility();
                      },
                      lable: 'Password',
                      controller: passwordController,
                      obsecure: isPasswordVisible ? false : true,
                      textInputType: TextInputType.text,
                      hintText: 'enter your password',
                      icon: isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    )
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                MaterialButton(
                  onPressed: () {
                    signupUser();
                  },
                  color: Colors.lightBlue,
                  child: _isloading
                      ? Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
