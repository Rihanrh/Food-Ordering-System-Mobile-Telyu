import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class SelectTableWidget extends StatelessWidget {
  final Function(int) onTableSelected; // Callback function to pass selected table

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
      // result is a List<String> containing entered text from text fields
      String enteredText = result.single;
      // Assume entered text is the selected table
      int selectedTable = int.tryParse(enteredText) ?? 0; // Default to 0 if parsing fails
      // Call the callback function to pass the selected table
      onTableSelected(selectedTable);
    } else {
      // User pressed cancel
      print('User canceled dialog');
    }
  }
}
