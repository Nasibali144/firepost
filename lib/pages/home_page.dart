import 'package:firepost/model/post_model.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/signin_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  static final String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Post> items = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadPost();
  }

  _apiLoadPost() async {
    var id = await Pref.loadUserId();
    RTDBService.loadPosts(id).then((posts) => {
      _resPost(posts)
    });
  }
  _resPost(List<Post> post) {
    setState(() {
      items = post;
    });
  }

  Future _openDetailPage() async {
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context){
          return new DetailPage();
        }
    ));
    if(results != null && results.containsKey("data")){
      print(results['data']);
      _apiLoadPost();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All post'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app_sharp), onPressed: (){
            AuthService.signOutUser(context);
            Navigator.pushReplacementNamed(context, SignInPage.id);
          })
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return _itemOfList(items[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _itemOfList(Post post) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: TextStyle(color: Colors.black, fontSize: 20),),
          SizedBox(height: 10,),
          Text(post.content, style: TextStyle(color: Colors.black, fontSize: 16),)
        ],
      ),
    );
  }
}
