import 'package:flutter/cupertino.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.fieldValue,
    this.placeholder = "Search",
  });

  final ValueChanged<String> fieldValue;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: placeholder,
      onChanged: (String value) {
        fieldValue(value);
      },
      onSubmitted: (String value) {
        fieldValue(value);
      },
    );
  }
}
