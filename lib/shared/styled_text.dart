import 'package:flutter/material.dart';
import '../core/themes/app_text_styles.dart';

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.titleLarge);
  }
}

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyMedium);
  }
}

class StyledDescription extends StatelessWidget {
  const StyledDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodySmall);
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyLarge);
  }
}
