import 'package:calendar/src/calendar/events_builder.dart';
import 'package:calendar/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import "package:sticky_grouped_list/sticky_grouped_list.dart";
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  static const nav = "/calendar";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = kToday;
  List<Day> elements = [];
  GroupedItemScrollController groupScrollController =
      GroupedItemScrollController();
  @override
  void initState() {
    super.initState();
    kEvents.forEach((key, value) {
      elements.addAll(value);
    });
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      groupScrollController.scrollTo(
        index: getWeekDay(4 - _selectedDay.weekday),
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  int getWeekDay(int dy) {
    switch (dy) {
      case 0:
        return 0;
      case -1:
        return 1;

      case -2:
        return 2;

      case -3:
        return 3;

      case 3:
        return 4;

      case 2:
        return 5;
      case 1:
        return 6;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('MMMM yyy').format(kToday),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TableCalendar<Event>(
                firstDay: kToday,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                headerVisible: false,
                calendarFormat: CalendarFormat.week,
                startingDayOfWeek:
                    StartingDayOfWeek.values.elementAt(kToday.weekday - 1),
                calendarStyle: const CalendarStyle(
                  // Use `CalendarStyle` to customize the UI

                  outsideDaysVisible: true,
                ),
                onDaySelected: _onDaySelected,
              ),
            ),
            Expanded(
              child: StickyGroupedListView<Day, DateTime>(
                elements: elements,
                order: StickyGroupedListOrder.DESC,
                itemScrollController: groupScrollController,
                groupBy: (Day element) => DateTime(
                    element.date.year, element.date.month, element.date.day),
                groupComparator: (DateTime value1, DateTime value2) =>
                    value2.compareTo(value1),
                itemComparator: (Day element1, Day element2) =>
                    element1.date.compareTo(element2.date),
                floatingHeader: true,
                physics: const ScrollPhysics(
                    parent: BouncingScrollPhysics(
                        parent: FixedExtentScrollPhysics())),
                groupSeparatorBuilder: (Day element) => SizedBox(
                  // height: 50,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFe2ecf9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      child: Text(
                          element.date.weekday == kToday.weekday
                              ? 'Today  ${DateFormat(' MMM d').format(element.date)}'
                              : DateFormat('E MMM d').format(element.date),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: element.date == _selectedDay
                                ? Colors.blue
                                : Colors.black54,
                          )),
                    ),
                  ),
                ),
                indexedItemBuilder: (_, day, index) {
                  return day.events.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 12.0),
                          child: Text("No appointments"),
                        )
                      : ConstrainedBox(
                          constraints: const BoxConstraints(
                              minHeight: 100, maxHeight: 300),
                          child: EventsBuilder(day: day),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
