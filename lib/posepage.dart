import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PosePage extends StatefulWidget {
  const PosePage({Key? key}) : super(key: key);

  @override
  State<PosePage> createState() => _PosePageState();
}

class _PosePageState extends State<PosePage> {
  Map<String, dynamic>? _poseDetails;
  int? _poseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('poseId')) {
      _poseId = args['poseId']; // Get poseId from arguments
      fetchPoseDetails();
    }
  }


  Future<void> fetchPoseDetails() async {
    if (_poseId == null) return;

    final url = 'https://yoga-api-nzy4.onrender.com/v1/poses?id=$_poseId';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Details'),
      ),
      body: _poseDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              )
            else
              const Center(
                child: Icon(Icons.image_not_supported, size: 100),
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${_poseDetails!['english_name'] ?? 'Unknown Pose'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sanskrit Name: ${_poseDetails!['sanskrit_name'] ?? 'No Sanskrit Name'}',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_poseDetails!['pose_description'] ?? 'No description available'),
            const SizedBox(height: 16),
            const Text(
              'Benefits:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_poseDetails!['pose_benefits'] ?? 'No information about pose benefits available.'),
          ],
        ),
      ),
    );
  }
}
