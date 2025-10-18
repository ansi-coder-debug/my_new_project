import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:my_new_project/application/attendance/attendance_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/attendance/add_attendance_dialog.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenAttendance extends ConsumerWidget {
  const ScreenAttendance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final attendanceList = attendanceState.attendances;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header with Add Button
            CustomHeader(
              title: "Attendance",
              onBack: () {
                // Optional back action
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(attendanceProvider.notifier).loadAttendances();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddAttendanceDialog(),
                );
              },
            ),
            KHeight,

            // Main body
            Expanded(
              child: attendanceState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : attendanceList.isEmpty
                  ? const Center(child: Text("No attendance records found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final attendance = attendanceList[index];
                        final employeeName =
                            attendance.employeeName ?? "Unknown";

                        return OutputCard(
                          title: attendance.employeeName!,
                          subtitle:
                              '${DateFormat('dd-MM-yyyy').format(attendance.attendanceDate)} • ${attendance.attendanceStatus}',
                        onView: () {
  showDialog(
    context: context,
    builder: (_) => AddAttendanceDialog(
      attendance: attendance,
      isViewOnly: true,
    ),
  );
},

onEdit: () {
  showDialog(
    context: context,
    builder: (_) => AddAttendanceDialog(
      attendance: attendance,
      isViewOnly: false,
    ),
  );
},

onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this attendance record?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );

  if (confirm == true) {
    await ref.read(attendanceProvider.notifier).deleteAttendance(attendance.id!);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance deleted')),
      );
    }
  }
},

                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/attendance/attendance_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/attendance/add_attendance_dialog.dart';

class ScreenAttendance extends ConsumerWidget {
  const ScreenAttendance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final attendanceList = attendanceState.attendances;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header with Add Button
            CustomHeader(
              title: "Attendance",
              onBack: () {
                // Optional back action
              },
               onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(attendanceProvider.notifier).loadAttendances();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddAttendanceDialog(),
                );
              },
            ),
            KHeight,

            // Main body
            Expanded(
              child: attendanceState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : attendanceList.isEmpty
                      ? const Center(child: Text("No attendance records found"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: attendanceList.length,
                          itemBuilder: (context, index) {
                            final attendance = attendanceList[index];
                            final employeeName = attendance.employeeName?? "Unknown";

                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name + Menu
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            employeeName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF1B1B3A),
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              // TODO: Implement edit
                                            } else if (value == 'delete') {
                                              // TODO: Implement delete
                                            }
                                          },
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Status
                                    Text(
                                      "Status: ${attendance.attendanceStatus}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Date
                                    Text(
                                      "Date: ${attendance.attendanceDate.toLocal().toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
