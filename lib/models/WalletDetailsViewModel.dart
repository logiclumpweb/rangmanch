// To parse this JSON data, do
//
//     final walletDetailsViewModel = walletDetailsViewModelFromJson(jsonString);

import 'dart:convert';

WalletDetailsViewModel walletDetailsViewModelFromJson(String str) => WalletDetailsViewModel.fromJson(json.decode(str));

String walletDetailsViewModelToJson(WalletDetailsViewModel data) => json.encode(data.toJson());

class WalletDetailsViewModel {
  WalletDetailsViewModel({
   required this.message,
   required this.status,
   required this.walletAmt,
   required this.inrWallet,
   required this.totalEarn,
   required this.totalEarnToday,
   required this.resultsTodayInr,
   required this.totalEarnWeekly,
   required this.totalEarnWeeklyInr,
  });

  String message;
  String status;
  dynamic walletAmt;
  dynamic inrWallet;
  dynamic totalEarn;
  dynamic totalEarnToday;
  dynamic resultsTodayInr;
  dynamic totalEarnWeekly;
  dynamic totalEarnWeeklyInr;

  factory WalletDetailsViewModel.fromJson(Map<String, dynamic> json) => WalletDetailsViewModel(
    message: json["message"],
    status: json["status"],
    walletAmt: json["wallet_amt"],
    inrWallet: json["inr_wallet"],
    totalEarn: json["total_earn"].toDouble(),
    totalEarnToday: json["total_earn_today"].toDouble(),
    resultsTodayInr: json["results_today_INR"],
    totalEarnWeekly: json["total_earn_weekly"].toDouble(),
    totalEarnWeeklyInr: json["total_earn_weekly_INR"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "wallet_amt": walletAmt,
    "inr_wallet": inrWallet,
    "total_earn": totalEarn,
    "total_earn_today": totalEarnToday,
    "results_today_INR": resultsTodayInr,
    "total_earn_weekly": totalEarnWeekly,
    "total_earn_weekly_INR": totalEarnWeeklyInr,
  };
}
