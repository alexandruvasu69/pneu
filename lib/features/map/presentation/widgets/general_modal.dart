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
          const ModalBarrier(
            dismissible: false,
            color: Colors.transparent,
          ),
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
