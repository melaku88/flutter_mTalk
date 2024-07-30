import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:m_talk/screens/home_screen.dart';
import 'package:m_talk/screens/reset_password.dart';
import 'package:m_talk/screens/signup_screen.dart';
import 'package:m_talk/utilis/snackbar.dart';
import 'package:m_talk/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ====================================================================
   var mq;
  bool isPasswordVisible = false;
  bool _isLoading = false;

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

   void handlePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  // handle login
  void loginUser()async{
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        });
      }else{
        setState(() {
          _isLoading = false;
        });
        HandleSnackbar.snackBar(context, 'All fields are required!');
      }
    }on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        HandleSnackbar.snackBar(context, e.code);
      });
    }
  }

  // ====================================================================
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Don\'t have an account yet?', style: TextStyle(fontSize: 15.0),),
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
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
            child: Text(
              'SIGN UP',
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
                        'images/login.png',
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'M Talk',
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  ),
                ),
                Text(
                  'Continoue login with your email:',
                  style: TextStyle(color: Colors.lightBlue, letterSpacing: 1),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Column(
                  children: [
                    MyTextField(
                      onTap: (){}, 
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
                      onTap: (){
                        handlePasswordVisibility();
                      }, 
                      lable: 'Password',
                      controller: passwordController, 
                      obsecure: isPasswordVisible ? false : true,  
                      textInputType: TextInputType.text, 
                      hintText: 'enter your password', 
                      icon: isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    )
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                MaterialButton(
                  onPressed: () {
                    loginUser();
                  },
                  color: Colors.lightBlue,
                  child: _isLoading
                      ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                SizedBox(height: 5.0,),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Forgot Password?',
                      style: TextStyle(
                        color: Colors.lightBlue
                      ),),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
