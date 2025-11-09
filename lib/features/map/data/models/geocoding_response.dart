class GeocodingResponse {
  GeocodingResponse({required this.features});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) {
    return GeocodingResponse(
      // ignore: always_specify_types
      features: (json['features'] as List<dynamic>)
          .map((f) => Feature.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<Feature> features;
}

class Feature {
  Feature({
    required this.id,
    required this.name,
    required this.fullAddress,
    required this.geometry,
    required this.props,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> propsJson =
        json['properties'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return Feature(
      id: json['id'] as String? ?? '',
      name: propsJson['name'] as String? ?? '',
      fullAddress: propsJson['full_address'] as String? ?? '',
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      props: Properties.fromJson(propsJson),
    );
  }

  final String id;
  final String name;
  final String fullAddress;
  final Geometry geometry;
  final Properties props;
}

class Geometry {
  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json['type'] as String? ?? '',
        // ignore: always_specify_types
        coordinates: (json['coordinates'] as List<dynamic>)
            .map((c) => (c as num).toDouble())
            .toList(),
      );

  final String type;
  final List<double> coordinates;
}

class Properties {
  Properties({required this.context});

  factory Properties.fromJson(Map<String, dynamic> json) {
    final Map<String, Context> ctx = <String, Context>{};
    if (json['context'] is Map<String, dynamic>) {
      (json['context'] as Map<String, dynamic>)
          .forEach((String key, dynamic val) {
        if (val is Map<String, dynamic>) {
          ctx[key] = Context.fromJson(val);
        }
      });
    }
    return Properties(context: ctx);
  }

  final Map<String, Context> context;
}

class Context {
  Context({required this.name});

  factory Context.fromJson(Map<String, dynamic> json) =>
      Context(name: json['name'] as String? ?? '');

  final String name;
}
