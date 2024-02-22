import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/views/account/login_view.dart';
import 'package:greenplay/views/account/profile_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: RawMaterialButton(
        fillColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        shape: const CircleBorder(),
        onPressed: () {
          HapticFeedback.selectionClick();
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context) =>
                  Supabase.instance.client.auth.currentUser != null
                      ? const ProfileView()
                      : const LoginView());
        },
        child: Icon(CupertinoIcons.person_fill,
            color: Theme.of(context).primaryColor, size: 30),
      ),
    );
  }
}
