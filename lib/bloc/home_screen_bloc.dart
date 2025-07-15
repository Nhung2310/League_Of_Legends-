import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:state_management/bloc/champion_bloc.dart';
import 'package:state_management/bloc/champion_event.dart';
import 'package:state_management/bloc/champion_state.dart';
import 'package:state_management/setstate/app_colors.dart';
import 'package:state_management/models/champion_model.dart';
import 'package:state_management/setstate/champion_detail_screen.dart';
import 'package:state_management/bloc/detail/champion_detail_bloc_screen.dart';

class HomeScreenBloc extends StatelessWidget {
  const HomeScreenBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const _SearchInputWidget(),
            ),
            Expanded(
              child: BlocBuilder<ChampionBloc, ChampionState>(
                builder: (context, state) {
                  final bool isLoading = state is ChampionLoading;
                  final List<Champion> displayChampions =
                      (state is ChampionLoaded) ? state.searchResults : [];
                  final String currentVersion = (state is ChampionLoaded)
                      ? state.currentDDragonVersion
                      : '14.13.1'; // Giá trị mặc định

                  final bool enableSkeleton =
                      isLoading ||
                      (state is ChampionLoaded &&
                          displayChampions.isEmpty &&
                          state.currentQuery.isNotEmpty);

                  if (state is ChampionError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lỗi: ${state.message}',
                            style: const TextStyle(color: AppColors.blackColor),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChampionBloc>().add(LoadChampions());
                            },
                            child: const Text('Tải lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Skeletonizer(
                    enabled: enableSkeleton,
                    child: ListView.builder(
                      itemCount: displayChampions.length,
                      itemBuilder: (context, index) {
                        if (displayChampions.isEmpty) {
                          return _containerProduce(
                            context,
                            'https://via.placeholder.com/100x150',
                            'Placeholder Name',
                            'Placeholder description for a champion.',
                            () {},
                          );
                        }

                        final champion = displayChampions[index];
                        return _containerProduce(
                          context,
                          champion.splashImageUrl,
                          champion.name,
                          champion.blurb,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChampionDetailBlocScreen(
                                  championId: champion.id,
                                  version: currentVersion,
                                ),
                              ),
                            );
                          },
                        );
                      },
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

  Widget _containerProduce(
    BuildContext context,
    String imageUrl,
    String name,
    String detail,
    Function onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: InkWell(
        onTap: () {
          onTap();
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
                  imageUrl,
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 100,
                      color: AppColors.blackColor,
                    );
                  },
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
                        name,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail,
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

class _SearchInputWidget extends StatefulWidget {
  const _SearchInputWidget({super.key});

  @override
  State<_SearchInputWidget> createState() => __SearchInputWidgetState();
}

class __SearchInputWidgetState extends State<_SearchInputWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<ChampionBloc>().add(SearchChampions(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

        prefixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();

                  context.read<ChampionBloc>().add(ClearSearch());
                },
                icon: const Icon(Icons.clear),
              )
            : const Icon(Icons.search),
        hintText: 'Tìm kiếm tướng...',
      ),
    );
  }
}
