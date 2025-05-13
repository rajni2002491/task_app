import 'package:flutter/material.dart';

class InputDialog extends StatelessWidget {
  InputDialog({super.key});

  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_task, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: inputController,
              autofocus: true,
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (inputController.text.trim().isNotEmpty) {
                      Navigator.pop(context, inputController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
