import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      children: const [
                        Text('Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        Text("This view is for developer mode only.",
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'UserID:\n${Supabase.instance.client.auth.currentUser?.id}\n',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16)),
                      Text(
                          'Email:\n${Supabase.instance.client.auth.currentUser?.email}\n',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16)),
                      Text(
                          'Phone:\n${(Supabase.instance.client.auth.currentUser?.phone) ?? "Not provided"}',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16)),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _signOutButton,
                  )
                ],
              ),
            )));
  }

  Widget get _signOutButton {
    return CupertinoButton(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      color: Colors.redAccent,
      onPressed: () async {
        await Supabase.instance.client.auth
            .signOut()
            .then((value) => {Navigator.pop(context)});
      },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Sign Out',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16)),
          ]),
    );
  }
}
