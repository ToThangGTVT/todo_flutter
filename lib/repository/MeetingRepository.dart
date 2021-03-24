import 'package:sembast/sembast.dart';
import 'package:todo_mazic/db/connect.db.dart';
import 'package:todo_mazic/entity/Meeting.dart';

class MeetingRepository{
  static const String folderName = "Books";
  final _booksFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insertMeetings(Meeting meeting) async {
    print(meeting.toJson());
    await _booksFolder.record(meeting.id).put(await _db, meeting.toJson());
  }

  Future<List<Meeting>> getAllMeeting() async {
    final recordSnapshot = await _booksFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final meeting = Meeting.fromJson(snapshot.value);
      return meeting;
    }).toList();
  }

  Future update(Meeting meeting) async {
    final finder = Finder(filter: Filter.byKey(meeting.id));
    await _booksFolder.update(
      await _db,
      meeting.toJson(),
      finder: finder,
    );
  }
}