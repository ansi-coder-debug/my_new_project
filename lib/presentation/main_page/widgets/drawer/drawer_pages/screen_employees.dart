import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/add_employee_form.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/employee_card.dart';

class ScreenEmployees extends StatefulWidget {
  const ScreenEmployees({super.key});

  @override
  State<ScreenEmployees> createState() => _ScreenEmployeesState();
}

class _ScreenEmployeesState extends State<ScreenEmployees> {
  bool showAddEmployeeForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showAddEmployeeForm
          // If true, show the Add Employee Form instead of the list
          ? AddEmployeeForm(
              onCancel: () {
                // 👉 When user clicks 'Cancel' inside the form:
                // Close the form and show the list again
                setState(() {
                  showAddEmployeeForm = false;
                });
              },
              onAddComplete: () {
                // 👉 When user completes adding a new employee:
                // Close the form and show the list again
                setState(() {
                  showAddEmployeeForm = false;
                });
              },
            )
          // ✅ If false, show the normal Employee List page UI
          : Column(
              children: [
                CommonSearchBar(
                  labelText: 'Employees Page',
                  hintText: 'Employees',
                  onChanged: (p0) {},
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAddEmployeeForm = true;
                      });
                    },

                    child: Text('Add Employee'),
                  ),
                ),

                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<Employee>(
                      'employees',
                    ).listenable(),
                    builder: (context, box, _) {
                      //getting details of all employees
                      List<Employee> employees = box.values.toList();
                      List<int> Keys = box.keys
                          .cast<int>()
                          .toList(); //Get all keys as numbers in a list

                      if (employees.isEmpty) {
                        return Center(child: Text('No Employee Found'));
                      }

                      return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return EmployeeCard(
                            name: employee.name,
                            designation: employee.designation,
                            salary: employee.salary,
                            phone: employee.phoneNumber,
                            joiningYear: employee.joiningYear,
                            status: employee.status,
                            imageUrl: employee.imageUrl,

                            onDelete: () {
                              final key =
                                  Keys[index]; // Get the correct Hive key for this employee
                              box.delete(key); // Delete from Hive
                            },
                            onEdit: () {
                              //here logic
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
