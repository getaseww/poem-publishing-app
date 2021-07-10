class Post {
  final int id;
  final String title;
  final String content;
  final String created_at;
  final String auther;
  Post({this.id, this.title, this.content, this.auther, this.created_at});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      auther: json['auther'],
      created_at: json['created_at'],
    );
  }
}
