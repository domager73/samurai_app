class Dp {
  final int bar;
  final int balance;
  final int perDay;
  final int unclaimed;

  Dp(
      {required this.bar,
      required this.balance,
      required this.perDay,
      required this.unclaimed});

  Dp.fromJson({required Map<String, dynamic> json})
      : bar = json['bar'],
        balance = json['balance'],
        perDay = json['dpPerDay'],
        unclaimed = json['unclaimedDp'];
}
