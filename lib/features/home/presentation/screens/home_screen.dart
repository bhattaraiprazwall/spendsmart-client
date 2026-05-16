import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/common/bottom_nav_bar.dart';
import 'package:spendsmart/core/widgets/common/spendsmart_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendsmartAppbar(
        onProfileTap: () {},
        onMenuTap: () {},
        profileImageUrl:
            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalBalance(context),
            _showIncomeExpense(context),
            _smartForecast(context),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                'Remaining Budget',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            _remainingBudget(context),
            _spendingBreakDown(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (index) {
          print('Tab changed to $index');
        },
      ),
    );
  }

  Widget _totalBalance(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL BALANCE',
              style: AppTextStyles.body.copyWith(
                color: const Color.fromARGB(255, 209, 219, 228),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              '\$4,250.00',
              style: AppTextStyles.body.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w600,
                fontSize: 40,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.greenAccent),
                Text(
                  '+2.4% vs last month',
                  style: AppTextStyles.label.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showIncomeExpense(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _homeArrowIcon(
                      boxColor: const Color.fromARGB(255, 187, 251, 119),
                      arrowColor: Colors.green,
                      arrowDirection: Icons.arrow_downward,
                    ),
                    Text(
                      ' INCOME',
                      style: AppTextStyles.body.copyWith(
                        color: const Color.fromARGB(255, 77, 143, 2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '\$3,100',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, right: 20, top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _homeArrowIcon(
                      boxColor: Colors.grey.shade200,
                      arrowColor: Colors.black,
                      arrowDirection: Icons.arrow_upward,
                    ),
                    Text(
                      ' EXPENSES',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  '\$1,850',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _homeArrowIcon({
    required Color arrowColor,
    required Color boxColor,
    required IconData arrowDirection,
  }) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 187, 251, 119),
        color: boxColor,
        shape: BoxShape.circle,
      ),
      // child: const Icon(Icons.arrow_downward, color: Colors.green),
      child: Icon(arrowDirection, color: arrowColor),
    );
  }

  Widget _smartForecast(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 41, 59, 0.05),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smartForecastIcon(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Forecast',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    'You\'re on the track to save \$120 this month.Keep dining out below \$50 this week to hit your goal.',
                    style: AppTextStyles.body.copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smartForecastIcon() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),

      child: Icon(Icons.lightbulb, color: AppColors.white),
    );
  }

  Widget _remainingBudget(BuildContext context) {
    // final budgetHead = 5;
    final List<Map<String, dynamic>> bugetData = [
      {
        'icon': Icons.shopping_cart_outlined,
        'amount': '\$150 left',
        'label': 'GROCERIES',
        'progress': 0.6,
        'color': Colors.blue,
        'iconColor': Colors.grey,
      },
      {
        'icon': Icons.restaurant_outlined,
        'amount': '\$15 left',
        'label': 'DINING OUT',
        'progress': 0.9,
        'color': Colors.red,
        'iconColor': Colors.red,
      },
      {
        'icon': Icons.movie_outlined,
        'amount': '\$80 left',
        'label': 'ENTERTAINMENT',
        'progress': 0.3,
        'color': Colors.purple,
        'iconColor': Colors.purple,
      },
    ];
    return SingleChildScrollView(
      // padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(bugetData.length, (index) {
          final item = bugetData[index];
          return _budgetCard(context, item);
        }),
      ),
    );
  }

  Widget _budgetCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Icon + Amount Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (item['iconColor'] as Color).withOpacity(0.1),
                ),
                child: Icon(item['icon'] as IconData, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                item['amount'] as String,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: item['iconColor'] as Color,
                ),
              ),
            ],
          ),

          const Spacer(),
          //label
          Text(
            item['label'] as String,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          //ProgressBar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item['progress'] as double,
              backgroundColor: Colors.grey.shade200,
              color: item['color'] as Color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _spendingBreakDown(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),

      height: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),

      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spending Breakdown',
                style: AppTextStyles.body.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Text('Top category:Housing'),
            ],
          ),
        ],
        
      ),
    );
  }
}
