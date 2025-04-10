import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(const CalendarApp());
}

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Calendar Demo', home: MyHomePage());
  }
}

/// The hove page which hosts the calendar
class MyHomePage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 40),
          child: SfCalendar(
            view: CalendarView.timelineDay,
            showDatePickerButton: true,
            timeSlotViewSettings: const TimeSlotViewSettings(
              startHour: 1,
              endHour: 20,
              timeFormat: 'h:mm',
              timeInterval: Duration(minutes: 30),
              timeIntervalHeight: 60,
            ),
            minDate: _selectedDate.subtract(const Duration(days: 180)),
            maxDate: _selectedDate.add(const Duration(days: 180)),
            dataSource: _getCalendarDataSource(),
            initialDisplayDate: _selectedDate,
            resourceViewSettings: const ResourceViewSettings(
              showAvatar: false,
              size: 100,
              displayNameTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
    );
  }


  _AppointmentDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 2, 15),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 3, 1),
        subject: 'Mohammed',
        color: Colors.blue,
        resourceIds: ['Service 1'],
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 3, 20),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 4, 1),
        subject: 'Mohammed',
        color: Colors.green,
        resourceIds: ['Service 2'],
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 3, 20),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 4, 30),
        subject: 'Mohammed',
        color: Colors.green,
        resourceIds: ['Service 2'],
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 3, 20),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 4, 30),
        subject: 'Mohammed',
        color: Colors.pink,
        resourceIds: ['Service 2'],
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 1, 0),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 2, 0),
        subject: 'Mohammed',
        color: Colors.red,
        resourceIds: ['Service 3'],
      ),
    );
    appointments.add(
      Appointment(
        startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 1, 0),
        endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 2, 0),
        subject: 'Mohammed',
        color: Colors.yellow,
        resourceIds: ['Service 6'],
      ),
    );

    final List<CalendarResource> resources = _getResources();
    return _AppointmentDataSource(appointments, resources);
  }

  List<CalendarResource> _getResources() {
    return [
      CalendarResource(id: 'Service 1', displayName: 'Service 1sdfdfsdfsdfsdfs'),
      CalendarResource(id: 'Service 2', displayName: 'Service 2'),
      CalendarResource(id: 'Service 3', displayName: 'Service 3'),
      CalendarResource(id: 'Service 4', displayName: 'Service 4'),
      CalendarResource(id: 'Service 5', displayName: 'Service 5'),
      CalendarResource(id: 'Service 6', displayName: 'Service 6'),
    ];
  }
}


class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> appointments, List<CalendarResource> resources) {
    this.appointments = appointments;
    this.resources = resources;
  }
}
/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
