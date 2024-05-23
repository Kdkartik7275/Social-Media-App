import 'package:flutter/material.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    Key? key,
    this.showBackArrow = false,
    this.title,
    this.leadingOnPressed,
    this.centreTitle = true,
    this.leadingIconColor = Colors.white,
    this.actions,
    this.leadingIcon,
  }) : super(key: key);

  final bool showBackArrow;
  final Widget? title;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;
  final IconData? leadingIcon;
  final bool centreTitle;
  final Color leadingIconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AppBar(
        centerTitle: centreTitle,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => TNavigators.navigatePop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: leadingIconColor,
                ))
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(
                      leadingIcon,
                      color: leadingIconColor,
                    ))
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
