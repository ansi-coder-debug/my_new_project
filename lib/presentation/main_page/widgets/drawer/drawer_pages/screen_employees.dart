import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/core/constants/constant.dart';

import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/employee/add_employee_modal.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenEmployees extends ConsumerWidget {
  const ScreenEmployees({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeProvider);
    final employees = employeeState.employees;
    print('👀 Employees In Ui: ${employees.map((a) => a.name).toList()}');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Employees",
              // onBack: () {
              //   //last index wanna do at later
              // },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                // ref.read(employeeProvider.notifier).loadEmployees(employees);
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                
                // For adding new employee, you might pass an empty Employee
                final newEmployee = Employee(
                  id: null,
                  name: '',
                  email: '',
                  phone: '',
                  address: '',
                  position: '',
                  salary: 0,
                  hireDate: DateTime.now().toIso8601String(),
                );

                showDialog(
                  context: context,
                  builder: (_) => EmployeeDialog(employee: newEmployee),
                );
              },
            ),
            KHeight,

            Expanded(
              child: employeeState.status == EmployeeStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : employees.isEmpty
                  ? const Center(child: Text("No employees found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];

                        return OutputCard(
                          title: employee.name,
                          subtitle:
                              '${employee.hireDate} • ${employee.position}',
                          amount: employee.salary,
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) => EmployeeDialog(
                                employee: employee,
                                isViewOnly: true,
                              ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (_) => EmployeeDialog(
                                employee: employee,
                                isViewOnly: false,
                              ),
                            );
                          },
                         onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this employee record?'),
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
    await ref.read(employeeProvider.notifier).deleteEmployee(employee.id!);
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee deleted')),
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
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/core/constants/constant.dart';

import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/employee/add_employee_modal.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';


class ScreenEmployees extends ConsumerWidget {
  const ScreenEmployees({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeProvider);
    final employees = employeeState.employees;
     print('👀 Employees In Ui: ${employees.map((a) => a.name).toList()}');


    
      return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            CustomHeader(
               title:"Employees",
                onBack: (){
                //last index wanna do at later 
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
       // ref.read(employeeProvider.notifier).loadEmployees(employees);
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd:(){
                showDialog(
                  context: context,
                   builder:(_) =>AddEmployeeModal(),
                    );
              }    
               ),
               KHeight,

               Expanded(
                child: 
             

      
      
       employeeState.status == EmployeeStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
              ? const Center(child: Text("No employees found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];

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
                                    employee.name.toUpperCase(),
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
                                      // TODO: Open edit dialog
                                    } else if (value == 'delete') {
                                      // TODO: Call delete
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Email: ${employee.email}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Phone: ${employee.phone}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Position: ${employee.position}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Salary: ₹${employee.salary}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Hire Date: ${employee.hireDate}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
