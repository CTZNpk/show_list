import 'package:flutter/material.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieScreen extends StatefulWidget {
  static const routeName = '/movie-screen';
  const MovieScreen({
    super.key,
    required this.omdbData,
    required this.traktData,
    required this.heroUid,
  });

  final OmdbDataModel omdbData;
  final TraktDataModel traktData;
  final String heroUid;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    if (widget.traktData.trailer != null) {
      final videoID = YoutubePlayer.convertUrlToId(widget.traktData.trailer!);
      _controller = YoutubePlayerController(
          initialVideoId: videoID!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            showLiveFullscreenButton: false,
            controlsVisibleAtStart: true,
          ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 12.0,
                  ),
                  child: Hero(
                    tag: widget.heroUid,
                    child: Image.network(
                      widget.omdbData.poster,
                      height: size.height * 0.25,
                      width: size.width * 0.30,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 23.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.traktData.title,
                          style: myTheme.textTheme.displayLarge,
                        ),
                        Text(widget.omdbData.year),
                        const VerticalSpacing(2),
                        widget.traktData.showType == ShowType.show
                            ? Text(
                                'Number of Episodes : ${widget.traktData.airedEpisodes.toString()}',
                                style: myTheme.textTheme.displayMedium,
                              )
                            : const SizedBox.shrink(),
                        const VerticalSpacing(8),
                        Text(
                          'trakt : ${widget.traktData.traktRating.toString().substring(0, 4)}',
                          style: myTheme.textTheme.displayMedium,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: size.width, maxHeight: 70),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.omdbData.rating.length,
                            itemBuilder: (context, index) {
                              return Text(
                                '${widget.omdbData.rating[index].source} : ${widget.omdbData.rating[index].value} ',
                                style: myTheme.textTheme.displayMedium,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyElevatedButton(
            label: 'Add To WatchList',
            labelIcon: Icons.list,
            imageUrl: null,
            onPressed: () {}, //TODO add functionality to add to users list
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Trailer',
              style: myTheme.textTheme.displayLarge,
            ),
          ),
          widget.traktData.trailer != null
              ? YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text('Not Available'),
                    ),
                  ),
                ),
          const VerticalSpacing(8),
          Text(
            'Overview : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.plot,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            'Genres : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.genre,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            'Awards : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.awards,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            'Actors : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.actors,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            'Director : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.director,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            'Writer : ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.omdbData.writer,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
