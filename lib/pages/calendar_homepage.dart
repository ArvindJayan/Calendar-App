import 'package:calendar/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarHomepage extends StatefulWidget {
  const CalendarHomepage({Key? key}) : super(key: key);

  @override
  _CalendarHomepageState createState() => _CalendarHomepageState();
}

class _CalendarHomepageState extends State<CalendarHomepage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // Updates selected day when new day is clicked
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Return all events from selected day
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar App',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 123, 255),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 223, 241, 246),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 253, 255),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Color.fromARGB(255, 221, 255, 255),
                    width: 0.5,
                  ),
                ),
                child: TableCalendar(
                  locale: "en_us",
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  calendarStyle: const CalendarStyle(
                    // Style for selected day
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 170, 255),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                    ),

                    // Style for current day
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 98, 210, 235),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  // Calendar gesture settings and date range
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (selectedDay) =>
                      isSameDay(selectedDay, _selectedDay),
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2010, 12, 31),
                  lastDay: DateTime.utc(2030, 12, 31),
                  onDaySelected: _onDaySelected,
                  eventLoader: _getEventsForDay,
                ),
              ),
            ),
            const SizedBox(
                height: 16), // Padding between the calendar and the event list
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () => print(""),
                              title: Text(value[index].toString()),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color.fromARGB(255, 221, 245, 255),
                  scrollable: true,
                  title: const Text("Add New Event"),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _eventController,
                      decoration: const InputDecoration(
                        hintText: 'Enter event name',
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_eventController.text.isNotEmpty) {
                          if (events[_selectedDay] != null) {
                            events[_selectedDay]!
                                .add(Event(_eventController.text));
                          } else {
                            events[_selectedDay!] = [
                              Event(_eventController.text)
                            ];
                          }
                          _eventController.clear();
                          Navigator.of(context).pop();
                          _selectedEvents.value =
                              _getEventsForDay(_selectedDay!);
                        }
                      },
                      child: const Text('Add',
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Color.fromARGB(255, 0, 140, 255)),
                        elevation: WidgetStateProperty.all<double>(0),
                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.grey.shade800;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        backgroundColor: Color.fromARGB(255, 0, 136, 255),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
