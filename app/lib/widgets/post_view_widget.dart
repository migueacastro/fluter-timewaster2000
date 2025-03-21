import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/post_item_widget.dart';
import 'package:app/utils/post.dart';



class ScrollControllerWidget extends StatefulWidget {
  const ScrollControllerWidget({super.key});

  @override
  State<ScrollControllerWidget> createState() => _ScrollControllerWidgetState();
}

class _ScrollControllerWidgetState extends State<ScrollControllerWidget> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  late int _numberOfPostsPerRequest;
  late List<Post> _posts;
  late ScrollController _scrollController;

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://jsonplaceholder.typicode.com/posts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest",
        ),
      );
      List responseList = json.decode(response.body);
      List<Post> fetchedPostList =
          responseList
              .map((data) => Post(data['title'], data['body']))
              .toList();

      setState(() {
        _isLastPage = fetchedPostList.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber++;
        _posts.addAll(fetchedPostList);
      });
    } catch (e) {
      //print("Error; $e");
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  Widget errorDialogWidget({required double size}) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ha ocurrido un error buscando los posts.",
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              setState(() {
                _loading = true;
                _error = false;
                fetchData();
              });
            },
            child: const Text(
              "Retry",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _numberOfPostsPerRequest = 10;
    _scrollController = ScrollController();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
// nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger = 0.2 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed 
      if (_scrollController.position.pixels > nextPageTrigger) {
        _loading = true;
        fetchData();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildPostsView(),
    );
  }

  Widget buildPostsView() {
    if (_posts.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: errorDialogWidget(size: 20)
        );
      }
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {

          if (index == _posts.length) {
            if (_error) {
              return Center(
                  child: errorDialogWidget(size: 15)
              );
            }
            else {
              return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ));
            }
          }

            final Post post = _posts[index];
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: PostItemWidget(title:post.title,body:post.body)
            );
        }
        );
  }
}
