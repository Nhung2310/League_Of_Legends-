import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management/setstate/app_colors.dart';
import 'package:state_management/models/champion_detail_model.dart';
import 'package:state_management/bloc/detail/champion_detail_bloc.dart';

class ChampionDetailBlocScreen extends StatelessWidget {
  final String championId;
  final String version;
  const ChampionDetailBlocScreen({
    required this.championId,
    required this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChampionDetailBloc>().add(
        LoadChampionDetail(
          championId: championId,
          version: version,
          locale: 'vi_VN',
        ),
      );
    });
    return Scaffold(
      body: BlocBuilder<ChampionDetailBloc, ChampionDetailState>(
        builder: (context, state) {
          if (state is ChampionDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChampionDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi tải dữ liệu: ${state.message}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChampionDetailBloc>().add(
                        LoadChampionDetail(
                          championId: championId,
                          version: version,
                          locale: 'vi_VN',
                        ),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (state is ChampionDetailLoaded) {
            final ChampionDetailModel champion = state.championDetail;
            final bool isExpanded = state.isLoreExpanded;

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
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 234, 231, 231),
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
                                  champion.tags.join(', '),
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
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<ChampionDetailBloc>().add(
                        const ToggleLoreExpansion(),
                      );
                    },
                    child: Text(
                      isExpanded ? 'Show less' : 'Show more',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _containerProduce(
                    context,
                    champion.passive.iconUrl,
                    champion.passive.name,
                    champion.passive.description,
                  ),
                  ...champion.spells.map(
                    (spell) => _containerProduce(
                      context,
                      spell.iconUrl,
                      spell.name,
                      spell.description,
                    ),
                  ),
                ],
              ),
            );
          }
          // Trạng thái ban đầu hoặc không có dữ liệu (có thể hiển thị loading ở đây)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _containerProduce(
    BuildContext context,
    String _imageUrl,
    String _name,
    String _detail,
  ) {
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
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
