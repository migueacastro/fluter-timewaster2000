import 'dart:convert';
import 'package:app/widgets/add_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/post_item_widget.dart';
import 'package:app/utils/post.dart';

class PostViewWidget extends StatefulWidget {
  const PostViewWidget({super.key});

  @override
  State<PostViewWidget> createState() => _PostViewWidgetState();
}

class _PostViewWidgetState extends State<PostViewWidget> {
  int page = 1;
  final _controller = ScrollController();
  bool hasMorePosts = true;
  List<Post> posts = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        fetchPosts();
      }
    });
    fetchPosts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _addIconOnPressed() {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => AddPostWidget(
            onSubmit: submitPost,
            titleController: _titleController,
            bodyController: _bodyController,
          ),
    );
  }

  Future fetchPosts() async {
    const limit = 15;

    final response = await http.get(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page',
      ),
    );
    final List<Post> data = List<Post>.from(
      json.decode(response.body).map((x) => Post.fromJson(x)),
    );

    setState(() {
      page++;
      if (data.length < limit) {
        hasMorePosts = false;
      }
      posts.addAll(data);
    });
  }

  Future submitPost() async {
    final post = Post(
      userId: 1,
      id: posts.length + 1,
      title: _titleController.text,
      body: _bodyController.text,
    );

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      setState(() {
        posts.insert(0, post); // Add the new post to the beginning of the list
        _titleController.clear();
        _bodyController.clear();
        Navigator.of(context).pop(); // Close the modal bottom sheet
      });
    }
  }

  Future refresh() async {
    setState(() {
      fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body:
          posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: _controller,
                padding: const EdgeInsets.all(8),
                itemCount:
                    posts.length +
                    1, // Add 1 for the loading indicator or "end" message
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    // Render the post item
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      child: PostItemWidget(title: post.title, body: post.body),
                    );
                  } else {
                    // Render the loading indicator or "end of list" message
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 30,
                      ),
                      child:
                          hasMorePosts
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(
                                child: Text("You reached the end"),
                              ),
                    );
                  }
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIconOnPressed,
        backgroundColor: colors.tertiary,
        child: Icon(Icons.add, color: colors.surface),
      ),
    );
  }
}
