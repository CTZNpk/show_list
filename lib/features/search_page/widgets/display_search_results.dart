import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/features/main_layout/repository/main_layout_repository.dart';
import 'package:show_list/features/search_page/controller/search_screen_controller.dart';
import 'package:show_list/features/search_page/services/show_result_service.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';
import 'package:show_list/shared/widgets/plan_type_tag.dart';
import 'package:uuid/uuid.dart';

class FilterSearchWrapper {
  FilterSearchWrapper({
    required this.isFilterSearch,
    required this.startDate,
    required this.endDate,
    required this.genres,
  });

  bool isFilterSearch;
  String? startDate;
  String? endDate;
  List<String>? genres;
}

class DisplaySearchResults extends ConsumerStatefulWidget {
  static const routeName = 'display-search-results';
  const DisplaySearchResults({super.key, required this.showType});

  final ShowType showType;

  @override
  ConsumerState<DisplaySearchResults> createState() =>
      _DisplaySearchResultsState();
}

class _DisplaySearchResultsState extends ConsumerState<DisplaySearchResults> {
  late ScrollController _controller;
  List<dynamic> resultOfSearch = [];
  String? searchText;
  int pageNumber = 0;
  bool moreResults = false;
  FilterSearchWrapper filterSearch = FilterSearchWrapper(
    isFilterSearch: false,
    startDate: null,
    endDate: null,
    genres: null,
  );
  late ShowResultService showResultService;
  Map<String, dynamic> alreadyList = {};

  Future<void> _showSearch() async {
    moreResults = true;
    pageNumber = 1;
    filterSearch.isFilterSearch = false;
    searchText = await showResultService.showSearchDelegate(
      showType: widget.showType,
      controller: _controller,
      filterSearch: filterSearch,
    );
    resultOfSearch = [];
    await _getData();
    setState(() {});
  }

  Future<void> _getData() async {
    List<dynamic> moreResultsList = [];
    if (filterSearch.isFilterSearch) {
      moreResultsList = await ref
          .read(searchScreenControllerProvider)
          .searchMoviesAndShowsWithFilter(
              filterSearch, widget.showType, pageNumber);
    } else {
      if (searchText == null) {
        moreResults = false;
        return;
      }
      if (widget.showType == ShowType.anime) {
        moreResultsList = await ref
            .read(searchScreenControllerProvider)
            .searchAnimeResults(searchText!);
      } else {
        moreResultsList = await ref
            .read(searchScreenControllerProvider)
            .searchMoviesAndShowsResults(
                searchText!, widget.showType, pageNumber);
      }
    }
    if (moreResultsList.isEmpty) {
      moreResults = false;
      return;
    }
    resultOfSearch = [...resultOfSearch, ...moreResultsList];
  }

  void rebuildingWidget() {
    alreadyList = ref
        .watch(mainLayoutControllerProvider)
        .getDataFromShowType(widget.showType);
    setState(() {});
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(
      () {
        if (moreResults == true &&
            _controller.offset >= _controller.position.maxScrollExtent - 400) {
          pageNumber++;
          _getData();
          setState(() {});
        }
      },
    );
    showResultService = ShowResultService(ref: ref, context: context);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      rebuildingWidget();
      ref.watch(mainLayoutRepositoryProvider).addListener(rebuildingWidget);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    ref.watch(mainLayoutRepositoryProvider).removeListener(rebuildingWidget);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MyElevatedButton(
            label: 'Search for ${widget.showType.name}',
            labelIcon: Icons.search,
            backgroundColor: Colors.indigo[900]!,
            imageUrl: null,
            onPressed: _showSearch,
          ),
          const VerticalSpacing(10),
          SizedBox(
            height: size.height * 0.6,
            child: GridView.builder(
              controller: _controller,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 7 / 8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: resultOfSearch.length,
              itemBuilder: (context, index) {
                if (widget.showType == ShowType.anime) {
                  alreadyList[resultOfSearch[index].malID] != null
                      ? resultOfSearch[index].planType =
                          alreadyList[resultOfSearch[index].malID].planType
                      : null;
                } else {
                  alreadyList[resultOfSearch[index].tmdbID] != null
                      ? resultOfSearch[index].planType =
                          alreadyList[resultOfSearch[index].tmdbID].planType
                      : null;
                }
                return DisplayPosterGrid(
                  showData: resultOfSearch[index],
                  showType: widget.showType,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPosterGrid extends ConsumerWidget {
  const DisplayPosterGrid({
    super.key,
    required this.showData,
    required this.showType,
  });

  final dynamic showData;
  final ShowType showType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    final specificUid = const Uuid().v4();
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            showType == ShowType.anime
                ? AnimeScreen.routeName
                : MovieScreen.routeName,
            arguments: showType == ShowType.anime
                ? [
                    showData.malID,
                    showData.planType,
                  ]
                : [
                    showData.tmdbID,
                    showType,
                    showData.planType,
                  ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: specificUid,
                child: Image.network(
                  showData.poster ??
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                  height: size.height * 0.25,
                  width: size.width * 0.30,
                ),
              ),
              showData.rating != null
                  ? Positioned(
                      top: 2,
                      right: 2,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          height: 18,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Text(
                            showData.rating == 0
                                ? 'NA'
                                : showData.rating.toString(),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              PlanTypeTag(tmdbData: showData),
            ],
          ),
        ),
        SizedBox(
          height: 30,
          width: size.width * 0.30,
          child: Center(
            child: Text(
              showData.title,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
        ),
      ],
    );
  }
}
