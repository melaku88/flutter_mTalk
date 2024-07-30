import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_talk/api/api.dart';
import 'package:m_talk/models/message_model.dart';
import 'package:m_talk/models/user_model.dart';
import 'package:m_talk/screens/home_screen.dart';
import 'package:m_talk/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userData;
  const ChatScreen({super.key, required this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ======================================================================
  // to store all datas
  List<MessageModel> messageList = [];
  bool isTextSending = false;
  bool isImageSending = false;
  final TextEditingController messageController = TextEditingController();

  // ======================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 230, 247),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _buildAppBar(),
      ),

      body: Column(
        children: [
          Expanded(
      
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.userData), 
              builder:(context, snapshoot){
                switch(snapshoot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  return Container();
                  // Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Loading Messages'),
                  //       SizedBox(height: 10.0,),
                  //       CircularProgressIndicator(
                  //         color: Colors.lightBlue,
                  //       ),
                  //     ],
                  //   ),
                  // );
                  case ConnectionState.active:
                  case ConnectionState.done:
                  if(snapshoot.hasError){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error!',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 30.0
                          ),),
                          Text('Something went wrong while loading conversations',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0
                          ),),
                        ],
                      ),
                    );
                  }else{
                    final data = snapshoot.data!.docs;
                    messageList = data.map((e) => MessageModel.fromJson(e.data())).toList();
      
                    if(messageList.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Say hii 👋',
                            style: TextStyle(
                              color: Colors.black87, 
                              fontSize: 20.0
                            ),),
                          ],
                        ),
                      );
                    }else{
                      return ListView.builder(
                        itemCount: messageList.length,
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index){
                          return MessageCard(messageData: messageList[index]);
                        }
                    );
                    }
                  }
                }
              }
            ),
          ),
      
          // message textfield
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){},
                   icon: Icon(Icons.emoji_emotions, color: Colors.lightBlue,)
                ),
            
                // text field
                Expanded(
                  child: TextField(
                    controller: messageController,
                    cursorWidth: 1.5,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type Something....',
                      hintStyle: TextStyle(color: Colors.black26, letterSpacing: 1,fontSize: 14.0)
                    ),
                  ),
                ),
            
                IconButton(
                  onPressed: (){
                    _showBottomModelSheet();
                  },
                   icon: Icon(Icons.camera_alt, color: Colors.lightBlue,)
                ),
                  IconButton(
                  onPressed: (){
                    setState(() {
                      isTextSending = true;
                    });
                    FocusScope.of(context).unfocus();
                    if(messageController.text.isNotEmpty){
                      APIs.sendMessage(widget.userData, messageController.text.trim()).then((_){
                        messageController.clear();
                        setState(() {
                          isTextSending = false;
                        });
                    });
                    }else{
                      setState(() {
                        isTextSending = false;
                      });
                      return;
                    }
                  },
                   icon: isTextSending 
                    ? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.green.shade800,
                      ),
                    ) 
                    : Icon(Icons.send, color: Colors.green.shade800, size: 30,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget _buildAppBar(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // back Icon
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
          }, 
          icon: Icon(Icons.arrow_back, color: Colors.white60, size: 26.0,),
        ),

          SizedBox(width: 20.0,),
          // profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: CachedNetworkImage(
              height: 45.0,
              width: 45.0,
              imageUrl: widget.userData.profilePic,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => 
              CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Text(widget.userData.username.substring(0,1).toUpperCase().toString(),
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),)
              )
            ),
          ),
      
          SizedBox(width: 10.0,),
      
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userData.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0
                ),
              ),
              Text('last seen not aveliable',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13.0
                ),
              )
            ],
          )
        ],
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
          Text('Pick your image',
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
                      // chooseProfilePic();
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
                      // catchProfilePic();
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