import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '/widgets/chart.dart';
import '/widgets/transaction_list.dart';
import '/models/transaction.dart';
import '/widgets/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    primarySwatch: Colors.purple,
    fontFamily: 'Quicksand',
    textTheme: ThemeData.light().textTheme.copyWith(
          titleSmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const title = 'Personal Expenses';
    const homepage = MyHomePage();
    return MaterialApp(
      title: title,
      home: homepage,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.amber),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Uuid _uuid = const Uuid();
  final List<Transaction> _userTransactions = [];
  bool _showChart = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    print('initState() _MyHomePageState');

    _userTransactions.addAll(
      [
        Transaction(
          id: _uuid.v4(),
          title: 'My transaction',
          amount: 40,
          date: DateTime.now(),
        ),
        Transaction(
          id: _uuid.v4(),
          title: 'Dinner',
          amount: 250,
          date: DateTime.now(),
        ),
        Transaction(
          id: _uuid.v4(),
          title: 'Wine bar',
          amount: 131.20,
          date: DateTime.now(),
        ),
        Transaction(
          id: _uuid.v4(),
          title: 'Maccas',
          amount: 62.10,
          date: DateTime.now(),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState() _MyHomePageState $state');
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (buildCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(addNewTransaction: _addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  List<Widget> _buildMainLayout({
    required double fixedHeight,
    required bool isPortrait,
    required double width,
  }) {
    final chartWidget = SizedBox(
      height: fixedHeight * (isPortrait ? 0.25 : 0.4),
      child: Chart(recentTransactions: _recentTransactions),
    );
    final transactionListWidget = SizedBox(
      height: fixedHeight * 0.75,
      child: Transactionlist(
        userTransactions: _userTransactions,
        deleteTransaction: _deleteTransaction,
        mediaWidth: width,
      ),
    );

    if (isPortrait) {
      return [
        chartWidget,
        transactionListWidget,
      ];
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (val) => setState(() => _showChart = val),
          ),
        ],
      ),
      _showChart ? chartWidget : transactionListWidget
    ];
  }

  Widget _buildAppBar(Widget title) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: title,
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: const Icon(Icons.add),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    print('build() _MyHomePageState');
    const title = Text('Personal Expenses');
    final appBar = _buildAppBar(title) as PreferredSizeWidget;
    final mediaQuery = MediaQuery.of(context);
    final fixedHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    final width = mediaQuery.size.width;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildMainLayout(
            fixedHeight: fixedHeight,
            isPortrait: isPortrait,
            width: width,
          ),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as CupertinoNavigationBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? const SizedBox()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
