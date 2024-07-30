import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_talk/api/api.dart';
import 'package:m_talk/models/user_model.dart';
import 'package:m_talk/screens/profile_screen.dart';
import 'package:m_talk/widgets/chat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // =============================================================================================
  // all users list
  List<UserModel> contactList = [];
  // search users list
  List<UserModel> searchLists = [];
  // controlle search icons
  bool _isSearching = false;




  //  late UserModel userData;

  //  getCurrentUser()async{
  //   DocumentSnapshot snapshot = await APIs.firestore.collection('Users').doc(APIs.auth.currentUser!.uid).get();
  //   if(snapshot.exists){
  //     setState(() {
  //     userData = UserModel(
  //       id: snapshot['id'], 
  //       username: snapshot['username'], 
  //       email: snapshot['email'], 
  //       profilePic: snapshot['profilePic'], 
  //       about: snapshot['about'], 
  //       isOnline: snapshot['isOnline'], 
  //       createdAt: snapshot['createdAt'], 
  //       lastActive: snapshot['lastActive'], 
  //       pushToken: snapshot['pushToken']
  //     );
  //   });

   @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }

  // =============================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? CupertinoTextField(
          onChanged: (value) {
            searchLists.clear();
            for(var i in contactList){
              if(i.username.substring(0, value.length).toLowerCase().contains(value.toLowerCase())){
                searchLists.add(i);
              }
              setState(() {
                searchLists;
              });
            }
          },
          cursorWidth: 1.0,
          autofocus: true,
          cursorColor: Colors.white70,
          style: TextStyle(color: Colors.white, fontSize: 14.0),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Icon(Icons.search, color: Colors.white54,),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white60),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ) : Text('Welcome back to MT group',
            style: TextStyle(
              fontSize: 17.0,
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 152, 214, 243)
            ),),
        leading: InkWell(
          onTap: () {},
          child: Icon(CupertinoIcons.home, size: 20.0,)
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              _isSearching = !_isSearching;
            });
          }, icon: _isSearching ? Icon(Icons.cancel) : Icon(Icons.search)
        ),

          _isSearching ? SizedBox() : IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (contex)=> ProfileScreen(userData: APIs.me,))
            );
            },
            icon: Icon(Icons.person_outline)),
        ],
      ),

      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: StreamBuilder(
          stream: APIs.getAllContacts(), 
          builder: (context, snapshot){
        
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Loading Contacts'),
                    SizedBox(height: 10.0,),
                    CircularProgressIndicator(
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
              );
              case ConnectionState.active:
              case ConnectionState.done:
              if(snapshot.hasError){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error While Loading Contacts!', 
                        style: TextStyle(
                        color: Colors.red, 
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ],
                  ),
                );
              }else{
        
                final data = snapshot.data!.docs;
                contactList = data.map((e) => UserModel.fromJson(e.data())).toList();
        
                return ListView.builder(
                  itemCount: _isSearching ? searchLists.length : contactList.length,
                  itemBuilder: (context, index){
                    return MyChatCard(user:_isSearching ? searchLists[index] : contactList[index]);
                  }
                );
              }
            }
          }
        ),
      )
    );
  }
}