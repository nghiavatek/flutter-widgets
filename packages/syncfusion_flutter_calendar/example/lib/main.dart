import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calendar Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController _calendarController = CalendarController();
  DateTime _selectedDate = DateTime.now();
  late _AppointmentDataSource _dataSource;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the data source with appointments for the initial date
    _dataSource = _getCalendarDataSource(_selectedDate);
    // Listen for date changes
    _calendarController.addPropertyChangedListener((property) {
      if (property == 'displayDate') {
        final DateTime newDate = _calendarController.displayDate!;
        if (kDebugMode) {
          print('CalendarController displayDate changed to: $newDate');
        }
        // Schedule the update after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateAppointments(newDate);
        });
      }
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  // Method to update appointments when the date changes
  void _updateAppointments(DateTime date) {
    setState(() {
      _isLoading = true;
      _selectedDate = date;
    });
    // Generate mock appointments for the selected date
    final List<Appointment> newAppointments = _generateMockAppointments(date);
    if (kDebugMode) {
      print('Generated mock appointments for date: $date');
      print('Number of appointments: ${newAppointments.length}');
    }
    setState(() {
      _dataSource = _AppointmentDataSource(newAppointments, _getResources());
      _isLoading = false;
    });
  }

  // Mock method to generate appointments for the selected date
  List<Appointment> _generateMockAppointments(DateTime date) {
    final List<Appointment> appointments = <Appointment>[];
    // Generate different appointments based on the date
    // For simplicity, we'll use the day of the month to vary the appointments
    final int day = date.day;
    final bool isEvenDay = day % 2 == 0;

    if (isEvenDay) {
      // Even days get a different set of appointments
      appointments.add(
        Appointment(
          startTime: DateTime(date.year, date.month, date.day, 2, 15),
          endTime: DateTime(date.year, date.month, date.day, 3, 1),
          subject: 'Mohammed (Even Day)',
          color: Colors.blue,
          resourceIds: ['Service 1'],
        ),
      );
      appointments.add(
        Appointment(
          startTime: DateTime(date.year, date.month, date.day, 3, 20),
          endTime: DateTime(date.year, date.month, date.day, 4, 1),
          subject: 'Mohammed (Even Day)',
          color: Colors.green,
          resourceIds: ['Service 2'],
        ),
      );
    } else {
      // Odd days get a different set of appointments
      appointments.add(
        Appointment(
          startTime: DateTime(date.year, date.month, date.day, 1, 0),
          endTime: DateTime(date.year, date.month, date.day, 2, 0),
          subject: 'Mohammed (Odd Day)',
          color: Colors.red,
          resourceIds: ['Service 3'],
        ),
      );
      appointments.add(
        Appointment(
          startTime: DateTime(date.year, date.month, date.day, 3, 20),
          endTime: DateTime(date.year, date.month, date.day, 4, 30),
          subject: 'Mohammed (Odd Day)',
          color: Colors.pink,
          resourceIds: ['Service 2'],
        ),
      );
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SfCalendar(
              currentTimeIndicatorColor: const Color(0xFF67B4AD),
              showNavigationArrow: true,
              controller: _calendarController,
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF204B97),
                ),
              ),
              view: CalendarView.timelineDay,
              showDatePickerButton: true,
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 1,
                endHour: 23,
                timeFormat: 'h:mm',
                timeInterval: Duration(minutes: 30),
                timeIntervalHeight: 80,
              ),
              minDate: _selectedDate.subtract(const Duration(days: 180)),
              maxDate: _selectedDate.add(const Duration(days: 180)),
              dataSource: _dataSource,
              initialDisplayDate: _selectedDate,
              resourceViewSettings: const ResourceViewSettings(
                showAvatar: false,
                size: 100,
                displayNameTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource(DateTime date) {
    final List<Appointment> appointments = _generateMockAppointments(date);
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

class MeetingDataSource extends CalendarDataSource {
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

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}