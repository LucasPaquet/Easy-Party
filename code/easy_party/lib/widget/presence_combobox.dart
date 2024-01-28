import 'package:easy_party/style/spacings.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class PresenceComboBox extends StatefulWidget {
  final TextEditingController controller;

  const PresenceComboBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _PresenceComboBoxState createState() => _PresenceComboBoxState();
}

class _PresenceComboBoxState extends State<PresenceComboBox> {
  // éléments de la liste
  List<String> items = ['Présent', 'Absent'];

  // variable par defaut
  String selectedValue = 'Présent';

  @override
  void initState() {
    super.initState();
    widget.controller.text = selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.controller.text = selectedValue;
        });
      },
      dropdownColor: kBoxColor,
      icon: const Icon(
          Icons.arrow_drop_down,
          color: kTextOnBGColor,
        ),
      underline: Container(),// enlever la ligne
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            color: kBoxColor,
            padding: const EdgeInsets.all(kPaddingMain),
            child: Text(
              value,
              style:
                  const TextStyle(color: kTextOnBoxColor), // Couleur du texte
            ),
          ),
        );
      }).toList(),
    );
  }
}
