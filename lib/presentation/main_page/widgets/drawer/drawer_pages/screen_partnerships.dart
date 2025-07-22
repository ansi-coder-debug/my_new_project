import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_form.dart';
import 'package:my_new_project/widgets/partnerships/partnership_card.dart';
import 'package:my_new_project/widgets/partnerships/partnership_details_screen.dart';
import 'package:my_new_project/widgets/partnerships/partnership_filter_row.dart';

class ScreenPartnerships extends StatefulWidget {
  const ScreenPartnerships({super.key});

  @override
  State<ScreenPartnerships> createState() => _ScreenPartnershipsState();
}

class _ScreenPartnershipsState extends State<ScreenPartnerships> {
  bool showAddPartnershipForm = false;
  Partnership? partnershipToEdit;

  //details page
  bool showPartnershipDetails = false;
  Partnership? selectedPartnership;

  //delete from bothpages
  

  final Box<Partnership> partnershipBox = Hive.box<Partnership>('partnerships');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showAddPartnershipForm
          ?
            // If true, show the Add Expense Form instead of the list
            AddPartnershipForm(
              onCancel: () {
                // 👉 When user clicks 'Cancel' inside the form:
                // Close the form and show the list again
                setState(() {
                  showAddPartnershipForm = false;
                });
              },
              onAddComplete: () {
                // 👉 When user completes adding a new expense:
                // Close the form and show the list again
                setState(() {
                  showAddPartnershipForm = false;
                });
              },
              partnershipToEdit: partnershipToEdit,

              // ✅ If false, show the normal Expense List page UI
            )
          : showPartnershipDetails && selectedPartnership != null
          ? PartnershipDetailsScreen(
              partnership: selectedPartnership!,
              onBack: () {
                setState(() {
                  showAddPartnershipForm = false;
                  selectedPartnership = null;
                });
              },
              onEdit: () {
                setState(() {
                  partnershipToEdit = selectedPartnership;
                  showPartnershipDetails = false;
                  showAddPartnershipForm = true;
                });
              },
            )
          : ValueListenableBuilder(
              valueListenable: Hive.box<Partnership>(
                'partnerships',
              ).listenable(),
              builder: (context, box, _) {
                //getting details of partnerships
                List<Partnership> partnerships = box.values.toList();
                //Get all keys as numbers in a list
                List<dynamic> keys = box.keys.toList();

                return Column(
                  children: [
                    CommonSearchBar(
                      labelText: "Partnership Page",
                      hintText: 'Partnership',
                      onChanged: (p0) {},
                    ),
                    PartnershipFilterRow(
                      onAddPressed: () {
                        setState(() {
                          partnershipToEdit = null;
                          showAddPartnershipForm = true;
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: partnerships.length,
                        itemBuilder: (context, index) {
                          final Partnership = partnerships[index];
                          return PartnershipCard(
                            id: Partnership.id,
                            partnerName: Partnership.partnerName,
                            contactPerson: Partnership.contactPerson,
                            email: Partnership.email,
                            phone: Partnership.phone,
                            sharePercentage: Partnership.sharePercentage,
                            vehicleId: Partnership.vehicleId,
                            startDate: Partnership.startDate,
                            onDelete: () async {
                              await partnerships[index].delete();
                            },
                            onEdit: () {
                              setState(() {
                                partnershipToEdit = Partnership;
                                showAddPartnershipForm = true;
                              });
                            },
                            onTap: () {
                              setState(() {
                                selectedPartnership = Partnership;
                                showPartnershipDetails = true;
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
 // children: [
      //   
      //   PartnershipFilterRow(
      //     onAddPressed: () {
      //       setState(() {
      //         showAddPartnershipForm = true;
      //       });
      //     },
      //   ),
      // ],