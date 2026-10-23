import 'package:flutter/material.dart';

import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADMD Lab 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Task I: create users with nullable fields.
  final List<User> _users = [
    const User(name: 'Alice', age: 21, email: 'alice@example.com'),
    const User(name: 'Bob', age: 19),
    const User(name: 'Charlie'),
  ];

  // Task II: demonstrate initialized and uninitialized account numbers.
  late final List<BankAccount> _accounts = [
    BankAccount(holderName: 'Alice', balance: 1250.50, bankBranch: 'Bucharest')
      ..initializeAccount('RO001'),
    BankAccount(holderName: 'Bob', balance: 500.00, bankBranch: 'Cluj')
      ..initializeAccount('RO002'),
    BankAccount(holderName: 'Charlie'),
  ];

  // Task III: create a library and add books and magazines.
  late final Library _library = _createLibrary();

  Library _createLibrary() {
    final library = Library();

    final book = Book(
      title: 'Clean Code',
      author: 'Robert C. Martin',
      publishDate: DateTime(2008, 8, 1),
      pageCount: 464,
      isbn: '9780132350884',
    );

    final magazine = Magazine(
      title: 'Science Monthly',
      author: 'Editorial Team',
      publishDate: DateTime.now().subtract(const Duration(days: 30)),
      issueNumber: 12,
      publisher: 'Science Press',
    );

    library.addItem(book);
    library.addItem(magazine);

    // Demonstrate borrowing a book.
    library.borrowItem(
      book,
      _users[0],
      DateTime.now().add(const Duration(days: 14)),
    );

    return library;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Task I: Users
          Text('Task I — Users', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),

          ..._users.map(
            (user) => Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name),
                subtitle: Text(
                  'Age: ${user.getDisplayAge()}\n'
                  'Email: ${user.email ?? 'Not provided'}',
                ),
                isThreeLine: true,
              ),
            ),
          ),

          const Divider(height: 32),

          // Task II: Bank accounts
          Text(
            'Task II — Bank Accounts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          ..._accounts.map(
            (account) => Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text(account.holderName),
                subtitle: Text(
                  'Number: ${account.getDisplayAccountNumber()}\n'
                  'Balance: ${account.balance.toStringAsFixed(2)}\n'
                  'Branch: ${account.bankBranch ?? 'Not specified'}',
                ),
                isThreeLine: true,
              ),
            ),
          ),

          const Divider(height: 32),

          // Task III: Library
          Text(
            'Task III — Library',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          ..._library.items.map(
            (item) => Card(
              child: ListTile(
                leading: Icon(item is Book ? Icons.menu_book : Icons.newspaper),
                title: Text(item.title),
                subtitle: Text(
                  'Author: ${item.author ?? 'Not specified'}\n'
                  'Published: ${item.publishDate?.year ?? 'Unknown'}\n'
                  'Status: ${item.isBorrowed ? 'Borrowed by ${item.borrower!.name}' : 'Available'}',
                ),
                isThreeLine: true,
                trailing: item is Book
                    ? Text('${item.pageCount ?? '?'} pages')
                    : Text('Issue ${(item as Magazine).issueNumber ?? '?'}'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Library search',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Search for "Clean": '
            '${_library.searchByTitle('Clean').length} result(s)',
          ),
          Text(
            'Recent publications: '
            '${_library.getRecentItems().length}',
          ),

          const Divider(height: 32),

          // Original counter functionality
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
