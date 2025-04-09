enum PanelContentType {
  locations(0.5, false),
  events(0.4, true),
  routeDetails(0.5, true),
  directionDetails(0.2, true);

  const PanelContentType(this.snapPoint, this.isFixed);

  final double snapPoint;
  final bool isFixed;
}
