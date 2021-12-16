import 'package:calendar/src/calendar/utils.dart';
import 'package:flutter/material.dart';

class EventsBuilder extends StatelessWidget {
  final Day? day;
  const EventsBuilder({Key? key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: day!.events.length,
        itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 3.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                leading: Icon(day!.events[index].icon),
                title: Text(day!.events[index].name),
                trailing: Text('${day!.events[index].date.hour}:00'),
              ),
            ));
  }
}
