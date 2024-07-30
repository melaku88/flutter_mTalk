import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_talk/api/api.dart';
import 'package:m_talk/models/message_model.dart';
import 'package:m_talk/utilis/date_time.dart';

class MessageCard extends StatefulWidget {
  final MessageModel messageData;
  const MessageCard({super.key, required this.messageData});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    return 
    APIs.currentUser.uid == widget.messageData.fromId 
      ? _buildGreenMessage() 
      : _buildBlueMessage();
  }


  Widget _buildBlueMessage(){
    if(widget.messageData.read.isEmpty){
      APIs.updateReadStatus(widget.messageData);
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            margin: EdgeInsets.only(right: 40.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 13, 127, 180),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.messageData.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                  ),),

                SizedBox(height: 5.0,),

                Text(TimeUtile.getFormattedTime(context: context, time: widget.messageData.sent),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.0
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGreenMessage(){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // checked icon
              if(widget.messageData.read.isNotEmpty)
              Icon(Icons.done_all_rounded, color: Colors.green.shade800, size: 20.0,),
      
              SizedBox(width: 5.0,),
              // read time
              if(widget.messageData.read.isNotEmpty)
              Text(TimeUtile.getFormattedTime(
                context: context, 
                time: widget.messageData.read),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.0
                ),
              ),
              if(widget.messageData.read.isEmpty)
              Icon(Icons.done_rounded, color: Colors.green.shade800, size: 20.0,),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              margin: EdgeInsets.only( left: 15.0),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30.0)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.messageData.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  ),

                  SizedBox(height: 5.0,),

                  Text(TimeUtile.getFormattedTime(
                    context: context, 
                    time: widget.messageData.sent),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}