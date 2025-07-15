import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:state_management/setstate/app_colors.dart';
import 'package:state_management/models/champion_model.dart';
import 'package:state_management/setstate/champion_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  List<Champion> allChampions = [];
  List<Champion> searchResults = [];

  final TextEditingController _searchController = TextEditingController();
  String _currentDDragonVersion = '14.13.1';

  @override
  void initState() {
    super.initState();

    _loadDataAndShowLoading();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  Future<void> _loadDataAndShowLoading() async {
    setState(() {
      _isLoading = true;
      allChampions = [];
      searchResults = [];
    });
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool isConnected = connectivityResult != ConnectivityResult.none;

    if (!isConnected) {
      return;
    }

    final dataLoading = _fetchChampionsLogic();
    final minLoadingTime = Future.delayed(const Duration(seconds: 10));

    await Future.wait([dataLoading, minLoadingTime]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchChampionsLogic() async {
    String currentVersion = '14.13.1';
    try {
      final versionResponse = await http.get(
        Uri.parse('https://ddragon.leagueoflegends.com/api/versions.json'),
      );
      if (versionResponse.statusCode == 200) {
        List<dynamic> versions = json.decode(versionResponse.body);
        if (versions.isNotEmpty) {
          currentVersion = versions[0];
          setState(() {
            _currentDDragonVersion = currentVersion;
          });
        }
      }
    } catch (e) {
      print('Error fetching DDragon versions: $e');
    }

    final url = Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$currentVersion/data/vi_VN/champion.json',
    );
    print('Fetching champions from: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final ChampionModel championListResponse = ChampionModel.fromJson(
          jsonResponse,
        );

        setState(() {
          allChampions = championListResponse.data.values.toList();
          searchResults = List.from(allChampions);
        });
      } else {
        print('Failed to load champions: ${response.statusCode}');

        setState(() {
          searchResults = [];
          allChampions = [];
        });
      }
    } catch (e) {
      print('Error fetching champions: $e');

      setState(() {
        searchResults = [];
        allChampions = [];
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        searchResults = List.from(allChampions);
      } else {
        searchResults = allChampions
            .where(
              (champion) =>
                  champion.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : const Icon(Icons.search),
                ),
              ),
            ),

            Expanded(
              child: Skeletonizer(
                enabled: _isLoading || searchResults.isEmpty,
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    if (searchResults.isNotEmpty) {
                      final champion = searchResults[index];
                      return _containerProduce(
                        champion.splashImageUrl,
                        champion.name,
                        champion.blurb,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChampionDetailScreen(
                                championId: champion.id,
                                version: _currentDDragonVersion,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerProduce(
    String _imageUrl,
    String _name,
    String _detail,
    Function _onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: InkWell(
        onTap: () {
          _onTap();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _imageUrl,
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _detail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
