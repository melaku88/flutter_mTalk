import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_talk/api/api.dart';
import 'package:m_talk/models/user_model.dart';
import 'package:m_talk/screens/home_screen.dart';
import 'package:m_talk/screens/login_screen.dart';
import 'package:m_talk/utilis/snackbar.dart';
import 'package:m_talk/widgets/text_field.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // =============================================================================
  File? selectedImage;
  bool _isloading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

// pick profile picture from memory
  chooseProfilePic() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return;
      } else {
        final tempImage = File(pickedImage.path);
        setState(() {
          selectedImage = tempImage;
        });
      }
    } on PlatformException catch (e) {
      return e;
    }
  }
  // catch profile picture from camera
  catchProfilePic() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) {
        return;
      } else {
        final tempImage = File(pickedImage.path);
        setState(() {
          selectedImage = tempImage;
        });
      }
    } on PlatformException catch (e) {
      return e;
    }
  }

  updateUser() async {
    setState(() {
      _isloading = true;
    });
    FocusScope.of(context).unfocus();

    try {
      if (selectedImage == null) {
        final userData = UserModel(
            id: widget.userData.id,
            username: usernameController.text.isNotEmpty
                ? usernameController.text.trim()
                : widget.userData.username,
            email: widget.userData.email,
            profilePic: widget.userData.profilePic,
            about: aboutController.text.isNotEmpty
                ? aboutController.text.trim()
                : widget.userData.about,
            isOnline: widget.userData.isOnline,
            createdAt: widget.userData.createdAt,
            lastActive: widget.userData.lastActive,
            pushToken: widget.userData.pushToken);

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(APIs.auth.currentUser!.uid)
            .update(userData.toJson())
            .then((value) {
          setState(() {
            _isloading = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        });
      } else {
        Reference ref = FirebaseStorage.instance
          .ref()
          .child('profilePic')
          .child('/${DateTime.now()}.jpg');
        UploadTask task = ref.putFile(File(selectedImage!.path));
        TaskSnapshot snapshot = await task.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        final userData = UserModel(
            id: widget.userData.id,
            username: usernameController.text.isNotEmpty
              ? usernameController.text.trim()
              : widget.userData.username,
            email: widget.userData.email,
            profilePic: downloadUrl,
            about: aboutController.text.isNotEmpty
              ? aboutController.text.trim()
              : widget.userData.about,
            isOnline: widget.userData.isOnline,
            createdAt: widget.userData.createdAt,
            lastActive: widget.userData.lastActive,
            pushToken: widget.userData.pushToken);

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(APIs.auth.currentUser!.uid)
            .update(userData.toJson())
            .then((value) {
          setState(() {
            _isloading = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isloading = false;
      });
      HandleSnackbar.snackBar(context, e.code);
    }
  }

  // =============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      floatingActionButton: OutlinedButton.icon(
        onPressed: () {
          HandleSnackbar.showProgressBar(context);
          APIs.auth.signOut();
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        },
        label: Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.logout, color: Colors.white),
        style: OutlinedButton.styleFrom(
            // foregroundColor: Colors.blue,
            side: BorderSide(color: const Color.fromARGB(255, 221, 168, 8)),
            backgroundColor: Color.fromARGB(255, 224, 171, 11)),
      ),
      body: InkWell(
        onTap: () {
        FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      selectedImage == null? ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          height: 130.0,
                          width: 130.0,
                          fit: BoxFit.cover,
                          imageUrl: widget.userData.profilePic,
                          placeholder: (context, url) =>CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>CircleAvatar(
                            backgroundColor: Colors.lightBlue,
                            child: Text(widget.userData.username.substring(0, 1).toUpperCase().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 50.0),
                              )
                            )
                          )
                      ): CircleAvatar(
                        radius: 65.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.file(
                            selectedImage!, 
                            fit: BoxFit.cover,
                          )
                        )
                      ),
                      Positioned(
                        bottom: -4.0,
                        right: 0.0,
                        child: IconButton(
                          onPressed: () {
                            // chooseProfilePic();
                            _showBottomModelSheet();
                          },
                          color: Colors.white,
                          icon: Icon(
                            Icons.edit,
                            size: 20.0,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Color.fromRGBO(16, 115, 160, 0.7),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Text(widget.userData.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Username:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  MyTextField(
                    onTap: () {},
                    lable: widget.userData.username,
                    controller: usernameController,
                    obsecure: false,
                    textInputType: TextInputType.text,
                    hintText: 'enter your username',
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'About:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  MyTextField(
                    onTap: () {},
                    lable: widget.userData.about,
                    controller: aboutController,
                    obsecure: false,
                    textInputType: TextInputType.text,
                    hintText: 'enter your username',
                    icon: Icons.info,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      updateUser();
                    },
                    label: _isloading ? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ) : Text('Update',style: TextStyle(color: Colors.white),),
                    icon: Icon(Icons.edit, color: Colors.white),
                    style: OutlinedButton.styleFrom(
                        // foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.lightBlue),
                      backgroundColor: Colors.lightBlue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 void _showBottomModelSheet(){
    showModalBottomSheet(context: context,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0)
      )
      ),
      builder: (context){
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        children: [
          Text('Pick Profile Picture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1
            ),
          ),

          SizedBox(height: 30.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: (){
                      chooseProfilePic();
                      Navigator.pop(context);
                    }, 
                    icon: Icon(
                      Icons.upload_file_rounded,
                      color: Colors.lightBlue,
                      size: 40.0,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.lightBlue.withOpacity(0.1)
                    ),
                  ),
                  Text('from memory',
                    style: TextStyle(fontSize: 11.0, letterSpacing: 0.2),)
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: (){
                      catchProfilePic();
                      Navigator.pop(context);
                    }, 
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 40.0,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.lightBlue.withOpacity(0.1)
                    ),
                  ),
                  Text('from camera',
                    style: TextStyle(fontSize: 11.0, letterSpacing: 0.2),)
                ],
              )
            ],
          )
        ],
      );
    });
  }
}
