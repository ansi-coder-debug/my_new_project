// // widgets/dashboard_card.dart

// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constants/constant.dart';

// class DashboardCard extends StatelessWidget {
//   final String title;
//    final int ?currentCount; // e.g., available
//   final int? totalCount;   // e.g., total
//   final Color backgroundColor;
//   final VoidCallback onTap;
  
  

//   const DashboardCard({
//     Key? key,
//     required this.title,
//       this.currentCount,
//      this.totalCount,
//     required this.backgroundColor,
//     required this.onTap,
//   }) : super(key: key);
//  @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//          color: backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               spreadRadius: 1,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           // mainAxisSize: MainAxisSize.min,
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//            KHeight,
//             Text(
//               "$currentCount / $totalCount",
//                textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 22,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
              
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class DashboardCardItem {
  final String label;
  final String value;
  final VoidCallback onTap;

  DashboardCardItem({
    required this.label,
    required this.value,
    required this.onTap,
  });
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String totalValue;
  final IconData icon;
  final Color backgroundColor;
  final List<DashboardCardItem> items;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.totalValue,
    required this.icon,
    required this.backgroundColor,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
             Text(
  totalValue,
  style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600, // lighter than bold
    fontSize: 22,
  ),
)

            ],
          ),
          KHeight16,

          /// Bottom items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) => _buildItem(item)).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildItem(DashboardCardItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
