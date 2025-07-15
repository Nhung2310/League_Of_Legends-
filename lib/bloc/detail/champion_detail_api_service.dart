import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:state_management/models/champion_detail_model.dart';

class ChampionDetailApiService {
  Future<ChampionDetailModel> fetchChampionDetail(
    String championId,
    String version,
    String locale,
  ) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('Không có kết nối internet!');
    }

    final url = Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$version/data/$locale/champion/$championId.json',
    );
    print('Fetching champion detail from: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final Map<String, dynamic> championData =
            jsonResponse['data'][championId];

        if (championData == null) {
          throw Exception('Không tìm thấy dữ liệu chi tiết tướng.');
        }

        return ChampionDetailModel.fromJson(championData, version);
      } else {
        throw Exception(
          'Failed to load champion detail with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching champion detail: $e');
      throw Exception('Không thể tải chi tiết tướng. Vui lòng thử lại.');
    }
  }
}
