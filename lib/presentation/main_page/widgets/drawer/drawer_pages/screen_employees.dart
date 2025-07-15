import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/employee.dart';

import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/employee/add_employee_form.dart';
import 'package:my_new_project/widgets/employee/employee_card.dart';
import 'package:my_new_project/widgets/employee/employee_details_screen.dart';
import 'package:my_new_project/widgets/employee/employee_filter_row.dart';




class ScreenEmployees extends StatefulWidget {
  const ScreenEmployees({super.key});

  @override
  State<ScreenEmployees> createState() => _ScreenEmployeesState();
}

class _ScreenEmployeesState extends State<ScreenEmployees> {
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddEmployeeForm = false;
  Employee? employeeToEdit;

  //details page
  bool showEmployeeDetails = false;
  Employee? selectedEmployee;

  final Box<Employee> employeeBox = Hive.box<Employee>('employees');

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
              employeeToEdit: employeeToEdit,
            )
          // ✅ If false, show the normal Employee List page UI
          : showEmployeeDetails && selectedEmployee != null
          ? EmployeeDetailsScreen(
              employee: selectedEmployee!,

              onBack: () {
                setState(() {
                  showAddEmployeeForm = false;
                  selectedEmployee = null;
                });
              },
              onEdit: () {
                setState(() {
                  employeeToEdit = selectedEmployee;
                  showEmployeeDetails = false;
                  showAddEmployeeForm = true;
                });
              },
            )
          : ValueListenableBuilder(
              valueListenable: Hive.box<Employee>('employees').listenable(),
              builder: (context, box, _) {
                

                //getting details of all employees
                List<Employee> employees = box.values.toList();

                List<int> Keys = box.keys
                    .cast<int>()
                    .toList(); //Get all keys as numbers in a list

                // Apply status filter
                // ✅ 2️⃣ UPDATED: FIX TRIM & LOWERCASE
                if (selectedStatus != 'All Status') {
                  employees = employees.where((e) {
                    final employeeStatus = e.status.trim().toLowerCase();
                    final filterStatus = selectedStatus.trim().toLowerCase();
                    return employeeStatus == filterStatus;
                  }).toList();
                }

                /*apply by fiter */
                employees.sort((a, b) {
                  switch (selectedSort) {
                    case 'Newest First':
                      return int.parse(
                        b.joiningYear,
                      ).compareTo(int.parse(a.joiningYear));
                    case 'Oldest First':
                      return int.parse(
                        a.joiningYear,
                      ).compareTo(int.parse(b.joiningYear));
                    case 'Salary High to Low':
                      return int.parse(
                        b.salary.replaceAll(',', ''),
                      ).compareTo(int.parse(a.salary.replaceAll(',', '')));
                    case 'Salary Low to High':
                      return int.parse(
                        a.salary.replaceAll(',', ''),
                      ).compareTo(int.parse(b.salary.replaceAll(',', '')));
                    default:
                      return 0;
                  }
                });

                return Column(
                  children: [
                    CommonSearchBar(
                      labelText: 'Employees Page',
                      hintText: 'Employees',
                      onChanged: (p0) {},
                    ),
                    EmployeeFilterRow(
                      selectedStatus: selectedStatus,
                      selectedSort: selectedSort,

                      onStatusChanged: (newStatus) {
                        setState(() {
                          selectedStatus = newStatus!;
                        });
                      },

                      onSortingChanged: (sortOption) {
                        setState(() {
                          selectedSort = sortOption!;
                        });
                      },

                      onAddPressed: () {
                        setState(() {
                          employeeToEdit = null;
                          showAddEmployeeForm = true;
                        });
                      },
                    ),

                    Expanded(
                      child: employees.isEmpty
                          ? Center(child: Text('No Emlpyees Found'))
                          : ListView.builder(
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                final Employee = employees[index];
                                return EmployeeCard(
                                  name: Employee.name,
                                  designation: Employee.designation,
                                  salary: Employee.salary,
                                  phone: Employee.phoneNumber,
                                  joiningYear: Employee.joiningYear,
                                  status: Employee.status,
                                  imageUrl: Employee.imageUrl,

                                  onDelete: () {
                                    final key =
                                        Keys[index]; // Get the correct Hive key for this employee
                                    employeeBox.delete(key); // Delete from Hive
                                    setState(() {});
                                  },
                                  onEdit: () {
                                    setState(() {
                                      employeeToEdit = Employee;
                                      showAddEmployeeForm = true;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      selectedEmployee = Employee;
                                      showEmployeeDetails = true;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
//