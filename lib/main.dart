import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:todo_mazic/repository/MeetingRepository.dart';
import 'package:intl/intl.dart';

import 'MeetingDataSource.dart';
import 'entity/Meeting.dart';

void main() {
  runApp(MyApp());
}

const MaterialColor orange = const MaterialColor(
  0xFFFF4848,
  const <int, Color>{
    50: const Color(0xFFFF4848),
    100: const Color(0xFFFF4848),
    200: const Color(0xFFFF4848),
    300: const Color(0xFFFF4848),
    400: const Color(0xFFFF4848),
    500: const Color(0xFFFF4848),
    600: const Color(0xFFFF4848),
    700: const Color(0xFFFF4848),
    800: const Color(0xFFFF4848),
    900: const Color(0xFFFF4848),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: orange,
        fontFamily: 'Cabin',
      ),
      locale: Locale('vi'),
      supportedLocales: [
        const Locale('vi'),
        const Locale('en'),
        const Locale('ja'),
      ],
      home: MyHomePage(title: 'Todo Mar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Meeting> meetings = List();
  MeetingRepository meetingRepository = new MeetingRepository();

  TextEditingController subjectTodoController = new TextEditingController();
  TextEditingController timeFromTodoController = new TextEditingController();
  TextEditingController timeToTodoController = new TextEditingController();
  TextEditingController dateTodoController = new TextEditingController();

  ScrollController _scrollController;
  double _scrollPosition = 0;

  _MyHomePageState() {
    meetingRepository.getAllMeeting().then((value) => setState(() {
          meetings = value;
        }));
  }

  List<Meeting> _getDataSource() {
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);

    final DateTime endTime = startTime.add(const Duration(hours: 2));

    meetings.add(Meeting.toCalendar(today.microsecondsSinceEpoch, 'Hôm nay', startTime,
        endTime, const Color(0xFF4DC591), false, false));

    return meetings;
  }

  void updateMeeting(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Appointment appointmentDetails = details.appointments[0];
      Meeting m = appointmentDetails as Meeting;
      if (m.done == true) {
        m.done = false;
      } else {
        m.done = true;
      }
      meetingRepository.update(m).then(
            (value) => meetingRepository.getAllMeeting().then(
                  (value) => setState(
                    () {
                      meetings = value;
                    },
                  ),
                ),
          );
    }
  }

  void saveMeeting() {
    DateTime timeFrom = DateFormat("HH:mm").parse(timeFromTodoController.value.text);

    DateTime timeTo = DateFormat("HH:mm").parse(timeToTodoController.value.text);

    DateTime date = DateFormat("yyyy-MM-dd").parse(dateTodoController.value.text);

    int year = date.year;
    int month = date.month;
    int day = date.day;

    Meeting meeting = new Meeting.setValue(
        DateTime.now().microsecondsSinceEpoch,
        subjectTodoController.value.text,
        new DateTime(year, month, day, timeFrom.hour, timeFrom.minute),
        new DateTime(year, month, day, timeTo.hour, timeTo.minute),
        const Color(0xFF4DC591),
        false,
        false);

    meetingRepository.insertMeetings(meeting).then(
          (value) => meetingRepository.getAllMeeting().then(
                (value) => setState(
                  () {
                    meetings = value;
                  },
                ),
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: SfCalendar(
                onLongPress: (CalendarLongPressDetails details) {
                  if (details.targetElement == CalendarElement.appointment) {
                    final Appointment appointmentDetails = details.appointments[0];
                    Meeting m = appointmentDetails as Meeting;
                    print(m.startTime);
                  }
                },
                onTap: this.updateMeeting,
                view: CalendarView.schedule,
                showDatePickerButton: true,
                monthViewSettings:
                    MonthViewSettings(showAgenda: true, agendaItemHeight: 15),
                appointmentBuilder:
                    (BuildContext contex, CalendarAppointmentDetails details) {
                  final Meeting meeting = details.appointments.first as Meeting;
                  print("::::" + '${meeting.done}');
                  return InkWell(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: meeting.color, width: 5))),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meeting.subject,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        meeting.subject + "xzxzxzxffgfg ffdg rrfsfdfdf",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        height: 5,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                      Text(
                                        DateFormat('HH:mm').format(meeting.startTime) +
                                            ' - ' +
                                            DateFormat('HH:mm').format(meeting.endTime),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: meeting.done,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                scheduleViewMonthHeaderBuilder:
                    (BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
                  final String monthName = details.date.month.toString();
                  return Stack(
                    children: [
                      Image(
                          image: new AssetImage('assets/images/' + monthName + '.png'),
                          fit: BoxFit.cover,
                          width: details.bounds.width,
                          height: details.bounds.height),
                      Positioned(
                        left: 15,
                        right: 0,
                        top: 20,
                        bottom: 0,
                        child: Text(
                          'Tháng ' + monthName + ' / ' + details.date.year.toString(),
                          style: TextStyle(
                              color: Color(0xFF4B4B4B),
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                    ],
                  );
                },
                scheduleViewSettings: ScheduleViewSettings(
                  weekHeaderSettings: WeekHeaderSettings(
                    startDateFormat: 'dd MMM',
                    endDateFormat: 'dd',
                    weekTextStyle: TextStyle(
                      color: Color(0xFF3F4850),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Cabin',
                      fontSize: 16,
                    ),
                  ),
                  dayHeaderSettings: DayHeaderSettings(
                      dayFormat: 'EEEE',
                      width: 70,
                      dateTextStyle: TextStyle(fontFamily: 'Cabin', fontSize: 19),
                      dayTextStyle: TextStyle(fontFamily: 'Cabin', fontSize: 12)),
                  monthHeaderSettings: MonthHeaderSettings(
                    height: 170,
                  ),
                  appointmentItemHeight: 83,
                  appointmentTextStyle: TextStyle(
                    fontFamily: 'Cabin',
                    fontSize: 17,
                  ),
                ),
                firstDayOfWeek: 1,
                dataSource: new MeetingDataSource(_getDataSource()),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, left: 12, right: 12),
            height: 40,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Color(0xED2196F3), // inkwell color
                        child: SizedBox(width: 26, height: 26),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: TextField(
                    controller: subjectTodoController,
                    style: TextStyle(fontSize: 19),
                    cursorHeight: 25,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.red,
                      fillColor: Color(0xFFE2E2E2),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: saveMeeting,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Nhập công việc cần làm',
                      contentPadding: EdgeInsets.only(top: 5, left: 15),
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: DateTimePicker(
                    controller: dateTodoController,
                    type: DateTimePickerType.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.date_range),
                    dateLabelText: 'Chọn ngày',
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DateTimePicker(
                    controller: timeFromTodoController,
                    type: DateTimePickerType.time,
                    // initialValue: '',
                    icon: Icon(Icons.access_time),
                    timeLabelText: 'Bắt đầu',
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DateTimePicker(
                    controller: timeToTodoController,
                    type: DateTimePickerType.time,
                    // initialValue: '',
                    icon: Icon(Icons.av_timer),
                    timeLabelText: 'Kết thúc',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
