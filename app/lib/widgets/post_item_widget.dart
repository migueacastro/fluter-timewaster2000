import 'package:flutter/material.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({super.key, required this.title, required this.body});
  final String title, body;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: colors.primary,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  body,
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
