import 'package:flutter/material.dart';
import 'package:plant_app/Screens/details_update_page.dart';

class MangoTreeCard extends StatelessWidget {
  const MangoTreeCard({Key? key}) : super(key: key);

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsUpdatePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Tree Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 140,
                color: Colors.black.withOpacity(0.0),
                child: Image.asset(
                  'assets/img/mango.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Right side - Tree Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Year
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mango Tree',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '1 Year',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Status Text
                    const Text(
                      'The Sapling Planted Is Homegrown. It Is Growing True With No Tips Of Yellowing Or Leaf Dropping. The Environment And Is Showing Healthy Steady Growth.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Update Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () => _navigateToDetails(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
