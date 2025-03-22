import 'package:flutter/material.dart';

class AddPostWidget extends StatelessWidget {
  const AddPostWidget({
    super.key,
    required this.titleController,
    required this.bodyController,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController bodyController;
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          spacing: 20,
          children: [
            Center(child: Text("Add post", style: TextStyle(fontSize: 35))),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                label: Text("Title"),
                filled: true,
                fillColor: colors.surfaceContainerLow,
              ),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                label: Text("Body"),
                filled: true,
                fillColor: colors.surfaceContainerLow,
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: colors.primary,
              onPressed: onSubmit,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.add, color: colors.onPrimary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
