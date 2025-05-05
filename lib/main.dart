import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In@Gym',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 1, 170, 6),
        scaffoldBackgroundColor: const Color.fromARGB(255, 5, 5, 5),
        useMaterial3: true,
      ),
      home: Scaffold(
        // primeiro wid contendo o header do app
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            "In@Gym",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: informationArray(),
        ),
      ),
    );
  }
}

// aqui é acumulada as mensagens como fixas predefinidas levande em consideração que utiliza StateLess
// nao é possivel modificalos,
// o objetivo é de que as mensagens sejam modificadas conforme o administrador do app quiser modificar.
class informationArray extends StatelessWidget {
  const informationArray({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        InfoBoxUpdater(
          contents: [
            'Promoção imperdivel de 10% nas mensalidades',
            'Assine já e obtenha desconto na segunda parcela',
            'Somente ate 29/05',
          ],
        ),
        InfoBoxUpdater(
          contents: [
            'Eventos sobre fitness ',
            'De 25-05 a 26-05 palestra sobre cross-fit',
            'acesse a plataforma e garanta sua participação',
          ],
        ),
      ],
    );
  }
}

class InfoBoxUpdater extends StatefulWidget {
  final List<String> contents;

  const InfoBoxUpdater({super.key, required this.contents});

  @override
  State<InfoBoxUpdater> createState() => _InfoBoxUpdateState();
}

class _InfoBoxUpdateState extends State<InfoBoxUpdater> {
  int _currentIndex = 0;
  late Timer _timer;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> treinoDias = {
    DateTime(2025, 5, 4),
    DateTime(2025, 5, 7),
    DateTime(2025, 5, 10),
  };

  /// validando datas
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.contents.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primeiro Card: Imagem + Texto
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.orange[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade100,
                    Colors.green.shade400,
                    Colors.green.shade900,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://cdn.pixabay.com/photo/2015/11/12/21/01/gym-1040977_1280.jpg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.contents[_currentIndex],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Segundo Card: Calendário
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return _selectedDay != null && isSameDay(_selectedDay!, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
