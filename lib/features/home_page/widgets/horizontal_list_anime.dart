import 'package:flutter/material.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:uuid/uuid.dart';

class HorizontalListAnime extends StatefulWidget {
  const HorizontalListAnime({super.key, required this.data});
  final Future<List<MalAnimeDataModel>?> data;

  @override
  State<HorizontalListAnime> createState() => _HorizontalListAnimeState();
}

class _HorizontalListAnimeState extends State<HorizontalListAnime>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    super.build(context);
    return FutureBuilder(
      future: widget.data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final heroUid = const Uuid().v4();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AnimeScreen.routeName,
                    arguments: [
                      snapshot.data![index],
                      heroUid,
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Hero(
                            tag: heroUid,
                            child: Image.network(
                              snapshot.data![index].mainPicture,
                              height: size.height * 0.25,
                              width: size.width * 0.30,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Opacity(
                              opacity: 0.8,
                              child: Container(
                                height: 18,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data![index].rating.toString(),
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
                            snapshot.data![index].title,
                            style: myTheme.textTheme.displayMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
