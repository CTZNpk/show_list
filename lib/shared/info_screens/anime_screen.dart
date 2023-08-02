import 'package:flutter/material.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class AnimeScreen extends StatefulWidget {
  static const routeName = '/anime-screen';
  const AnimeScreen({
    super.key,
    required this.animeData,
    required this.heroUid,
  });

  final MalAnimeDataModel animeData;
  final String heroUid;

  @override
  State<AnimeScreen> createState() => _AnimeScreen();
}

class _AnimeScreen extends State<AnimeScreen> {
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
                      widget.animeData.mainPicture,
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
                          widget.animeData.title,
                          style: myTheme.textTheme.displayLarge,
                        ),
                        Text(
                            '${widget.animeData.startDate} - ${widget.animeData.endDate}', style: myTheme.textTheme.displayMedium,),
                        const VerticalSpacing(2),
                        Text(
                            'Number of Episodes : ${widget.animeData.numOfEpisodes == 0 ? 'N/A' : widget.animeData.numOfEpisodes}', style: myTheme.textTheme.displayMedium,),
                        const VerticalSpacing(8),
                        Text('Rating : ${widget.animeData.rating}', style: myTheme.textTheme.displayMedium,),
                        Text('Rank : ${widget.animeData.rank}', style: myTheme.textTheme.displayMedium,),
                        Text('Popularity : ${widget.animeData.popularity}', style: myTheme.textTheme.displayMedium,),
                        Text('Status : ${widget.animeData.status}', style: myTheme.textTheme.displayMedium,),
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
          const VerticalSpacing(8),
          Text(
            'Overview ',
            style: myTheme.textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.animeData.overview, style: myTheme.textTheme.displayMedium,),
          ),
          const VerticalSpacing(8),
          Text(
            'Alternative Titles',
            style: myTheme.textTheme.displayLarge,
          ),
          SizedBox(
            height: size.height * 0.15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.animeData.alternativeTitle.length,
                itemBuilder: (context, index) {
                  return Text(
                    widget.animeData.alternativeTitle[index], style: myTheme.textTheme.displayMedium,
                  );
                },
              ),
            ),
          ),
          const VerticalSpacing(8),
          Text(
            'Genres ',
            style: myTheme.textTheme.displayLarge,
          ),
          SizedBox(
            height: size.height * 0.20,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: widget.animeData.genres.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      widget.animeData.genres[index], style: myTheme.textTheme.displayMedium,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
