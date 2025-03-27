import 'package:flutter/material.dart';

class SearchSelectDialog extends StatefulWidget {
  final List<String> items;
  final String title;

  const SearchSelectDialog({super.key, required this.items, required this.title});

  @override
  _SearchSelectDialogState createState() => _SearchSelectDialogState();
}

class _SearchSelectDialogState extends State<SearchSelectDialog> {
  late List<String> filteredItems;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]),
                  onTap: () {
                    Navigator.pop(context, filteredItems[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> showSearchSelectDialog(
    BuildContext context, List<String> items, String title) async {
  final selectedValue = await showDialog<String>(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on outside click
    builder: (context) => SearchSelectDialog(items: items, title: title),
  );
  return selectedValue;
}
