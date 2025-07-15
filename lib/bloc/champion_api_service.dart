import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:state_management/models/champion_model.dart';

class ChampionApiService {
  Future<String> fetchCurrentDDragonVersion() async {
    try {
      final versionResponse = await http.get(
        Uri.parse('https://ddragon.leagueoflegends.com/api/versions.json'),
      );
      if (versionResponse.statusCode == 200) {
        List<dynamic> versions = json.decode(versionResponse.body);
        if (versions.isNotEmpty) {
          return versions[0];
        }
      }
    } catch (e) {
      print('Error fetching DDragon versions: $e');
    }
    return '14.13.1'; // Fallback version
  }

  Future<List<Champion>> fetchChampions(String version) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final bool isConnected = connectivityResult != ConnectivityResult.none;

    if (!isConnected) {
      throw Exception('Không có kết nối internet!');
    }

    final url = Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$version/data/vi_VN/champion.json',
    );
    print('Fetching champions from: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final ChampionModel championListResponse = ChampionModel.fromJson(
          jsonResponse,
        );
        return championListResponse.data.values.toList();
      } else {
        throw Exception(
          'Failed to load champions with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching champions: $e');
      throw Exception('Không thể tải tướng. Vui lòng thử lại.');
    }
  }
}
