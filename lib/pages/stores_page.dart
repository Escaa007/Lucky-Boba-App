import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'menu_page.dart'; // Ensure this points to your MenuPage file

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  final Color deepPurple = const Color(0xFF3B2063);
  final Color lightPurple = const Color(0xFFE8DEF8);

  final MapController _mapController = MapController();
  late PageController _pageController;

  LatLng _userLocation = const LatLng(14.7040, 121.0340);
  bool _isLoadingLocation = false;

  final List<Map<String, dynamic>> storeLocations = [
    {'name': 'East Fairview', 'address': 'Dunhill Corner Winston St. East Fairview Q.C', 'image': 'assets/images/eastfairview_branch.png', 'lat': 14.7032, 'lng': 121.0695, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7032,121.0695'},
    {'name': 'AUF Angeles', 'address': 'Stall #7 JCL foodcourt, 704 Fajardo st.', 'image': 'assets/images/auf_branch.jpg', 'lat': 15.1451, 'lng': 120.5941, 'closeTime': '07:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=15.1451,120.5941'},
    {'name': 'Robinsons Galleria Cebu', 'address': '3rd Floor, Robinsons Galleria Cebu', 'image': 'assets/images/galleriacebu_branch.jpg', 'lat': 10.3061, 'lng': 123.9059, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=10.3061,123.9059'},
    {'name': 'Jenra Grand Mall', 'address': 'Upper Ground Floor (near Jollibee Entrance)', 'image': 'assets/images/jenra_branch.png', 'lat': 15.1336, 'lng': 120.5907, 'closeTime': '08:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=15.1336,120.5907'},
    {'name': 'Pamana Medical Center', 'address': 'National Highway, Calamba, Laguna', 'image': 'assets/images/pamana_branch.jpg', 'lat': 14.2017, 'lng': 121.1565, 'closeTime': '08:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.2017,121.1565'},
    {'name': 'Dahlia', 'address': '#10 Dahlia Avenue, Fairview, Quezon City', 'image': 'assets/images/dahlia_branch.png', 'lat': 14.7028, 'lng': 121.0664, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7028,121.0664'},
    {'name': 'Misamis St., Bago Bantay', 'address': '43 Misamis St. Sto. Cristo, Bago Bantay', 'image': 'assets/images/misamis_branch.png', 'lat': 14.6598, 'lng': 121.0263, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6598,121.0263'},
    {'name': 'Pontiac', 'address': 'Pontiac st. cor. Datsun st. Fairview, Quezon City', 'image': 'assets/images/pontiac_branch.png', 'lat': 14.7065, 'lng': 121.0621, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7065,121.0621'},
    {'name': 'QCGH', 'address': 'Stall # 5 Seminary Road Project 8, Quezon City', 'image': 'assets/images/qcgh_branch.png', 'lat': 14.6669, 'lng': 121.0221, 'closeTime': '08:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6669,121.0221'},
    {'name': 'Tondo, Manila', 'address': '539 Perla St., Tondo, Manila', 'image': 'assets/images/tondo_branch.png', 'lat': 14.6138, 'lng': 120.9678, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6138,120.9678'},
    {'name': 'Vipra', 'address': '356 Vipra St., Sangandaan, Quezon City', 'image': 'assets/images/vipra_branch.png', 'lat': 14.6811, 'lng': 121.0368, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6811,121.0368'},
    {'name': 'Starmall Shaw Blvd.', 'address': 'near Kalentong Jeepney Terminal', 'image': 'assets/images/starmall_branch.png', 'lat': 14.5826, 'lng': 121.0535, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.5826,121.0535'},
    {'name': 'Eton Centris', 'address': 'Second Floor, Eton Centris Station Mall', 'image': 'assets/images/etoncentris_branch.png', 'lat': 14.6444, 'lng': 121.0375, 'closeTime': '10:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6444,121.0375'},
    {'name': 'Isetann Cubao', 'address': 'Ground Floor, Isetann Department Store', 'image': 'assets/images/isetann_branch.jpg', 'lat': 14.6219, 'lng': 121.0515, 'closeTime': '08:30 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6219,121.0515'},
    {'name': 'Candelaria, Quezon', 'address': 'Maharlika Highway, Candelaria', 'image': 'assets/images/candelaria_branch.png', 'lat': 13.9272, 'lng': 121.4233, 'closeTime': '08:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=13.9272,121.4233'},
    {'name': 'Himlayan Rd., Pasong Tamo', 'address': '217 Himlayan Road cor. Tandang Sora Ave.', 'image': 'assets/images/himlayanrd_branch.png', 'lat': 14.6785, 'lng': 121.0505, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6785,121.0505'},
    {'name': 'Lucky Boba - Bagbag', 'address': '657, 1116 Quirino Hwy, Novaliches', 'image': 'assets/images/bagbag_branch.png', 'lat': 14.7000, 'lng': 121.0333, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7,121.0333'},
    {'name': 'Lucky Boba - Cloverleaf', 'address': 'Ayala Malls Cloverleaf, QC', 'image': 'assets/images/cloverleaf_branch.jpg', 'lat': 14.6540, 'lng': 121.0020, 'closeTime': '09:30 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.654,121.002'},
    {'name': 'Ayala Malls Fairview Terraces', 'address': 'Upper Ground Floor, Fairview, QC', 'image': 'assets/images/ayalateracces_branch.jpg', 'lat': 14.7340, 'lng': 121.0578, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.734,121.0578'},
    {'name': 'Ayala Malls Feliz', 'address': 'Level 4, Food Choices, Pasig City', 'image': 'assets/images/mallfeliz_branch.jpg', 'lat': 14.6186, 'lng': 121.0963, 'closeTime': '10:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6186,121.0963'},
    {'name': 'Landmark, Trinoma', 'address': 'Level 1 Food Center, Landmark Supermarket', 'image': 'assets/images/landmark_branch.jpg', 'lat': 14.6534, 'lng': 121.0336, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6534,121.0336'},
    {'name': 'SM North Edsa', 'address': 'The Block Entrance, SM North Edsa', 'image': 'assets/images/smnorth_branch.jpg', 'lat': 14.6565, 'lng': 121.0305, 'closeTime': '10:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6565,121.0305'},
    {'name': 'SM Novaliches', 'address': 'Ground Floor, SM Novaliches, QC', 'image': 'assets/images/smnova_branch.jpg', 'lat': 14.7047, 'lng': 121.0346, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7047,121.0346'},
    {'name': 'SM San Lazaro', 'address': 'Lower Ground Floor, SM San Lazaro, Manila', 'image': 'assets/images/sanlazaro_branch.jpg', 'lat': 14.6158, 'lng': 120.9830, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6158,120.983'},
    {'name': 'Sta. Lucia Mall', 'address': 'Ground Floor, Sta. Lucia East Grand Mall', 'image': 'assets/images/stalucia_branch.jpg', 'lat': 14.6190, 'lng': 121.1000, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.619,121.1'},
    {'name': 'Nova Plaza Mall', 'address': '3rd Floor, Novaliches, Quezon City', 'image': 'assets/images/novaplaza_branch.jpg', 'lat': 14.7214, 'lng': 121.0421, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.7214,121.0421'},
    {'name': 'Spark Place Cubao', 'address': '2nd Floor, Sparks Place, Cubao, QC', 'image': 'assets/images/sparkplace_branch.jpg', 'lat': 14.6179, 'lng': 121.0553, 'closeTime': '09:00 PM', 'url': 'https://www.google.com/maps/search/?api=1&query=14.6179,121.0553'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _calculateAndSortStores();
  }

  void _calculateAndSortStores() {
    for (var store in storeLocations) {
      store['distance'] = _calculateDistance(
        _userLocation.latitude, _userLocation.longitude,
        store['lat'], store['lng'],
      );
    }
    storeLocations.sort((a, b) => a['distance'].compareTo(b['distance']));
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _calculateAndSortStores();
      _isLoadingLocation = false;
    });
    _mapController.move(LatLng(storeLocations[0]['lat'], storeLocations[0]['lng']), 15.0);
  }

  void _onPageChanged(int index) {
    final store = storeLocations[index];
    _mapController.move(LatLng(store['lat'], store['lng']), 15.0);
  }

  Future<void> _launchMapsUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                // --- ADD THIS LINE TO FIX THE WARNING ---
                retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
                userAgentPackageName: 'com.example.luckyboba_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                  ),
                  ...storeLocations.map((store) => Marker(
                    point: LatLng(store['lat'], store['lng']),
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/images/maps_logo.png',
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.location_on, color: Colors.orange, size: 40),
                    ),
                  )),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: Text(
                      "Select Your Outlet",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 310,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'location_btn',
              backgroundColor: Colors.white,
              foregroundColor: deepPurple,
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              child: _isLoadingLocation
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location_rounded),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: storeLocations.length,
                itemBuilder: (context, index) {
                  return _buildStoreCard(storeLocations[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              store['image'],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 100,
                color: lightPurple,
                child: Icon(Icons.storefront, color: deepPurple),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            store['name'],
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${store['distance'].toStringAsFixed(1)} km",
                          style: GoogleFonts.poppins(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store['address'],
                      style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Open", style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                              TextSpan(text: " | Closes ${store['closeTime']}", style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchMapsUrl(store['url']),
                          child: Text(
                            "Get Direction",
                            style: GoogleFonts.poppins(decoration: TextDecoration.underline, fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to MenuPage with the selected store name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuPage(selectedStore: store['name']),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Select This Store", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      ),
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

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }
}