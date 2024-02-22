import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../viewmodels/rental/active_rental_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                    child: Text(AppLocalizations.of(context)!.getStarted,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  ),
                  Text(AppLocalizations.of(context)!.loginToRentDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _appleSocialButton,
                  ),
                  _googleSocialButton,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                    child: Text(
                        AppLocalizations.of(context)!.termsAndConditions,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.grey)),
                  ),
                  const Spacer(),
                ],
              ),
            )));
  }

  Widget get _appleSocialButton {
    return CupertinoButton(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      color: Colors.black,
      onPressed: () async {
        final success = await Supabase.instance.client.auth.signInWithOAuth(
          Provider.apple,
          redirectTo: 'greenplay://login-callback/',
        );
        if (success) {
          if (!mounted) return;
          provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
              .fetchActiveRental();
          Navigator.pop(context);
        }
      },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.apple,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 7),
            Text(AppLocalizations.of(context)!.appleLogin,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16)),
          ]),
    );
  }

  Widget get _googleSocialButton {
    return CupertinoButton(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      color: const Color.fromARGB(255, 177, 37, 27),
      onPressed: () async {
        final success = await Supabase.instance.client.auth.signInWithOAuth(
          Provider.google,
          redirectTo: 'greenplay://login-callback/',
        );
        if (success) {
          if (!mounted) return;
          provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
              .fetchActiveRental();
          Navigator.pop(context);
        }
      },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.google,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 7),
            Text(AppLocalizations.of(context)!.googleLogin,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16)),
          ]),
    );
  }
}
