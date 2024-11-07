import 'package:flutter/material.dart';

class ElbAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool leading;
  final bool drawer;
  final String text;
  final List<Widget> actions;
  final BuildContext context;

  const ElbAppBar(
      {super.key,
      required this.leading,
      required this.actions,
      required this.text,
      required this.context,
      required this.drawer});

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.sizeOf(context).width / 8);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).width / 8),
      child: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                blurRadius: 5,
                blurStyle: BlurStyle.outer,
                spreadRadius: 2)
          ]),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (drawer)
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                if (leading && !drawer)
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: actions,
      ),
    );
  }
}
