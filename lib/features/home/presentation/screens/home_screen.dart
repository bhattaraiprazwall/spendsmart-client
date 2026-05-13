import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
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
      body: Column(
        children: [
          _totalBalance(context),
          _showIncomeExpense(context),
        ],
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

  Widget _homeArrowIcon({required Color arrowColor, required Color boxColor}) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 187, 251, 119),
        color: boxColor,
        shape: BoxShape.circle,
      ),
      // child: const Icon(Icons.arrow_downward, color: Colors.green),
      child: Icon(Icons.arrow_downward, color: arrowColor),
    );
  }
}
