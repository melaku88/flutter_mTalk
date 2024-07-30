import 'package:flutter/material.dart';

class HandleSnackbar{
   static void snackBarSuccs(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromARGB(255, 26, 138, 84),
        content: Center(
          child: Text(message, style: TextStyle(
            color: Colors.white
          ),),
        )
      )
    );
  }

  static void snackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Center(
          child: Text(message, style: TextStyle(
            color: Colors.white
          ),),
        )
      )
    );
  }

   static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
        )
      )
    );
  }
}