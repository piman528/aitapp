// import 'package:aitapp/domain/types/assignment_event.dart';
// import 'package:aitapp/domain/types/calendar_state.dart';
// import 'package:aitapp/domain/types/event.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class EventModalSheet extends StatelessWidget {
//   const EventModalSheet({super.key, required this.details, required this.data});

//   final CalendarTapDetails details;
//   final CalendarState data;

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       expand: false,
//       initialChildSize: 0.6,
//       minChildSize: 0.4,
//       maxChildSize: 0.9,
//       builder: (context, scrollController) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${details.date?.month}月${details.date?.day}日の予定',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 controller: scrollController,
//                 itemCount: data.events[details.date]?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final event = data.events[details.date]?[index];
//                   if (event == null) {
//                     return const SizedBox();
//                   }
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               if (event is AssignmentEvent)
//                                 _buildStatusIcon(event.status)
//                               else if (event is UnivEvent)
//                                 const Icon(Icons.school, color: Colors.blue),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   event.title,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           if (event is UnivEvent) ...{
//                             Text('${event.period?.num}限'),
//                             Text('場所: ${event.location}'),
//                             Text('担当: ${event.teacher}'),
//                           } else if (event is AssignmentEvent) ...{
//                             const Divider(),
//                             Text('コース: ${event.courseName}'),
//                             const SizedBox(height: 4),
//                             Text(
//                               '提出期限: ${_formatDateTime(event.endTime)}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               '課題の説明:',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(event.description),
//                             const SizedBox(height: 8),
//                             _buildStatusChip(event.status),
//                           },
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusIcon(SubmissionStatus status) {
//     return switch (status) {
//       SubmissionStatus.notSubmitted => const Icon(
//           Icons.assignment_late,
//           color: Colors.red,
//         ),
//       SubmissionStatus.submitted => const Icon(
//           Icons.assignment_turned_in,
//           color: Colors.green,
//         ),
//       SubmissionStatus.needsGrading => const Icon(
//           Icons.assignment,
//           color: Colors.orange,
//         ),
//     };
//   }

//   Widget _buildStatusChip(SubmissionStatus status) {
//     return Chip(
//       label: Text(
//         switch (status) {
//           SubmissionStatus.notSubmitted => '未提出',
//           SubmissionStatus.submitted => '提出済み',
//           SubmissionStatus.needsGrading => '採点待ち',
//         },
//       ),
//       backgroundColor: switch (status) {
//         SubmissionStatus.notSubmitted => Colors.red.shade100,
//         SubmissionStatus.submitted => Colors.green.shade100,
//         SubmissionStatus.needsGrading => Colors.orange.shade100,
//       },
//       labelStyle: TextStyle(
//         color: switch (status) {
//           SubmissionStatus.notSubmitted => Colors.red.shade900,
//           SubmissionStatus.submitted => Colors.green.shade900,
//           SubmissionStatus.needsGrading => Colors.orange.shade900,
//         },
//       ),
//     );
//   }

//   String _formatDateTime(DateTime dateTime) {
//     return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
// }
