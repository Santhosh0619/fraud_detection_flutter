import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fraud Detection App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _terminalIdController = TextEditingController();
  final TextEditingController _txAmountController = TextEditingController();
  final TextEditingController _txTimeSecondsController =
      TextEditingController();
  final TextEditingController _txTimeDaysController = TextEditingController();

  String _result = '';
  bool _isFraud = false;

  Future<void> _predictFraud() async {
    if (_transactionIdController.text.isEmpty) {
      _showToast("Transaction ID is required");
      return;
    }
    if (_customerIdController.text.isEmpty) {
      _showToast("Customer ID is required");
      return;
    }
    if (_terminalIdController.text.isEmpty) {
      _showToast("Terminal ID is required");
      return;
    }
    if (_datecontroller.text.isEmpty) {
      _showToast("Transaction Date is required");
      return;
    }
    if (_txTimeSecondsController.text.isEmpty) {
      _showToast("Transaction Time in seconds is required");
      return;
    }
    if (_txTimeDaysController.text.isEmpty) {
      _showToast("Transaction Time in Days is required");
      return;
    }
    if (_txAmountController.text.isEmpty) {
      _showToast("Transaction Amount is required");
      return;
    }
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final response = await http.post(
      url,
      body: json.encode({
        "TRANSACTION_ID": _transactionIdController.text,
        "TX_DATETIME": _datecontroller.text,
        "CUSTOMER_ID": _customerIdController.text,
        "TERMINAL_ID": _terminalIdController.text,
        "TX_AMOUNT": _txAmountController.text,
        "TX_TIME_SECONDS": _txTimeSecondsController.text,
        "TX_TIME_DAYS": _txTimeDaysController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    setState(() {
      _isFraud = responseData['is_fraud'] == 1;
      _result =
          _isFraud ? 'Fraudulent Transaction' : 'Non-Fraudulent Transaction';
    });
  }

  void _showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
      webShowClose: true,
      webPosition: "center",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const _LeftPanel(),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/banner.webp",
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "VERIFY YOUR TRANSACTION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff263547),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 110),
                          child: const Text(
                            "*Note that this predicts the possibility or likeliness of your transactions being a fraud or not. In case of fraud you need to cross verify the transaction with the bank and take necessary steps immediately.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _transactionIdController,
                                        decoration: InputDecoration(
                                          labelText: 'Transaction ID',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _customerIdController,
                                        decoration: InputDecoration(
                                          labelText: 'Customer ID',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _terminalIdController,
                                        decoration: InputDecoration(
                                          labelText: 'Terminal ID',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime? initialDate;
                                        DateTime? firstDate;
                                        DateTime? lastDate;
                                        initialDate ??= DateTime.now();
                                        firstDate ??= initialDate.subtract(
                                            const Duration(days: 365 * 100));
                                        lastDate ??= firstDate.add(
                                            const Duration(days: 365 * 200));

                                        final DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: initialDate,
                                          firstDate: firstDate,
                                          lastDate: lastDate,
                                        );

                                        if (selectedDate == null) return;

                                        if (!context.mounted) return;

                                        final TimeOfDay? selectedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              selectedDate),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                alwaysUse24HourFormat: true,
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (selectedTime == null) return;
                                        final DateTime selectedDateTime =
                                            DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                          0,
                                        );

                                        final DateFormat formatter =
                                            DateFormat('yyyy-MM-dd hh:mm:ss');
                                        final String formatted =
                                            formatter.format(selectedDateTime);
                                        _datecontroller.text = formatted;
                                      },
                                      child: SizedBox(
                                        height: 45,
                                        child: TextField(
                                          controller: _datecontroller,
                                          style: TextStyle(
                                            color:
                                                Colors.black87.withOpacity(0.8),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Transaction Date',
                                            labelStyle: TextStyle(
                                              color: Colors.black87
                                                  .withOpacity(0.8),
                                            ),
                                            enabled: false,
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black87
                                                    .withOpacity(0.5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            ),
                                          ],
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _txTimeSecondsController,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Transaction Time (Seconds)',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _txTimeDaysController,
                                        decoration: InputDecoration(
                                          labelText: 'Transaction Time (Days)',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 45,
                                child: TextField(
                                  controller: _txAmountController,
                                  decoration: InputDecoration(
                                    labelText: 'Transaction Amount',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'),
                                    ),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          child: ElevatedButton(
                            onPressed: _predictFraud,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(vertical: 20),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Predict Fraud',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Adjusted height
                        if (_result != '')
                          Container(
                            decoration: BoxDecoration(
                              color: _isFraud
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _isFraud
                                      ? "assets/images/fraud.png"
                                      : "assets/images/safe.png",
                                  height: 38,
                                  width: 38,
                                ),
                                const SizedBox(width: 28),
                                Text(
                                  _result,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: _isFraud ? Colors.red : Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 28),
                                Image.asset(
                                  _isFraud
                                      ? "assets/images/fraud.png"
                                      : "assets/images/safe.png",
                                  height: 38,
                                  width: 38,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        color: Color(0xfff0f0f0),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/fraud_detection_logo.png",
                height: 80,
                width: 100,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fraud Detection",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff263547),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Verify your transactions",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: const Text(
              "Fraud transactions have increased making people lose much of their earnings. It's time we become aware and safe with online transaction and save our hard earned money. Verify your transactions here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff263547),
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/images/black_hat_hacker.png",
                width: double.infinity,
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
