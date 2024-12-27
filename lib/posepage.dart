import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PosePage extends StatefulWidget {
  final int poseId; // Pose ID passed from HomePage

  const PosePage({required this.poseId, Key? key}) : super(key: key);

  @override
  State<PosePage> createState() => _PosePageState();
}

class _PosePageState extends State<PosePage> {
  Map<String, dynamic>? _poseDetails;

  Future<void> fetchPoseDetails() async {
    final url = 'https://yoga-api-nzy4.onrender.com/v1/poses?id=${widget.poseId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _poseDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load pose details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPoseDetails(); // Fetch pose details when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Details'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding =
          constraints.maxWidth > 800 ? 200.0 : 16.0; // Adjust padding

          return _poseDetails == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_poseDetails!['url_png'] != null)
                  Center(
                    child: Image.network(
                      _poseDetails!['url_png'],
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Name: ' + _poseDetails!['english_name'] ?? 'Unknown Pose',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sanskrit Name: ' +
                      _poseDetails!['sanskrit_name'] ??
                      'No Sanskrit Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adapted Sanskrit Name: ' +
                      _poseDetails!['sanskrit_name_adapted'] ??
                      'No Adaptation for Sanskrit Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description:',
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_poseDetails!['pose_description'] ??
                    'No description available'),
                const SizedBox(height: 16),
                Text(
                  'Benefits:',
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_poseDetails!['pose_benefits'] ?? 'No benefits listed'),
              ],
            ),
          );
        },
      ),
    );
  }
}