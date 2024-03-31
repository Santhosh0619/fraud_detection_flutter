import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final List<String> cities = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Kolkata",
    "Chennai",
    "Hyderabad",
    "Ahmedabad",
    "Pune",
    "Surat",
    "Lucknow",
    "Jaipur",
    "Kanpur",
    "Coimbatore",
    "Indore",
    "Visakhapatnam",
    "Bhopal",
    "Thrissur",
    "Vadodara"
  ];

  final List<String> deviceTypes = [
    "low_end_phone",
    "low_end_laptop",
    "low_end_tablet",
    "high_end_phone",
    "high_end_laptop",
    "high_end_tablet"
  ];

  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _txAmountController = TextEditingController();
  final TextEditingController _avgPreviousTxController =
      TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _cvvAttemptsController = TextEditingController();

  String? selectedCity;
  String? selectedDeviceType;

  String _result = '';
  bool _isFraud = false;

  Future<void> _predictFraud() async {
    if (_customerIdController.text.isEmpty) {
      _showToast("Customer ID is required");
      return;
    }
    if (_emailController.text.isEmpty) {
      _showToast("Email ID is required");
      return;
    }
    if (_txAmountController.text.isEmpty) {
      _showToast("Transaction Amount is required");
      return;
    }

    if (_avgPreviousTxController.text.isEmpty) {
      _showToast("Avg. Previous Transaction Amount is required");
      return;
    }

    if (_cvvAttemptsController.text.isEmpty) {
      _showToast("CVV Attempts is required");
      return;
    }

    if (_ipAddressController.text.isEmpty) {
      _showToast("IP Address is required");
      return;
    }

    if (selectedCity == null) {
      _showToast("Transaction City is required");
      return;
    }

    if (selectedCity == null) {
      _showToast("Transaction City is required");
      return;
    }

    if (selectedDeviceType == null) {
      _showToast("Device Type is required");
      return;
    }

    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final response = await http.post(
      url,
      body: json.encode({
        "customer_id": int.tryParse(_customerIdController.text) ?? 0,
        "email": _emailController.text,
        "transaction_amount": int.tryParse(_txAmountController.text) ?? 0,
        "current_city": selectedCity,
        "device_type": selectedDeviceType,
        "ip_address": _ipAddressController.text,
        "cvv_attempts": int.tryParse(_cvvAttemptsController.text) ?? 0,
        "average_previous_amounts": int.tryParse(_avgPreviousTxController.text),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body);

    setState(() {
      _isFraud = responseData['is_fraud'];
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
            child: SingleChildScrollView(
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
                                        controller: _customerIdController,
                                        maxLength: 5,
                                        decoration: InputDecoration(
                                          labelText: 'Customer ID',
                                          counterText: "",
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
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                        controller: _txAmountController,
                                        maxLength: 7,
                                        decoration: InputDecoration(
                                          labelText: 'Transaction Amount',
                                          counterText: "",
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
                                            RegExp(r'[0-9.]'),
                                          ),
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _avgPreviousTxController,
                                        maxLength: 7,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Avg. Previous Transactions',
                                          counterText: "",
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
                                            RegExp(r'[0-9.]'),
                                          ),
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
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
                                        controller: _ipAddressController,
                                        decoration: InputDecoration(
                                          labelText: 'IP Address',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        controller: _cvvAttemptsController,
                                        maxLength: 2,
                                        decoration: InputDecoration(
                                          labelText: 'Total CVV Attempts',
                                          counterText: "",
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
                                            RegExp(r'[0-9.]'),
                                          ),
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
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
                                    child: Container(
                                      height: 45,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: DropdownButton(
                                        value: selectedCity,
                                        underline: const SizedBox.shrink(),
                                        isExpanded: true,
                                        hint: const Text("Select City"),
                                        items: cities
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCity = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      height: 45,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: DropdownButton(
                                        value: selectedDeviceType,
                                        underline: const SizedBox.shrink(),
                                        isExpanded: true,
                                        hint: const Text("Select Device Type"),
                                        items: deviceTypes
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedDeviceType = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 10), // Adjusted height
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
                      ],
                    ),
                  ),
                ],
              ),
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
