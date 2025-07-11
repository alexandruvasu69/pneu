import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/route_store.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:pneu/features/map/presentation/widgets/events/event_card.dart';
import 'package:pneu/features/map/presentation/widgets/location/location_card.dart';
import 'package:pneu/shared/styled_text.dart';
import 'package:provider/provider.dart';

class EventsTab extends StatefulWidget {
  EventsTab({super.key, this.scrollController});
  ScrollController? scrollController;

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserNotifier>();
    final userRole = userStore.user!.role;
    final eventsStore = context.watch<EventsStore>();
    final mapStore = context.read<MapStore>();

    if (userRole != 'admin') {
      return Text("EVENIMENTE");
    } else {
      return Column(
        children: [
          for (final e in eventsStore.adminEvents)
            EventCard(
              event: e,
              onTap: () async {
                mapStore.centerMapOnCurrentLocation(e.geometry, zoom: 18);
                eventsStore.shownEvents.add(e);
              },
              onApprove: () {
                eventsStore.approveEvent(e, userStore.user!);
              },
            ),
        ],
      );
    }
  }
}
