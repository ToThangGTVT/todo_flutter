import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting extends Appointment {

  int id;

  String subject;

  DateTime startTime;

  DateTime endTime;

  Color color;

  bool isAllDay;

  bool done;

  Meeting.toCalendar(this.id, this.subject, this.startTime, this.endTime, this.color, this
      .isAllDay, this.done);

  Meeting.setValue(this.id, this.subject, this.startTime, this.endTime, this.color, this
      .isAllDay, this.done);

  Meeting({this.id, this.subject, this.startTime, this.endTime, this.color, this
      .isAllDay, this.done});


  // lưu mới vào database
  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "startTime": startTime.microsecondsSinceEpoch.toString(),
    "endTime": endTime.microsecondsSinceEpoch.toString(),
    "color": color.toString(),
    "isAllDay": isAllDay,
    "done": done
  };


  // load từ database
  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting (
    id: json["id"],
    subject: json["subject"],
    startTime: new DateTime.fromMicrosecondsSinceEpoch(int.parse(json["startTime"])) ,
    endTime: new DateTime.fromMicrosecondsSinceEpoch(int.parse(json["endTime"])) ,
    color: const Color(0xFF4DC591),
    isAllDay: json["isAllDay"],
    done: json["done"]
  );
}