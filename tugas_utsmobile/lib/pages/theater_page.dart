import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TheaterPage extends StatefulWidget {
  const TheaterPage({super.key});
  @override
  State<TheaterPage> createState() => _TheaterPageState();
}

class _TheaterPageState extends State<TheaterPage> {
  final List<_City> _cities = const [
    _City(name: 'MEDAN', lat: 3.5952, lon: 98.6722),
    _City(name: 'JAKARTA', lat: -6.1754, lon: 106.8272),
    _City(name: 'BANDUNG', lat: -6.9147, lon: 107.6098),
    _City(name: 'SURABAYA', lat: -7.2575, lon: 112.7521),
    _City(name: 'MAKASSAR', lat: -5.1477, lon: 119.4327),
    _City(name: 'MALANG', lat: -7.9666, lon: 112.6326),
  ];

  final Map<String, List<String>> _cinemaByCity = const {
    'MEDAN': [
      'XI CINEMA',
      'PONDOK KELAPA 21',
      'CGV',
      'CINEPOLIS',
      'CP MALL',
      'HERMES',
    ],
    'JAKARTA': [
      'XXI KOTA KASABLANKA',
      'CGV GRAND INDONESIA',
      'FLIX PIK',
      'CINEPOLIS KELAPA GADING',
    ],
    'BANDUNG': ['CGV PASKAL 23', 'XXI CIWALK', 'XXI PVJ'],
    'SURABAYA': ['XXI TUNJUNGAN PLAZA', 'CGV MARVEL CITY', 'CINEPOLIS LENMARC'],
    'MAKASSAR': ['XXI PANAKKUKANG', 'CGV DAYA GRAND SQUARE'],
    'MALANG': [
      'MALL OLYMPIC GARDEN XXI',
      'MATOS XXI',
      'CGV MALANG CITY POINT',
      'CINEPOLIS SARONDA',
    ],
  };

  String _selectedCity = 'MEDAN';
  String _locText = '';
  StreamSubscription<Position>? _sub;

  @override
  void initState() {
    super.initState();
    _getOne();
    _listen();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _getOne() async {
    final service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      if (!mounted) return;
      setState(() => _locText = 'Lokasi off → pilih manual');
      return;
    }
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.denied ||
        p == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() => _locText = 'Izin ditolak → pilih manual');
      return;
    }
    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 12),
      );
    } on TimeoutException {
      pos = await Geolocator.getLastKnownPosition();
    } catch (_) {
      pos = await Geolocator.getLastKnownPosition();
    }
    if (!mounted) return;
    if (pos == null) {
      setState(() => _locText = 'Koordinat tidak ada');
      return;
    }
    setState(() {
      _locText =
          '(${pos!.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})';
      final n = _nearest(pos.latitude, pos.longitude);
      if (n != null) _selectedCity = n.name;
    });
  }

  void _listen() {
    _sub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 25,
          ),
        ).listen((pos) {
          if (!mounted) return;
          setState(() {
            _locText =
                '(${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})';
            final n = _nearest(pos.latitude, pos.longitude);
            if (n != null) _selectedCity = n.name;
          });
        }, onError: (_) {});
  }

  _City? _nearest(double lat, double lon) {
    _City? best;
    double bestKm = double.infinity;
    for (final c in _cities) {
      final d = _km(lat, lon, c.lat, c.lon);
      if (d < bestKm) {
        bestKm = d;
        best = c;
      }
    }
    return best;
  }

  double _km(double aLat, double aLon, double bLat, double bLon) {
    const r = 6371.0;
    final dLat = (bLat - aLat) * pi / 180.0;
    final dLon = (bLon - aLon) * pi / 180.0;
    final s1 = sin(dLat / 2);
    final s2 = sin(dLon / 2);
    final a =
        s1 * s1 + cos(aLat * pi / 180.0) * cos(bLat * pi / 180.0) * s2 * s2;
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  @override
  Widget build(BuildContext context) {
    final list = _cinemaByCity[_selectedCity] ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              color: const Color(0xFF2F3456),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFF6C43B),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'THEATER',
                      style: TextStyle(
                        color: Color(0xFFF6C43B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF2F3456),
                  ),
                  const SizedBox(width: 8),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      icon: const Icon(Icons.expand_more),
                      items: _cities.map((c) {
                        return DropdownMenuItem(
                          value: c.name,
                          child: Text(
                            c.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _selectedCity = v);
                      },
                    ),
                  ),
                  const Spacer(),
                  if (_locText.isNotEmpty)
                    Text(
                      _locText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  IconButton(
                    tooltip: 'Refresh lokasi',
                    onPressed: _getOne,
                    icon: const Icon(
                      Icons.my_location,
                      color: Color(0xFF2F3456),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final name = list[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFF3E4457),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.expand_more,
                        color: Color(0xFF3E4457),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _City {
  final String name;
  final double lat;
  final double lon;
  const _City({required this.name, required this.lat, required this.lon});
}
