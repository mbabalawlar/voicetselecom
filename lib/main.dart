import 'package:voicestelecom/Bulksms.dart';
import 'package:voicestelecom/screens/upgradepackage.dart';

import './screens/atm2.dart';

import './screens/login.dart';
import './screens/signup.dart';
import 'screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/onboardui.dart';
import 'screens/signup.dart';
import 'screens/login.dart';
import 'screens/pricing.dart';
import 'screens/setting.dart';
import 'history.dart';
import 'cablesub.dart';
import 'billpayment.dart';
import 'payment.dart';
import 'airtimefunding.dart';
import 'bankpayment.dart';
import 'buyairtime.dart';
import 'buydata.dart';
import 'passwordchange.dart';
import 'passwordreset.dart';
import 'withdraw.dart';
import 'Trasnsfer.dart';
import 'bonus.dart';
import 'billreceipt.dart';
import 'walletsummary.dart';
import 'screens/about.dart';
import 'screens/contact.dart';
import 'chatwidget.dart';
import 'screens/kyc.dart';
import 'Referal.dart';
import 'screens/result_checkerform.dart';
import 'banknotice.dart';
import 'screens/website.dart';
import 'pin_management.dart';
import 'couponpayment.dart';
import './screens/welcome.dart';
import 'recharge_print.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'screens/complain.dart';
import 'screens/atm.dart';
import 'screens/newdashboard.dart';
import 'manualbank.dart';
import 'screens/site_request.dart';
import 'screens/landpage.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/home': (context) => Dashboard(),
        '/onboard': (context) => OnBoardScreen(),
        '/landingpage': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/setting': (context) => Setting(),
        '/bank': (context) => BankPagePayment(),
        '/airtimefundin': (context) => AirtimeFunding(),
        '/paystack': (context) => CheckoutMethodSelectable(),
        '/bill': (context) => ElectPayment(),
        '/cablename': (context) => CableS(),
        '/history': (context) => History(),
        '/airtimenet': (context) => BuyAirtime(),
        '/datanet': (context) => BuyData(),
        '/changepassword': (context) => Change(),
        '/ResetPassword': (context) => ResetPassword(),
        '/transfer': (context) => Transfer(),
        '/withdraw': (context) => Withdraw(),
        '/bonus': (context) => Bonus(),
        '/billreceipt': (context) => Billreceipt(),
        '/wallet': (context) => WalletSummary(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
        '/supportchat': (context) => ChatWidget(),
        '/referal': (context) => MyReferal(),
        '/ResultChecker': (context) => ResultChecker(),
        '/banknotice': (context) => BankNotice(),
        '/pricing': (context) => PricingWidget(),
        "/web": (context) => WebsiteWidget(),
        '/website': (context) => WebsiteWidget(),
        '/kyc': (context) => KycPage(),
        '/pin': (context) => PIn(),
        '/coupon': (context) => Coupon(),
        '/welcome': (context) => WelcomeP(),
        '/recharge': (context) => RechargeCard(),
        '/complain': (context) => Complain(),
        '/atm': (context) => Atm(),
        '/atm2': (context) => SecondAtm(),
        '/bank2': (context) => BankManualPayment(),
        '/rsite': (context) => RessellerSIte(),
        "/upgrade": (context) => UpgradePackage(),
        "/bulksms": (context) => Bulksms(),
      },
      theme: ThemeData(
        fontFamily: "Roboto",
        primaryColor: Colors.green[700],
        accentColor: Colors.green[700],
      ),
      debugShowCheckedModeBanner: false,
      title: ' voicestelecom',
      home: Stack(
        children: [
          ConnectionStatusBar(),
          SplashScreen(),
        ],
      ),
    ),
  );
}
