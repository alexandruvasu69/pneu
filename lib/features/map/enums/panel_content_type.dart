enum PanelContentType {
  locations(0.5, false),
  events(0.4, false),
  routeDetails(0.30, true),
  directionDetails(0.2, true);

  const PanelContentType(this.snapPoint, this.isLocked);

  final double snapPoint;
  final bool isLocked;
}
