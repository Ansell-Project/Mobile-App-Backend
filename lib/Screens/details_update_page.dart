import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DetailsUpdatePage extends StatefulWidget {
  const DetailsUpdatePage({Key? key}) : super(key: key);

  @override
  State<DetailsUpdatePage> createState() => _DetailsUpdatePageState();
}

class _DetailsUpdatePageState extends State<DetailsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _plantImage;

  final List<String> _plantAge = ['3 month', '6 month', '1 year', '2 year'];
  final List<String> _transport = ['By Car', 'By Bike', 'By Bus'];
  final List<String> _fuelType = ['Petrol', 'Diesel'];

  String? _selectedPlantAge;
  String? _selectedTransport;
  String? _selectedFuelType;
  String? _locationDisplay = 'Fetching location...';

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diameterController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  Position? _currentPosition;
  final defaultColombo = const GeoPoint(6.9271, 79.8612);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentPosition = null;
        _locationDisplay = 'Using default (Colombo)';
        setState(() {});
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _currentPosition = null;
        _locationDisplay = 'Using default (Colombo)';
        setState(() {});
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      _locationDisplay =
          'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, '
          'Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}';
    } catch (e) {
      _locationDisplay = 'Error getting location, using default';
    }

    setState(() {});
  }

  Future<String?> _uploadToImgur(File imageFile, String fileName) async {
    const clientId = '59af59eff2a4ae6';
    final url = Uri.parse('https://api.imgur.com/3/image');
    final imageBytes = await imageFile.readAsBytes();

    final response = await http.post(
      url,
      headers: {'Authorization': 'Client-ID $clientId'},
      body: {'image': base64Encode(imageBytes), 'name': fileName},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data']['link'];
    }
    return null;
  }

  Future<void> _onUpdate() async {
    if (_plantImage == null ||
        _selectedPlantAge == null ||
        _selectedTransport == null ||
        _selectedFuelType == null ||
        _descriptionController.text.isEmpty ||
        _diameterController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _distanceController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter all values")));
      return;
    }

    final distance = double.tryParse(_distanceController.text);
    if (distance == null || distance < 0 || distance > 30) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Distance must be 0-30")));
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final imageLink = await _uploadToImgur(_plantImage!, 'plant_${user.uid}');
      if (imageLink == null) throw Exception('Imgur upload failed');

      final now = DateTime.now();
      final formattedDate = DateFormat('dd/MM/yy').format(now);

      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await docRef.update({
        'Plant_Age': 0,
        'plant_given_date': formattedDate,
        'plant_image_link': imageLink,
        'description': _descriptionController.text,
        'circumference_tree': double.parse(_diameterController.text),
        'height_tree': double.parse(_heightController.text),
        'transport_method': _selectedTransport,
        'fuel_type': _selectedFuelType,
        'distance': distance,
        'plant_location': _currentPosition != null
            ? GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude)
            : defaultColombo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plant details updated!')),
      );

      // Clear all fields
      setState(() {
        _plantImage = null;
        _selectedPlantAge = null;
        _selectedTransport = null;
        _selectedFuelType = null;
        _descriptionController.clear();
        _diameterController.clear();
        _heightController.clear();
        _distanceController.clear();
      });

      // Navigate to HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update plant details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Update Plant Details'),
          backgroundColor: Colors.green.shade700),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Text('Upload Your Plant Photo Here!',
                style: TextStyle(fontSize: 20, color: Colors.green.shade700)),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final XFile? picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _plantImage = File(picked.path));
                  }
                },
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade700),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _plantImage == null
                      ? Center(
                          child: Icon(Icons.add_a_photo,
                              size: 40, color: Colors.green.shade700))
                      : Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_plantImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _plantImage = null),
                              child: const CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.close, size: 16)),
                            ),
                          ),
                        ]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDropdown(_selectedPlantAge, 'Select age of the plant',
                _plantAge, (val) => setState(() => _selectedPlantAge = val)),
            _buildNumberField(
                _diameterController, 'Enter diameter of the stem'),
            _buildNumberField(_heightController, 'Enter height of the plant'),
            _buildLocationDisplay(),
            _buildTextArea(_descriptionController, 'Enter description'),
            _buildDropdown(_selectedTransport, 'Select transport method',
                _transport, (val) => setState(() => _selectedTransport = val)),
            _buildNumberField(_distanceController, 'Enter Distance'),
            _buildDropdown(_selectedFuelType, 'Select fuel type', _fuelType,
                (val) => setState(() => _selectedFuelType = val)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onUpdate,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14)),
              child: const Text('Update', style: TextStyle(fontSize: 18)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildDropdown(String? value, String hint, List<String> items,
      Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(16),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildLocationDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(Icons.location_on, color: Colors.green.shade700),
        const SizedBox(width: 10),
        Expanded(child: Text(_locationDisplay ?? 'Location not available')),
      ]),
    );
  }
}
