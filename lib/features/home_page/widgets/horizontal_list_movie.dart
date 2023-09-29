import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/features/main_layout/repository/main_layout_repository.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/widgets/plan_type_tag.dart';
import 'package:uuid/uuid.dart';

class HorizontalList extends ConsumerStatefulWidget {
  const HorizontalList(
      {super.key, required this.dataFunction, required this.showType});
  final Function dataFunction;
  final ShowType showType;

  @override
  ConsumerState<HorizontalList> createState() => _HorizontaList();
}

class _HorizontaList extends ConsumerState<HorizontalList>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> dataList = [];
  int pageNumber = 1;
  Map<String, dynamic> alreadyList = {};
  final ScrollController _controller = ScrollController();

  void fetchDataFromFunction() async {
    final listOfResults = await widget.dataFunction(pageNumber);
    dataList = [...dataList, ...listOfResults];
    setState(() {});
  }

  void rebuildingWidget() {
    alreadyList = ref
        .watch(mainLayoutControllerProvider)
        .getDataFromShowType(widget.showType);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetchDataFromFunction();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 50) {
        pageNumber++;
        fetchDataFromFunction();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      rebuildingWidget();
      ref.watch(mainLayoutRepositoryProvider).addListener(rebuildingWidget);
    });
  }

  @override
  void dispose() {
    ref.watch(mainLayoutRepositoryProvider).removeListener(rebuildingWidget);
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    super.build(context);
    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      itemCount: dataList.length + 1,
      itemBuilder: (context, index) {
        final specificUid = const Uuid().v4();
        if (index == dataList.length) {
          return const CircularProgressIndicator();
        }
        if (widget.showType == ShowType.anime) {
          alreadyList[dataList[index].malID] != null
              ? dataList[index].planType =
                  alreadyList[dataList[index].malID].planType
              : null;
        } else {
          alreadyList[dataList[index].tmdbID] != null
              ? dataList[index].planType =
                  alreadyList[dataList[index].tmdbID].planType
              : null;
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      widget.showType == ShowType.anime
                          ? AnimeScreen.routeName
                          : MovieScreen.routeName,
                      arguments: widget.showType == ShowType.anime
                          ? [
                              dataList[index].malID,
                              dataList[index].planType,
                            ]
                          : [
                              dataList[index].tmdbID,
                              widget.showType,
                              dataList[index].planType,
                            ],
                    ),
                    child: Hero(
                      tag: specificUid,
                      child: Image.network(
                        dataList[index].poster ??
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                        height: size.height * 0.25,
                        width: size.width * 0.30,
                      ),
                    ),
                  ),
                  PlanTypeTag(tmdbData: dataList[index]),
                  Positioned(
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
                        child: Center(
                          child: Text(
                            dataList[index].rating ?? 'N/A',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                width: size.width * 0.30,
                child: Center(
                  child: Text(
                    dataList[index].title,
                    style: myTheme.textTheme.displayMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
