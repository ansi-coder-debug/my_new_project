import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/subscription/Subscription_Plan_Card.dart';

class ScreenSubscription extends ConsumerStatefulWidget {
  const ScreenSubscription({super.key});

  @override
  ConsumerState<ScreenSubscription> createState() => _ScreenSubscriptionState();
}

class _ScreenSubscriptionState extends ConsumerState<ScreenSubscription> {
  @override
  Widget build(BuildContext context) {
    // appBar: AppBar(
    //   leading: BackButton(),
    //   title: const Text('Subscription Plans'),
    //   centerTitle: false,
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   foregroundColor: Colors.black,
    // ),
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            CustomHeader(
              title: "Subscription Plans",
              onBack: () {
                //last index wanna do at later
              },
            ),
            KHeight,

            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubscriptionPlanCard(
                      badgeText: 'Save 20%',
                      planLabel: 'Premium',
                      title: 'Starter',
                      price: '₹1,999 / month',
                      description: 'Ideal for small dealerships.',
                      features: [
                        'Up to 50 vehicle listings',
                        'Basic sales & expense tracking',
                        '1 user account',
                        'Email support',
                      ],
                      onSelect: () {
                        // Handle subscription logic
                      },
                      onLearnMore: () {
                        // Handle Learn More
                      },
                    ),
                    KHeight,
                    SubscriptionPlanCard(
                      badgeText: 'Most Popular',
                      planLabel: 'Premium',
                      title: 'Pro',
                      price: '₹4,999 / month',
                      description: 'For growing businesses.',
                      features: [
                        'Unlimited vehicle listings',
                        'Advanced sales analytics',
                        'Employee & partnership management',
                        'Up to 5 user accounts',
                        'Priority email & chat support',
                      ],
                      onSelect: () {
                        // Handle Pro plan subscription logic
                      },
                      onLearnMore: () {
                        // Handle Learn More for Pro plan
                      },
                    ),
                    KHeight,
            
                    SubscriptionPlanCard(
                      badgeText: 'Custom',
                      planLabel: 'Premium',
                      title: 'Enterprise',
                      price: 'Contact Us',
                      description: 'For large-scale operations.',
                      features: [
                        'All features from Pro',
                        'Advanced reporting & insights',
                        'Custom user roles & permissions',
                        'API Access for integrations',
                        'Dedicated account manager',
                      ],
                      onSelect: () {
                        // Handle Contact Us logic
                      },
                      onLearnMore: () {
                        // Handle Request a Demo logic
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;
  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
