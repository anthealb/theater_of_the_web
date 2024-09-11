import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'menu_bar.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MapMenuBar(),
        // Spacer(),
        // IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.clock)),
        // TextButton(
        //   onPressed: () {},
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [Text('user'), SizedBox(width: 8), CircleAvatar(maxRadius: 12)],
        //   ),
        // ),
        // SizedBox(width: 24),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
