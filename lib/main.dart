import 'dart:convert';
import 'dart:math';
import 'package:apple_stocks_app_clone/news_card.dart';
import 'package:apple_stocks_app_clone/stock.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';
import 'package:pull_down_button/pull_down_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        dividerColor: const Color.fromARGB(255, 52, 52, 52),
        extensions: const [
          PullDownButtonTheme(
            dividerTheme: PullDownMenuDividerTheme(
              dividerColor: Color.fromARGB(255, 21, 21, 21),
              largeDividerColor: Color.fromARGB(255, 21, 21, 21),
            ),
            routeTheme: PullDownMenuRouteTheme(
              backgroundColor: Color.fromARGB(255, 31, 31, 31),
            ),
            itemTheme: PullDownMenuItemTheme(
              destructiveColor: Colors.red,
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        dividerTheme: const DividerThemeData(
          thickness: 0.8,
          color: Color.fromARGB(255, 52, 52, 52),
        ),
        primaryColor: const Color.fromARGB(255, 78, 172, 248),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _searchBarHeight = 35;
  int _offset = 0;
  double _opacityRate = 1;
  double _bottomSheetInitialRate = 0.2;
  bool _marqueeVisible = true;
  StockList _stockList = StockList(data: [
    Stock(
        open: 0.0,
        high: 0.0,
        low: 0.0,
        last: 0.0,
        close: 0.0,
        volume: 0,
        date: 0,
        symbol: 0,
        exchange: 0)
  ]);
  final controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _searchBarHeight = (35 - _scrollController.offset) > 0
          ? (35 - _scrollController.offset)
          : 0;

      _offset = _scrollController.offset.round();
      _opacityRate = min(max(1 - (_offset / 10), 0), 1);

      if (_offset > 0) FocusScope.of(context).unfocus();

      setState(() {});
    });
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    final data = await rootBundle.load("assets/data.json");
    final map = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );

    setState(() {
      _stockList = StockList.fromJson(map);
      // print(stockListToJson(_stockList));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bottomSheetInitialRate = 120 / MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // This way, bottom sheet will stay behind keyboard
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 28, 28, 30),
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 64, 64, 64),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, left: 20),
            child: SizedBox(
                width: 125,
                child: Image.asset(
                  "assets/yahoo.png",
                  fit: BoxFit.cover,
                )),
          ),
        ],
      ),
    );
  }

  Stack _buildBody() {
    return Stack(
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (e) {
            if (_scrollController.offset < 28 && _scrollController.offset > 0) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
              );
            } else if (_scrollController.offset >= 28 &&
                _scrollController.offset < 56) {
              _scrollController.animateTo(
                56,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                toolbarHeight: 35,
                centerTitle: false,
                titleSpacing: 15,
                title: SizedBox(
                  height: 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: min(35, _searchBarHeight),
                        child: CupertinoSearchTextField(
                          backgroundColor:
                              const Color.fromARGB(255, 29, 29, 31),
                          itemColor: const Color.fromARGB(255, 146, 146, 146)
                              .withOpacity(_opacityRate),
                          placeholderStyle: TextStyle(
                            color: Colors.grey.withOpacity(_opacityRate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 0.0,
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      PullDownButton(
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            onTap: () {},
                            title: 'My Symbols',
                          ),
                          const PullDownMenuDivider.large(),
                          PullDownMenuItem(
                            title: 'New List',
                            onTap: () {},
                            icon: CupertinoIcons.add,
                          ),
                        ],
                        animationBuilder: null,
                        position: PullDownMenuPosition.automatic,
                        buttonBuilder: (context, showMenu) => GestureDetector(
                          onTap: showMenu,
                          child: Row(
                            children: [
                              Text(
                                "My Symbols",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_up_chevron_down,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: 150,
                ),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                  itemBuilder: (c, i) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => animatedHide(),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_stockList.data[i].symbol}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${_stockList.data[i].exchange}",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: Sparkline(
                              data: [
                                _stockList.data[i].open ?? 0.0,
                                _stockList.data[i].high ?? 0.0,
                                _stockList.data[i].low ?? 0.0,
                                _stockList.data[i].last ?? 0.0,
                                _stockList.data[i].close ?? 0.0,
                              ],
                              lineColor: const Color.fromARGB(255, 52, 199, 89),
                              fillMode: FillMode.below,
                              lineWidth: 1.5,
                              gridLineLabelColor:
                                  const Color.fromARGB(255, 52, 199, 89),
                              averageLine: true,
                              averageLabel: false,
                              fillGradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 52, 199, 89),
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${_stockList.data[i].open}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 52, 199, 89),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "+${(_stockList.data[i].high / 100).toStringAsFixed(2)}",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  itemCount: _stockList.data.length,
                ),
              )
            ],
          ),
        ),
        _buildPersistentSheet(),
        _buildDetailSheet(),
      ],
    );
  }

  NotificationListener<DraggableScrollableNotification> _buildDetailSheet() {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification dsNotification) {
        // print("${dsNotification.extent}");
        if (dsNotification.extent > 0.99) {
          _marqueeVisible = false;
        } else {
          _marqueeVisible = true;
        }
        setState(() {});
        return true;
      },
      child: DraggableScrollableSheet(
        controller: controller,
        minChildSize: 0,
        snap: true,
        initialChildSize: 0,
        maxChildSize: 1,
        builder: ((context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 28, 28, 30),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Divider(),
                        const Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\$29.953,60",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "CCC * USD",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoSlidingSegmentedControl<int>(
                            backgroundColor: Colors.transparent,
                            thumbColor:
                                const Color.fromARGB(255, 114, 114, 114),
                            groupValue: 1,
                            onValueChanged: (int? value) {},
                            children: const <int, Widget>{
                              0: Text(
                                '1G',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              1: Text(
                                '1H',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              2: Text(
                                '1A',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              3: Text(
                                '3A',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              4: Text(
                                '6A',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              5: Text(
                                'S1Y',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              6: Text(
                                '1Y',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Sparkline(
                            data: [
                              _stockList.data[0].open ?? 0.0,
                              _stockList.data[0].high ?? 0.0,
                              _stockList.data[0].low ?? 0.0,
                              _stockList.data[0].last ?? 0.0,
                              _stockList.data[0].close ?? 0.0,
                            ],
                            lineColor: const Color.fromARGB(255, 52, 199, 89),
                            fillMode: FillMode.below,
                            lineWidth: 1.5,
                            enableGridLines: true,
                            gridLineLabelColor: Colors.grey,
                            averageLine: true,
                            averageLabel: false,
                            fillGradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 52, 199, 89),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            separatorBuilder: (context, i) => Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 1,
                                height: 50,
                                color: const Color.fromARGB(255, 71, 71, 71),
                              ),
                            ),
                            itemCount: 15,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => const SizedBox(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          'Open',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey, // Gri renk
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          '1,057',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white, // Beyaz renk
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          'High',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey, // Gri renk
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          '1,059',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white, // Beyaz renk
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          'Low',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey, // Gri renk
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0,
                                            horizontal:
                                                8.0), // Değişen kısmı burası
                                        child: Text(
                                          '1,056',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white, // Beyaz renk
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "BTC-USD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Bitcoin USD",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const OverflowBox(
                          maxWidth: 35,
                          maxHeight: 35,
                          child: Icon(
                            CupertinoIcons.ellipsis_circle_fill,
                            color: Color.fromARGB(255, 51, 51, 51),
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromARGB(255, 178, 178, 178),
                        ),
                        child: const OverflowBox(
                          maxWidth: 35,
                          maxHeight: 35,
                          child: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: Color.fromARGB(255, 51, 51, 51),
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  SizedBox _buildPersistentSheet() {
    return SizedBox.expand(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (DraggableScrollableNotification dsNotification) {
          print("${dsNotification.extent}");
          if (dsNotification.extent > 0.99) {
            _marqueeVisible = false;
          } else {
            _marqueeVisible = true;
          }
          setState(() {});
          return true;
        },
        child: DraggableScrollableSheet(
          minChildSize: _bottomSheetInitialRate,
          initialChildSize: 0.5,
          snap: true,
          snapSizes: const [
            0.5,
          ],
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 28, 28, 30),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 100, 100, 100),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Business News",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        "From Yahoo Finance",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 152, 152, 159),
                            fontWeight: FontWeight.w500,
                            height: 1.5),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 25,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemBuilder: (BuildContext context, int index) {
                          return const NewsCardWidget(
                            imageUrl: "assets/btc.jpeg",
                            title:
                                "No surprises in the expected Bitcoin ETF decisions once again.",
                            summary:
                                "The U.S. Securities and Exchange Commission (SEC)...",
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return _marqueeVisible
        ? AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 15,
            centerTitle: false,
            toolbarHeight: 70,
            actions: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const OverflowBox(
                    maxWidth: 30,
                    maxHeight: 30,
                    child: Icon(
                      CupertinoIcons.ellipsis_circle_fill,
                      color: Color.fromARGB(255, 28, 28, 30),
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stocks",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                    height: 1,
                  ),
                ),
                Text(
                  "September 29",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                    color: Color.fromARGB(255, 141, 141, 147),
                    height: 1,
                  ),
                ),
              ],
            ),
            elevation: 0,
          )
        : AppBar(
            toolbarHeight: 70,
            title: SizedBox(
              height: 60,
              child: Marqueer.builder(
                itemCount: 200,
                itemBuilder: (context, i) {
                  return SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_stockList.data[i % 12].symbol}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "\$${_stockList.data[i % 12].high}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              "+2.49",
                              style: TextStyle(
                                color: Color.fromARGB(255, 52, 199, 89),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 60,
                          height: 50,
                          child: Sparkline(
                            data: [
                              _stockList.data[i % 12].open ?? 0.0,
                              _stockList.data[i % 12].high ?? 0.0,
                              _stockList.data[i % 12].low ?? 0.0,
                              _stockList.data[i % 12].last ?? 0.0,
                              _stockList.data[i % 12].close ?? 0.0,
                            ],
                            lineColor: const Color.fromARGB(255, 52, 199, 89),
                            fillMode: FillMode.below,
                            lineWidth: 1.5,
                            averageLine: true,
                            averageLabel: false,
                            fillGradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 52, 199, 89),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  void animatedHide() {
    controller.animateTo(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
