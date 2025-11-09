import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/domain/entities/event.dart';

class EventCard extends StatelessWidget {
  EventCard({super.key, this.onTap, this.onApprove, required this.event});
  Function()? onTap;
  Function()? onApprove;
  Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 36),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/icons/Attention.svg'),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'created by: ' + event.createdBy ?? 'anonymous',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton(
              child: Text('Approve'),
              onPressed: onApprove,
            )
          ],
        ),
      ),
    );
  }
}
