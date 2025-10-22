import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/payroll/payroll_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/payroll/add_payroll_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenPayroll extends ConsumerWidget {
  const ScreenPayroll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollState = ref.watch(payrollProvider);
    final payrolls = payrollState.payrolls;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Payroll",
              // onBack: () {
              //   // TODO: handle back if needed
              // },
              onFilter: () {
                // TODO: Open filter dialog
              },
              onRefresh: () {
                ref.read(payrollProvider.notifier).loadPayrolls();
              },
              onSearch: () {
                // TODO: Open search dialog
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => PayrollDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: payrollState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : payrolls.isEmpty
                  ? const Center(child: Text("No payroll records found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: payrolls.length,
                      itemBuilder: (context, index) {
                        final payroll = payrolls[index];
                        // final payDateFormatted = DateFormat(
                        //   'd/M/y',
                        // ).format(payroll.payDate);

                        return OutputCard(
                          title: payroll.employeeName!,
                          subtitle: 'Role: ${payroll.position}',
                          date:
                              'Pay Date: ${DateFormat('dd-MM-yyyy').format(payroll.payDate)}',
                         onView: () {
  showDialog(
    context: context,
    builder: (_) => PayrollDialog(
      payroll: payroll, // pass payroll object
      isViewOnly: true,
    ),
  );
},

onEdit: () {
  showDialog(
    context: context,
    builder: (_) => PayrollDialog(
      payroll: payroll,
      isViewOnly: false,
    ),
  );
},

onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text(
        'Are you sure you want to delete this payroll record?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await ref.read(payrollProvider.notifier).deletePayroll(payroll.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payroll record deleted')),
    );
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
import 'package:intl/intl.dart';
import 'package:my_new_project/application/payroll/payroll_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/payroll/add_payroll_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenPayroll extends ConsumerWidget {
  const ScreenPayroll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollState = ref.watch(payrollProvider);
    final payrolls = payrollState.payrolls;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Payroll",
              onBack: () {
                // TODO: handle back if needed
              },
              onFilter: () {
                // TODO: Open filter dialog
              },
              onRefresh: () {
                ref.read(payrollProvider.notifier).loadPayrolls();
              },
              onSearch: () {
                // TODO: Open search dialog
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddPayrollDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: payrollState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : payrolls.isEmpty
                      ? const Center(child: Text("No payroll records found"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: payrolls.length,
                          itemBuilder: (context, index) {
                            final payroll = payrolls[index];
                            final payDateFormatted =
                                DateFormat('d/M/y').format(payroll.payDate);

                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            payroll.employeeName ?? "UNKNOWN",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF1B1B3A),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          payroll.salary.toStringAsFixed(2),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            // TODO: Add edit/delete functionality
                                          },
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                                value: 'edit', child: Text('Edit')),
                                            PopupMenuItem(
                                                value: 'delete', child: Text('Delete')),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Pay Date: $payDateFormatted",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    // Add more info here if needed
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
