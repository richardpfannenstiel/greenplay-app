import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenplay/views/account/login_view.dart';
import 'package:greenplay/views/account/profile_view.dart';
import 'package:greenplay/views/components/circular_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/search_textfield.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuickSelectGadgetsView extends StatefulWidget {
  const QuickSelectGadgetsView({super.key});

  @override
  State<QuickSelectGadgetsView> createState() => _QuickSelectGadgetsViewState();
}

class _QuickSelectGadgetsViewState extends State<QuickSelectGadgetsView> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                CircularImage(
                    imageString: 'assets/gadgets/volleyball.png',
                    size: 25,
                    backgroundColor: Colors.green),
                Spacer(),
                CircularImage(
                  imageString: 'assets/gadgets/table-tennis.png',
                  size: 25,
                  backgroundColor: Colors.green,
                ),
                Spacer(),
                CircularImage(
                    imageString: 'assets/gadgets/football.png',
                    size: 25,
                    backgroundColor: Colors.green),
                Spacer(),
                CircularImage(
                    imageString: 'assets/gadgets/frisbee.png',
                    size: 25,
                    backgroundColor: Colors.green),
                Spacer(),
                CircularImage(
                    imageString: 'assets/gadgets/tennis.png',
                    size: 25,
                    backgroundColor: Colors.green),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SearchTextField(
                          placeholder: AppLocalizations.of(context)!.searchFor,
                          fieldValue: (String value) {
                            setState(() {
                              text = value;
                            });
                          },
                        ))),
                SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    elevation: 0.0,
                    shape: const CircleBorder(),
                    onPressed: () => {
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              Supabase.instance.client.auth.currentUser != null
                                  ? const ProfileView()
                                  : const LoginView())
                    },
                    child: const Icon(CupertinoIcons.person_crop_circle_fill,
                        color: Colors.grey, size: 35),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
