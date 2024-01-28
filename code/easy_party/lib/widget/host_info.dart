import 'package:flutter/material.dart';

import '../style/colors.dart';

class HostInfo extends StatelessWidget {
  final String eventName;
  final int presentCount;
  final int waitingCount;
  final int absentCount;

  const HostInfo({
    required this.eventName,
    required this.presentCount,
    required this.waitingCount,
    required this.absentCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kBoxColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 6), // changes position of shadow
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Événement: $eventName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Présents: $presentCount',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'En attente: $waitingCount',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Absents: $absentCount',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
