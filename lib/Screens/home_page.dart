import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plant_app/widgets/custom_app_bar.dart';
import 'package:plant_app/widgets/mango_tree_card.dart';
import 'package:plant_app/widgets/performanceMeter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // NEW: Image list for each plant status
  final List<String> plantImages = [
    'assets/img/seedling.png',
    'assets/img/sapling.png',
    'assets/img/tree.png',
    'assets/img/dead_plant.png',
  ];

  final List<String> statusLabels = [
    'Seedling',
    'Sapling',
    'Tree',
    'Dead Plant'
  ];

  int selectedStatusIndex = 0; // NEW: Track selected tab

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // UPDATED: Dynamic Plant Image
            // Blurred background + tree image
            Stack(
              alignment: Alignment.center,
              children: [
                // Full-width blurred background
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Image.asset(
                        'assets/img/treeBackground.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Tree image on top
                Image.asset(
                  plantImages[selectedStatusIndex],
                  height: 150,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // UPDATED: Status Chips with functionality
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(statusLabels.length, (index) {
                return ChoiceChip(
                  label: Text(statusLabels[index]),
                  selected: selectedStatusIndex == index,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedStatusIndex = index;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 10),

            // Existing MangoTreeCard
            MangoTreeCard(),

            const SizedBox(height: 20),

            // Performance Section
            Text(
              'Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    PerformanceMeter(
                      value: 45,
                    ),
                    SizedBox(
                      width: screenWidth * 0.4,
                    ),
                    PerformanceMeter(
                      value: 65,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
