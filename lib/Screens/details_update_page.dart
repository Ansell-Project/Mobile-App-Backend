import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailsUpdatePage extends StatefulWidget {
  const DetailsUpdatePage({Key? key}) : super(key: key);

  @override
  State<DetailsUpdatePage> createState() => _DetailsUpdatePageState();
}

class _DetailsUpdatePageState extends State<DetailsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // List to hold up to 9 plant images
  final List<File?> _plantImages = List.generate(9, (_) => null);

  // Form field controllers
  String? _selectedPlantAge;
  String? _selectedLocation;
  String? _selectedTransport;
  String? _selectedFuelType;
  final TextEditingController _descriptionController = TextEditingController();

  // Plant type options
  final List<String> _plantAge = [
    '3 month',
    '6 month',
    '1 year',
    '2 year',
    '3 year',
    '4 year',
    '5 year',
    '10 year',
    'Other'
  ];

  // Location options
  final List<String> _locations = [
    'Indoor',
    'Outdoor - Garden',
    'Outdoor - Balcony',
    'Outdoor - Yard',
    'Greenhouse',
    'Community Garden',
    'Other'
  ];

  // transport options
  final List<String> _transport = [
    'By Transport',
    'By Car',
    'By Bike',
    'By Bus'
  ];

  //fuelt type
  final List<String> _fueltype = ['Petrol', 'Desel'];

  // Function to pick an image
  Future<void> _pickImage(int index) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _plantImages[index] = File(pickedImage.path);
      });
    }
  }

  // Function to calculate estimated CO2 absorption
  String _calculateCO2Absorption() {
    // This is a simplified calculation
    if (_selectedPlantAge == null) return '0';

    // Very basic estimation based on plant type
    // In a real app, this would be more sophisticated
    switch (_selectedPlantAge) {
      case '3 months':
        return '21.8';
      case '6 months':
        return '6.4';
      case '1 year':
        return '1.2';
      case '2 year':
        return '2.1';
      case '3 year':
        return '0.8';
      case '4 year':
        return '0.9';
      case '5 year':
        return '1.6';
      case '10 year':
        return '5.2';
      default:
        return '1.0';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Plant Details'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Upload Your Plant Photos Here!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),

                // Photo upload grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(9, (index) {
                    return _buildImagePickerBox(index);
                  }),
                ),

                const SizedBox(height: 30),

                Text(
                  "Plant Details ",
                  style: TextStyle(fontSize: 12),
                ),
                Divider(
                  thickness: 3,
                ),
                const SizedBox(height: 12),
                // Plant type dropdown
                _buildDropdown(
                  value: _selectedPlantAge,
                  hint: 'Select age of the plant',
                  items: _plantAge,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlantAge = value;
                    });
                  },
                ),

                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter diameter of the stem',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter height of the plant',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Location dropdown
                _buildDropdown(
                  value: _selectedLocation,
                  hint: 'Select the location',
                  items: _locations,
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Description text field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Text(
                  "Your Details ",
                  style: TextStyle(fontSize: 12),
                ),
                Divider(
                  thickness: 3,
                ),

                const SizedBox(height: 15),
                // Second plant type dropdown (could be species or other categorization)
                _buildDropdown(
                  value: _selectedTransport,
                  hint: 'Select transport method',
                  items: _transport,
                  onChanged: (value) {
                    setState(() {
                      _selectedTransport = value;
                    });
                  },
                ),

                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Distance',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                _buildDropdown(
                  value: _selectedFuelType,
                  hint: 'Select fuel type',
                  items: _fueltype,
                  onChanged: (value) {
                    setState(() {
                      _selectedTransport = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // CO2 Absorption Info
                if (_selectedPlantAge != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco, color: Colors.green.shade800),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estimated CO₂ Absorption',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_calculateCO2Absorption()} kg per year',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),

                // Update button
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process and save data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Plant details updated successfully')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2E8B57),
                            Color(0xFF3CB371)
                          ], // Customize colors
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: 50), // Optional sizing
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the image picker boxes
  Widget _buildImagePickerBox(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green.shade700,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _plantImages[index] == null
          ? InkWell(
              onTap: () => _pickImage(index),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _plantImages[index]!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _plantImages[index] = null;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Helper method to build dropdown fields
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
