import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m_talk/models/user_model.dart';
import 'package:m_talk/screens/chat_screen.dart';

class MyChatCard extends StatefulWidget {
  final UserModel user;
  const MyChatCard({super.key, required this.user});
  @override
  State<MyChatCard> createState() => _MyChatCardState();
}
class _MyChatCardState extends State<MyChatCard> {
   
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(userData: widget.user)));
        },
        child: ListTile(
          // user profile picture
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              height: 55.0,
              width: 55.0,
              imageUrl: widget.user.profilePic,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => 
              CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text(widget.user.username.substring(0,1).toUpperCase().toString(),
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),)
              )
            ),
          ),

          // user name
          title: Text(widget.user.username, style: TextStyle(
            fontSize: 17.0
          ),),

          // user last message
          subtitle: Text(widget.user.about, maxLines: 1,style: TextStyle(
            color: Colors.black38,
            fontSize: 13.0
          ),),

          // last message time
          trailing: Text('12:00',
          style: TextStyle(
            color: Colors.black54
          ),),
        ),
      ),
    );
  }
}