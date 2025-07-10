import 'package:flutter/material.dart';
import 'package:state_management/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> championData = [
    {
      'image':
          'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ahri_0.jpg',
      'name': 'Ahri',
      'detail':
          'Sinh ra với kết nối ma thuật cõi linh giới, Ahri là một vastaya cáo tinh với khả năng thao túng cảm xúc của con mồi và hấp thụ tinh hoa từ chúng—nhận được một phần ký ức và trí tuệ từ mỗi linh hồn mà cô nàng hấp thụ. Từng là một kẻ săn mồi mạnh mẽ và bướng bỉnh, giờ đây Ahri ngao du khắp thế giới để tìm kiếm manh mối về tổ tiên của mình cũng như thay thế những ký ức bị đánh cắp bởi chính ký ức của bản thân cô.',
    },
    {
      'image':
          'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Aatrox_0.jpg',
      'name': 'Aatrox',
      'detail':
          'Từng là những người bảo hộ cao quý của Shurima để chống lại Hư Không, Aatrox cùng đồng bọn cuối cùng lại trở thành một mối hiểm họa còn lớn hơn đối với cả Runeterra, và chỉ bị đánh bại bằng món phép thuật khôn ngoan của nhân loại. Nhưng sau nhiều thế kỉ bị giam cầm, Aatrox là kẻ đầu tiên một lần nữa tìm về với tự do, bằng cách vấy bẩn và biến đổi những kẻ ngu ngốc dám cầm thử thứ vũ khí ma thuật chứa đựng linh hồn hắn. Giờ đây, với da thịt chiếm đoạt được, hắn quay trở lại Runeterra trong một hình hài khủng khiếp tương tự trước đây, tìm kiếm sự tàn sát và trả món hận thù năm xưa.',
    },
    {
      'image':
          'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Garen_0.jpg',
      'name': 'Garen',
      'detail':
          'Một chiến binh cao quý và là thủ lĩnh của đội quân Tiên Phong Bất Bại, Garen chiến đấu để bảo vệ Demacia và lý tưởng của nó. Mang trên mình bộ giáp kháng phép và một thanh kiếm khổng lồ, Garen luôn sẵn sàng đối đầu với ma thuật và pháp sư bằng một thanh kiếm công lý không ngừng nghỉ.',
    },
    {
      'image':
          'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Lux_0.jpg',
      'name': 'Lux',
      'detail':
          'Luxanna Crownguard đến từ Demacia, một vương quốc bị cô lập nơi ma thuật bị coi là đáng sợ. Cô có thể điều khiển ánh sáng. Cô phải giữ bí mật sức mạnh của mình để tránh bị trục xuất, nhưng cô cũng muốn dùng nó để giúp đỡ mọi người.',
    },
  ];

  List<Map<String, String>> searchResults = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchResults = List.from(championData);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        searchResults = List.from(championData);
      } else {
        searchResults = championData
            .where(
              (item) =>
                  item['name']!.toLowerCase().contains(query.toLowerCase()),
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
                          icon: Icon(Icons.clear),
                        )
                      : Icon(Icons.search),
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: championData.length,
            //     itemBuilder: (context, index) {
            //       final champion = championData[index];
            //       return _containerProduce(
            //         champion['image']!,
            //         champion['name']!,
            //         champion['detail']!,
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final champion = searchResults[index];
                  return _containerProduce(
                    champion['image']!,
                    champion['name']!,
                    champion['detail']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerProduce(String _imageUrl, String _name, String _detail) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    width: 100,
                    color: Colors.grey[300],
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 100,
                    color: Colors.grey,
                    child: Icon(Icons.broken_image, color: Colors.white),
                    alignment: Alignment.center,
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _detail,
                      style: TextStyle(
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
    );
  }
}
