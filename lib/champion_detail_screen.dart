import 'package:flutter/material.dart';
import 'package:state_management/app_assets.dart';
import 'package:state_management/app_colors.dart';
import 'package:state_management/api_service.dart';
import 'package:state_management/models/champion_detail_model.dart';

class ChampionDetailScreen extends StatefulWidget {
  final String championId;
  final String version;
  const ChampionDetailScreen({
    required this.championId,
    required this.version,
    super.key,
  });

  @override
  State<ChampionDetailScreen> createState() => _ChampionDetailScreenState();
}

class _ChampionDetailScreenState extends State<ChampionDetailScreen> {
  bool _isExpanded = false;
  late Future<ChampionDetailModel> _championDetailFuture;

  @override
  void initState() {
    super.initState();
    _championDetailFuture = ApiService().fetchChampionDetail(
      widget.championId,
      widget.version,
      'vi_VN',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ChampionDetailModel>(
        future: _championDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final ChampionDetailModel champion = snapshot.data!;
            final List<String> splashImageUrls = champion.skins.map((skin) {
              return 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${champion.id}_${skin.num}.jpg';
            }).toList();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: splashImageUrls.length,
                      itemBuilder: (context, index) {
                        final imageUrl = splashImageUrls[index];
                        final skinName = champion.skins[index].name;
                        return Stack(
                          children: [
                            Image.network(
                              imageUrl,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        'Không tải được ảnh cho skin: $skinName',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                            ),
                            // Positioned(
                            //   bottom: 10,
                            //   left: 10,
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 8,
                            //       vertical: 4,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Colors.black54,
                            //       borderRadius: BorderRadius.circular(5),
                            //     ),
                            //     child: Text(
                            //       skinName == 'default'
                            //           ? '${champion.name} mặc định'
                            //           : skinName,
                            //       style: const TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Image.network(
                  //   champion.splashImageUrl,
                  //   height: 200,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  //   errorBuilder: (context, error, stackTrace) => Container(
                  //     height: 200,
                  //     color: Colors.grey[300],
                  //     child: const Center(
                  //       child: Text('Không tải được ảnh splash'),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    color: const Color.fromARGB(255, 234, 231, 231),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  champion.squareImageUrl,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    champion.name,
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    champion.tags.join(),
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            champion.title,
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: Text(
                      'Lore',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text(
                      champion.lore,
                      maxLines: _isExpanded ? null : 3,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : 'Show more',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _containerProduce(
                    champion.passive.iconUrl,
                    champion.passive.name,
                    champion.passive.description,
                  ),

                  ...champion.spells.map(
                    (spell) => _containerProduce(
                      spell.iconUrl,
                      spell.name,
                      spell.description,
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _containerProduce(String _imageUrl, String _name, String _detail) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 235, 232, 232),

        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _imageUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
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
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _detail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
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
