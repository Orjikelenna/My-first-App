import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';
import '../widgets/spending_chart.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TransactionService _transactionService = TransactionService();
  final AuthService _authService = AuthService();
  int _currentIndex = 0;

  final List<String> _categories = [
    'Salary',
    'Business',
    'Food',
    'Transport',
    'Entertainment',
    'Shopping',
    'Health',
    'Other',
  ];

  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = true;
    String selectedCategory = 'Salary';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (₦)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Type: '),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: isIncome,
                    onSelected: (val) => setDialogState(() => isIncome = true),
                    selectedColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: !isIncome,
                    onSelected: (val) => setDialogState(() => isIncome = false),
                    selectedColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) =>
                    setDialogState(() => selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  _transactionService.addTransaction(
                    titleController.text,
                    double.parse(amountController.text),
                    isIncome,
                    selectedCategory,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return StreamBuilder<List<FinanceTransaction>>(
      stream: _transactionService.getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];
        double totalIncome = transactions
            .where((t) => t.isIncome)
            .fold(0, (sum, t) => sum + t.amount);
        double totalExpenses = transactions
            .where((t) => !t.isIncome)
            .fold(0, (sum, t) => sum + t.amount);
        double balance = totalIncome - totalExpenses;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  Text(
                    '₦${balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.arrow_upward, color: Colors.green),
                          const Text('Income'),
                          Text(
                            '₦${totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.red),
                          const Text('Expenses'),
                          Text(
                            '₦${totalExpenses.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (transactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SpendingChart(transactions: transactions),
              ),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions yet\nTap + to add one',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          transaction: transactions[index],
                          onDelete: () => _transactionService.deleteTransaction(
                            transactions[index].id,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    final TextEditingController searchController = TextEditingController();
    String searchQuery = '';
    String selectedFilter = 'All';

    return StatefulBuilder(
      builder: (context, setTabState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search transactions',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                setTabState(() => searchQuery = '');
                              },
                            )
                          : null,
                    ),
                    onChanged: (val) =>
                        setTabState(() => searchQuery = val.toLowerCase()),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Income', 'Expense'].map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilter == filter,
                            onSelected: (val) =>
                                setTabState(() => selectedFilter = filter),
                            selectedColor: Colors.deepPurple,
                            labelStyle: TextStyle(
                              color: selectedFilter == filter
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<FinanceTransaction>>(
                stream: _transactionService.getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var transactions = snapshot.data ?? [];

                  if (searchQuery.isNotEmpty) {
                    transactions = transactions
                        .where(
                          (t) =>
                              t.title.toLowerCase().contains(searchQuery) ||
                              t.category.toLowerCase().contains(searchQuery),
                        )
                        .toList();
                  }

                  if (selectedFilter == 'Income') {
                    transactions = transactions
                        .where((t) => t.isIncome)
                        .toList();
                  } else if (selectedFilter == 'Expense') {
                    transactions = transactions
                        .where((t) => !t.isIncome)
                        .toList();
                  }

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No transactions found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: transactions[index],
                        onDelete: () => _transactionService.deleteTransaction(
                          transactions[index].id,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileTab() {
    final user = _authService.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? 'User',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _authService.signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_buildHomeTab(), _buildTransactionsTab(), _buildProfileTab()];

    final appBarTitles = ['Finance Tracker', 'Transactions', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddTransactionDialog,
            ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddTransactionDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
