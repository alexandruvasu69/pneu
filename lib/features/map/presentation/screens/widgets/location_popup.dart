import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pneu/features/map/data/models/geocoding_response.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/widgets/skeleton_box.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LocationPopup extends HookWidget {
  const LocationPopup({
    super.key,
    required this.onCancel,
    required this.onRoutes,
  });

  final VoidCallback onCancel;
  final VoidCallback onRoutes;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final ValueNotifier<bool> _isLoading = useState(false);
    final ValueNotifier<String> address1 = useState<String>('');
    final ValueNotifier<String> address2 = useState<String>('');

    final LocationPopupStore locationPopupStore =
        useListenable(context.read<LocationPopupStore>());

    final bool isActive = locationPopupStore.isLocationPopupActive;
    final CustomScreenPosition? screenCoord =
        locationPopupStore.locationPopupScreenCoordinate;
    final CustomLatLng? realCoord =
        locationPopupStore.locationPopupRealCoordinate;

    Future<void> fetchLocationForCoords() async {
      _isLoading.value = true;

      try {
        final CustomLatLng? real =
            context.read<LocationPopupStore>().locationPopupRealCoordinate;
        final double lon = real!.longitude;
        final double lat = real!.latitude;
        final Uri url = Uri.parse(
          'https://api.mapbox.com/search/geocode/v6/reverse'
          '?longitude=$lon&latitude=$lat'
          '&access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
        );

        final dynamic response = await http.get(url);
        if (response.statusCode != 200) {
          address1.value = 'Eroare rețea';
          address2.value = '';
          return;
        }

        final Map<String, dynamic> jsonMap =
            json.decode(response.body) as Map<String, dynamic>;
        final GeocodingResponse geoResp = GeocodingResponse.fromJson(jsonMap);

        if (geoResp.features.isEmpty) {
          address1.value = 'Nicio locație găsită';
          address2.value = '';
          return;
        }

        final Feature feature = geoResp.features.first;

        // 1) Linia principală: folosim 'name' (ex. "Strada Mexic 1")
        address1.value =
            feature.name.isNotEmpty ? feature.name : feature.fullAddress;

        // 2) Linie secundară: căutăm 'place' → 'region' → 'country'
        final Map<String, Context> ctx = feature.props.context;
        String second = '';
        if (ctx.containsKey('place')) {
          second = ctx['place']!.name;
        } else if (ctx.containsKey('region')) {
          second = ctx['region']!.name;
        } else if (ctx.containsKey('country')) {
          second = ctx['country']!.name;
        } else {
          // fallback: primul element din map (dacă există)
          if (ctx.isNotEmpty) second = ctx.values.first.name;
        }
        address2.value = second;
      } catch (e, st) {
        // Logăm orice excepție neașteptată
        debugPrint('fetchLocation error: $e\n$st');
        address1.value = 'Eroare internă';
        address2.value = '';
      } finally {
        _isLoading.value = false;
      }
    }

    useEffect(() {
      print("IS ACTIVE: " + isActive.toString());

      // dacă s‑a deschis popup-ul sau coord s‑a schimbat
      if (isActive) {
        // defer until after the build finishes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<LocationPopupStore>().loadLocation();
        });
      }

      return null; // no cleanup
    }, <dynamic>[isActive, realCoord]);

    if (!isActive) return const SizedBox.shrink();

    return Positioned(
      left: screenCoord!.x,
      top: screenCoord.y,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -1),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 250, // <— lăţimea maximă
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Cardul propriu-zis
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        context.read<LocationPopupStore>().isLocationLoading
                            // Skeleton pentru linia 1
                            ? const SkeletonBox(width: 150, height: 20)
                            : Text(
                                context
                                    .read<LocationPopupStore>()
                                    .currentLocation!
                                    .address1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                        context.read<LocationPopupStore>().isLocationLoading
                            // Skeleton pentru linia 2
                            ? const SkeletonBox(width: 100, height: 16)
                            : Text(
                                context
                                        .read<LocationPopupStore>()
                                        .currentLocation!
                                        .address2 ??
                                    'fjjfj',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            context.read<LocationPopupStore>().isLocationLoading
                                ? const SkeletonBox(width: 100, height: 25)
                                : ElevatedButton(
                                    onPressed: onCancel,
                                    child: const Text('Cancel'),
                                  ),
                            context.read<LocationPopupStore>().isLocationLoading
                                ? const SkeletonBox(width: 100, height: 25)
                                : ElevatedButton(
                                    onPressed: onRoutes,
                                    child: const Text('Routes'),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Săgeata (triunghiul)
                // Positioned(
                //   child: CustomPaint(
                //     size: const Size(20, 10),
                //     painter: _TrianglePainter(color: Colors.white, elevation: 5),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CustomPainter care desenează un triunghi
// class _TrianglePainter extends CustomPainter {
//   _TrianglePainter({
//     this.color = Colors.white,
//     this.elevation = 4.0,
//   });

//   final Color color;
//   final double elevation; // cât de “înaltă” e umbra

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()..color = color;

//     // 1. Definim forma triunghiului
//     final Path path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width / 2, size.height)
//       ..close();

//     // 2. Tragem umbra
//     //    - path: forma
//     //    - color: culoarea umbrei
//     //    - elevation: “înălțimea” umbrei (cu cât e mai mare, cu atât e mai difuză)
//     //    - transparentOccluder: true ca să se comporte ca un obiect opac
//     canvas.drawShadow(
//       path,
//       Colors.black.withOpacity(0.25),
//       elevation,
//       true,
//     );

//     // 3. Tragem triunghiul
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_TrianglePainter old) => old.color != color || old.elevation != elevation;
// }
