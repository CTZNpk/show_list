import 'package:customizable_datetime_picker/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/genres.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class DisplayFilters extends StatefulWidget {
  static const routeName = '/display-filters';
  DisplayFilters(
      {super.key,
      required this.filterSearch,
      required this.close,
      required this.showType});
  FilterSearchWrapper filterSearch;
  final ShowType showType;
  final Function close;

  @override
  State<DisplayFilters> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DisplayFilters> {
  List<MultiSelectCard> list = [];
  String startDate = '2023';
  String endDate = '2023';
  List<String> selectedGenres = [];

  void populateList() {
    if (widget.showType == ShowType.movie) {
      for (var val in GenresMovie.values) {
        list.add(MultiSelectCard(value: val.type, label: val.name));
      }
    } else {
      for (var val in GenresShows.values) {
        list.add(MultiSelectCard(value: val.type, label: val.name));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    populateList();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            const VerticalSpacing(50),
            Text(
              'Select Year : ',
              style: myTheme.textTheme.displayLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 200,
                  width: 100,
                  child: CustomizableDatePickerWidget(
                    looping: true,
                    dateFormat: 'yyyy',
                    lastDate: DateTime.now(),
                    initialDate: DateTime(1943),
                    firstDate: DateTime(1943),
                    pickerTheme: DateTimePickerTheme(
                      itemTextStyle: myTheme.textTheme.displayMedium!,
                      backgroundColor: myTheme.scaffoldBackgroundColor,
                    ),
                    onChange: (selectedDate, _) {
                      startDate = selectedDate.year.toString();
                    },
                  ),
                ),
                Text(
                  ' TO ',
                  style: myTheme.textTheme.displayMedium,
                ),
                SizedBox(
                  height: 200,
                  width: 100,
                  child: CustomizableDatePickerWidget(
                    looping: true,
                    dateFormat: 'yyyy',
                    lastDate: DateTime.now(),
                    firstDate: DateTime(1943),
                    pickerTheme: DateTimePickerTheme(
                      itemTextStyle: myTheme.textTheme.displayMedium!,
                      backgroundColor: myTheme.scaffoldBackgroundColor,
                    ),
                    onChange: (selectedDate, _) {
                      endDate = selectedDate.year.toString();
                    },
                  ),
                ),
              ],
            ),
            Text(
              'Select Genre : ',
              style: myTheme.textTheme.displayLarge,
            ),
            const VerticalSpacing(20),
            MultiSelectContainer(
              splashColor: Colors.blue.withOpacity(0.1),
              highlightColor: Colors.blue.withOpacity(0.1),
              textStyles: const MultiSelectTextStyles(
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              itemsDecoration: MultiSelectDecorations(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: Colors.indigo[900],
                    borderRadius: BorderRadius.circular(20)),
                disabledDecoration: BoxDecoration(
                    color: Colors.grey[800],
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(10)),
              ),
              items: list,
              onChange: (allSelectedItems, selectedItem) {
                if (selectedGenres.contains(selectedItem)) {
                  selectedGenres.remove(selectedItem);
                } else {
                  selectedGenres.add(selectedItem);
                }
              },
            ),
            const VerticalSpacing(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: MyElevatedButton(
                    label: 'Cancel',
                    backgroundColor: Colors.indigo[900]!,
                    labelIcon: Icons.cancel,
                    imageUrl: null,
                    onPressed: () {
                      widget.filterSearch.isFilterSearch = false;
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: MyElevatedButton(
                    label: 'Apply',
                    labelIcon: Icons.done,
                    imageUrl: null,
                    backgroundColor: Colors.indigo[900]!,
                    onPressed: () {
                      widget.filterSearch.isFilterSearch = true;
                      widget.filterSearch.startDate = startDate;
                      widget.filterSearch.endDate = endDate;
                      widget.filterSearch.genres = selectedGenres;
                      widget.close(context, 'GenreSearch');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
