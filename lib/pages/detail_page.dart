import 'package:firepost/model/post_model.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {

  static final String id = 'detail_page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var titleController = new TextEditingController();
  var contentController = new TextEditingController();

  void _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if (title.isEmpty || content.isEmpty) return;

    var id = await Pref.loadUserId();

    RTDBService.storePost(Post(userId: id, title: title, content: content)).then((value) => {
      _respAddPost()
    });
  }

  _respAddPost() {
    Navigator.of(context).pop({'data' : 'done'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 15,),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title'
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                    hintText: 'Content'
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 45,
                width: double.infinity,
                child: FlatButton(
                  onPressed: _addPost,
                  child: Text('Add'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
