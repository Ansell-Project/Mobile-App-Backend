import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  ProfileCard({Key? key})
      : preferredSize = const Size.fromHeight(200.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0D483B),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D483B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'W.H.T. Shavinda Manwasinghe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'UX Designer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
