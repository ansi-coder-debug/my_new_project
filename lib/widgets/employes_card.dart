import 'package:flutter/material.dart';

class EmployesCard extends StatelessWidget {
  final String initials; // e.g., 'JD'
  final Color avatarColor; // e.g., Colors.blue
  final String name; // e.g., 'John Doe'
  final String department; // e.g., 'Software Development'
  final String joinedDate; // e.g., 'Joined June 15, 2023'
  final String employeeId; // e.g., 'EMP-001'
  final String status; // e.g., 'Active'
  final Color statusColor; // e.g., Colors.green
  final VoidCallback onTap; // tap action for this employee

  const EmployesCard({
    super.key,
    required this.avatarColor,
    required this.department,
    required this.employeeId,
    required this.initials,
    required this.joinedDate,
    required this.name,
    required this.onTap,
    required this.status,
    required this.statusColor,
  });
  @override
   Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,//connect call back
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                   '${department} • ${joinedDate}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$employeeId.$status',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
      color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }





  
}
