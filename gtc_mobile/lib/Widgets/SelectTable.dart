import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class SelectTableWidget extends StatelessWidget {
  final Function(int) onTableSelected; 

  SelectTableWidget({required this.onTableSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Table'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showTextInputDialog(context);
          },
          child: Text('Open Text Input Dialog'),
        ),
      ),
    );
  }

  Future<void> _showTextInputDialog(BuildContext context) async {
    final result = await showTextInputDialog(
      context: context,
      textFields: [DialogTextField()],
      title: 'Enter Text',
      message: 'Please enter some text:',
      okLabel: 'OK',
      cancelLabel: 'Cancel',
    );

    if (result != null) {

      String enteredText = result.single;

      int selectedTable = int.tryParse(enteredText) ?? 0;

      onTableSelected(selectedTable);
    } else {

      print('User canceled dialog');
    }
  }
}
