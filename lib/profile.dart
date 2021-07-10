import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:p/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'auth.dart';
import 'drawer.dart';
import 'models/post.dart';
import 'models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List<Post>> futurePosts;
  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    List<Post> posts = new List<Post>();
    String token =await Provider.of<AuthProvider>(context, listen: false).getToken();
    final response = await http.get(
        '$API_URL/userposts' , headers: {
      'Authorization': 'Bearer $token',
    }
        );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        posts.add(Post.fromJson(data[i]));
      }
      return posts;
    } else {
      throw Exception('Problem loading posts');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.teal,
      ),
      drawer: NavDrawer(),
      body: Column(
        children: [
          UserInfo(),
          PostListBuilder(futurePosts: futurePosts),
        ],
      ),
    );
  }
}

class PostListBuilder extends StatelessWidget {
  const PostListBuilder({
    Key key,
    @required this.futurePosts,
  }) : super(key: key);

  final Future<List<Post>> futurePosts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Post post = snapshot.data[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                  child: Card(
                      shadowColor: Colors.black,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${post.title}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 10, 10, 20),
                            child: ExpandableText(
                              '${post.content}',
                              trimLines: 5,
                            ),
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(60, 0, 0, 0)),
                              Text('${post.created_at}'),
                              Padding(
                                padding: EdgeInsets.only(left: 200),
                                child: Icon(
                                  Icons.more_vert,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                );
              },
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 5,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(color: colorClickableText, fontSize: 20),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
            text: widget.text,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepOrange, Colors.pinkAccent])),
            child: Container(
              width: double.infinity,
              height: 350.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.OvQzNbdxGYBkWT7cyvmP-wHaHa%26pid%3DApi&f=1",
                      ),
                      radius: 50.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Abebe',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 22.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Posts",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.pinkAccent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
        Padding(padding: EdgeInsets.all(10)),
        Text(
          "My Posts",
          style: TextStyle(color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(bottom: 30))
      ],
    );
  }
}
