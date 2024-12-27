import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'posepage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _selectedLevel = "beginner"; // Default selected level
  List<dynamic> _poses = []; // Stores the fetched poses

  Future<void> fetchPoses(String level) async {
    final url = 'https://yoga-api-nzy4.onrender.com/v1/poses?level=$level';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map<String, dynamic> && data.containsKey('poses')) {
        setState(() {
          _poses = data['poses']; // Extract the list of poses
          _selectedLevel = level;
        });
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception('Failed to load poses for $level');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPoses("beginner"); // Load beginner poses by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Poses'),
      ),
      body: Column(
        children: [
          // Buttons for selecting levels
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => fetchPoses("beginner"),
                  child: Text("Beginner"),
                ),
                ElevatedButton(
                  onPressed: () => fetchPoses("intermediate"),
                  child: Text("Intermediate"),
                ),
                ElevatedButton(
                  onPressed: () => fetchPoses("expert"),
                  child: Text("Expert"),
                ),
              ],
            ),
          ),
          // Title to point which is the chosen level.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Level: $_selectedLevel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // List of poses from the specified level
          Expanded(
            child: _poses.isEmpty
                ? Center(
              child: Text('No poses available.'),
            )
                : ListView.builder(
              itemCount: _poses.length,
              itemBuilder: (context, index) {
                final pose = _poses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: pose['url_png'] != null
                        ? Image.network(
                      pose['url_png'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PosePage(
                              poseId: pose['id'], // Pass pose ID to PosePage
                            ),
                          ),
                        );
                      },
                      child: Text(
                        pose['english_name'] ?? 'Unknown Pose',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    subtitle: Text(
                        pose['sanskrit_name_adapted'] ?? 'No Sanskrit Name'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}