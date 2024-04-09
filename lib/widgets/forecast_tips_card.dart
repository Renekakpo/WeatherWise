import 'package:flutter/material.dart';

class ForecastTipsCard extends StatefulWidget {
  const ForecastTipsCard({super.key});

  @override
  State<ForecastTipsCard> createState() => _ForecastTipsCardState();
}

class _ForecastTipsCardState extends State<ForecastTipsCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildForecastTips(context);
  }

  Widget _buildForecastTips(BuildContext context) {
    final tips = [
      'Tomorrow\'s Feels like Temperature',
      'Tomorrow\'s Temperature',
      'Rise and shine',
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.12,
            child: PageView.builder(
              controller: _pageController,
              itemCount: tips.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _buildTipItem(tips[index]);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          _buildDotsRow(tips.length),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tipText) {
    return Column(
      children: [
        Expanded(
          child: Text(
            tipText,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.grey, // Change the color as needed
                fontSize: 12.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
            child: Text(
              tipText,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black, // Change the color as needed
                fontSize: 12.0,
              ),
            )
        )
      ],
    );
  }

  Widget _buildDotsRow(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.all(4.0),
          width: 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blueGrey : Colors.grey,
          ),
        ),
      ),
    );
  }
}
