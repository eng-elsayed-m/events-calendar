import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  DateTime date;
  String name;
  IconData icon;

  Event(this.name, this.date, this.icon);

  @override
  String toString() => name;
}

List<Event> _events = <Event>[
  Event('Got to gym', DateTime(2021, 12, 15, 18), Icons.fitness_center),
  Event('Got to gym', DateTime(2021, 12, 16, 18), Icons.fitness_center),
  Event('Got to gym', DateTime(2021, 12, 19, 18), Icons.fitness_center),
  Event('Got to gym', DateTime(2021, 12, 20, 18), Icons.fitness_center),
  Event('Got to gym', DateTime(2021, 12, 19, 18), Icons.fitness_center),
  Event('Got to gym', DateTime(2021, 12, 20, 18), Icons.fitness_center),
  Event('Work', DateTime(2021, 12, 15, 9), Icons.work),
  Event('Work', DateTime(2021, 12, 16, 9), Icons.work),
  Event('Work', DateTime(2021, 12, 19, 9), Icons.work),
  Event('Work', DateTime(2021, 12, 20, 9), Icons.work),
  Event('Work', DateTime(2021, 12, 21, 9), Icons.work),
  Event('Car wash', DateTime(2021, 12, 16, 12), Icons.local_car_wash),
  Event('Car wash', DateTime(2021, 12, 21, 12), Icons.local_car_wash),
  Event('Car wash', DateTime(2021, 12, 15, 12), Icons.local_car_wash),
  Event('Car wash', DateTime(2021, 12, 21, 19), Icons.local_car_wash),
];

class Day {
  DateTime date;
  List<Event> events;
  Day(this.date, this.events);

  @override
  String toString() => date.toIso8601String();
}

List<Day> _days = <Day>[
  ...daysInRange(kToday, kLastDay)
      .map((day) => Day(day,
          _events.where((element) => element.date.day == day.day).toList()))
      .toList()
];

final kEvents = LinkedHashMap<DateTime, List<Day>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(8, (index) => index),
    key: (item) => DateTime.utc(kToday.year, kToday.month, item + kToday.day),
    value: (index) => getEventsForDay(index));

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<Day> getEventsForDay(int indx) {
  final eventsInDay = _days.where((element) => element.date.weekday == indx);
  return eventsInDay.toList();
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 2;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day + 6);
