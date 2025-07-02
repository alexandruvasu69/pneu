import 'package:flutter/material.dart';

class GeneralModal extends StatelessWidget {
  const GeneralModal({
    super.key,
    required this.child,
    required this.onOkay,
  });

  final Widget child;
  final VoidCallback onOkay;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // 1) the modal barrier blocks hits to anything below it
          const ModalBarrier(
            dismissible: false,
            color: Colors.transparent, // semi-transparent black
          ),

          // 2) then on top of that we center our Card
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    child,
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onOkay,
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
