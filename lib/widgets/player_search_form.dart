import 'package:flutter/material.dart';

class PlayerSearchForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController tagController;
  final VoidCallback onSearch;

  const PlayerSearchForm({
    super.key,
    required this.nameController,
    required this.tagController,
    required this.onSearch,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Search Player",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Summoner Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                ),
              ),
            ),

            SizedBox(width: 10),
            Text("#", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
            SizedBox(width: 10),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox (
                width: 80,
                child: TextField(
                  controller: tagController,
                  decoration: InputDecoration(
                    hintText: 'NA1',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
          ],
        ),

        ElevatedButton.icon (
          onPressed: onSearch,
          icon: Icon(Icons.search),
          label: Text("Search"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
            )
          ),
        ),
      ]
    );

  }
}