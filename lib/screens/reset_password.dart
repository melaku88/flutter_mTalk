import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_talk/utilis/snackbar.dart';
import 'package:m_talk/widgets/text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // ===============================================================
  bool _isLoading = false;
  bool _isReset = false;

  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    try {
      if (emailController.text.trim().isNotEmpty) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim())
            .then((value) {
          setState(() {
            _isLoading = false;
            _isReset = true;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
          HandleSnackbar.snackBar(context, 'Reset email is required!');
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      HandleSnackbar.snackBar(context, e.code);
    }
  }

  // ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Your Password'),
      ),
      body: InkWell(
        onTap: () { 
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              _isReset ? 
              Text('Your reset email is sent successfully! Please check your email and set your new password.',
              style: TextStyle(
                color: Colors.green.shade800
              ),) 
              : MyTextField(
                onTap: () {},
                lable: 'Write your valid email',
                controller: emailController,
                obsecure: false,
                textInputType: TextInputType.emailAddress,
                hintText: 'enter your valid email',
                icon: Icons.email_outlined,
              ),
              SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                onPressed: () {
                  resetPassword();
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
                        'SEND RESET EMAIL',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
