import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_management/payments/info.dart';
import 'package:school_management/utils/constants/asset_paths.dart';

class RazorPayPaymentScreen extends StatefulWidget {
  const RazorPayPaymentScreen({super.key});

  @override
  State<RazorPayPaymentScreen> createState() => _RazorPayPaymentScreenState();
}

class _RazorPayPaymentScreenState extends State<RazorPayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /// 🎯 OPEN RAZORPAY GATEWAY
  void openPaymentGateway() {
    var options = {
      'key': 'rzp_test_0wFRWIZnH65uny',
      'amount': 21300, // Amount in paise → ₹213
      'name': 'SnehVidya School',
      'description': 'ID Card Application Fee',
      'image': 'https://avatars.githubusercontent.com/u/111274627?v=4',
      'prefill': {'contact': '8862071189', 'email': 'sdchavan8070@gmail.com'},
      'theme': {'color': '#066AC9'},
    };

    _razorpay.open(options);
  }

  /// 🎉 SUCCESS ALERT
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showAlert(title: "Payment Successful", response: "Your payment ID is: ${response.paymentId}");
  }

  /// ❌ FAILURE ALERT
  void _handlePaymentError(PaymentFailureResponse response) {
    showAlert(title: "Payment Failed", response: "Reason: ${response.message}");
  }

  /// 💼 WALLET
  void _handleExternalWallet(ExternalWalletResponse response) {
    showAlert(title: "External Wallet Selected", response: "You selected: ${response.walletName}");
  }

  /// ALERT FUNCTION
  void showAlert({required String title, required String response}) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(response),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),

              /// Razorpay Logo / Image
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(aspectRatio: 1, child: Image.asset(AssetPaths.razorPayPNG)),
              ),

              const Spacer(flex: 2),

              /// INFORMATION + PAY BUTTON
              Info(
                title: "ID Card Application – ₹213",
                description:
                    "You are applying for a new student ID card.\n\n"
                    "• Application Fee: ₹213\n"
                    "• Processing Time: 2–3 working days\n\n"
                    "Razorpay services may be temporarily unavailable due to maintenance. "
                    "If the payment fails, please try again after some time.",
                btnText: "Pay ₹213",
                btnColor: const Color(0xFF066AC9),
                press: openPaymentGateway,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
