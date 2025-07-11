import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:state_management/models/champion_model.dart';
import 'package:state_management/models/champion_detail_model.dart';

class ApiService {
  final String _baseUrl = 'https://ddragon.leagueoflegends.com/cdn';

  Future<String> fetchLatestVersion() async {
    final url = Uri.parse(
      'https://ddragon.leagueoflegends.com/api/versions.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> versions = json.decode(response.body);
        if (versions.isNotEmpty) {
          return versions.first.toString();
        } else {
          throw Exception('Không tìm thấy phiên bản nào từ DDragon.');
        }
      } else {
        throw Exception(
          'Không thể tải phiên bản từ DDragon: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy phiên bản DDragon: $e');
    }
  }

  Future<ChampionModel> fetchChampions(String version, String language) async {
    final url = Uri.parse('$_baseUrl/$version/data/$language/champion.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ChampionModel.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Không thể tải danh sách tướng: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi khi fetch danh sách tướng: $e');
    }
  }

  Future<ChampionDetailModel> fetchChampionDetail(
    String championId,
    String version,
    String language,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/$version/data/$language/champion/$championId.json',
    );
    print('Đang fetch chi tiết tướng từ: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final Map<String, dynamic> championDataMap = jsonResponse['data'];

        final Map<String, dynamic>? specificChampionData =
            championDataMap[championId];

        if (specificChampionData != null) {
          return ChampionDetailModel.fromJson(specificChampionData, version);
        } else {
          throw Exception(
            'Không tìm thấy dữ liệu chi tiết cho tướng $championId',
          );
        }
      } else {
        throw Exception(
          'Không thể tải chi tiết tướng $championId: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi khi fetch chi tiết tướng $championId: $e');
    }
  }
}
