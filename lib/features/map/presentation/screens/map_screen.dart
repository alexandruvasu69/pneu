import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 116,
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        snapPoint: 0.5,
        borderRadius: BorderRadius.circular(10),
        // TO-DO: Add container for location widgets
        panel: const Center(
          child: Text('This is the sliding Widget'),
        ),
        // TO-DO: Add container for map widget
        body: const Center(
          child: Text('Map widget'),
        ),
        // TO-DO: Add container for search_bar widget
        footer: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Text('This is a search bar'),
        ),
      ),
    );
  }
}
