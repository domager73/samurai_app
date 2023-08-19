import 'package:flutter/foundation.dart';

import '../api/rest.dart';

class SamuraiStorage {
  var maxXP = 120.0; // TO-DO: this should be updated to current max XP every time
  int fireSamuraiGenesisBalance = 0;
  int waterSamuraiGenesisBalance = 0;
  int fireSamuraiInFight = 0;
  int waterSamuraiInFight = 0;

  late Map<String, dynamic> info;
  int fireSamuraiBalance = 0;
  int lockedFireSamuraiBalance = 0;
  double fireSamuraiXp = 0.0;
  int waterSamuraiBalance = 0;
  int lockedWaterSamuraiBalance = 0;
  double waterSamuraiXp = 0.0;
  int fireSamuraiUnclaimedXp = 0;
  int waterSamuraiUnclaimedXp = 0;
  DateTime? waterSamuraiXpExpiresDate;
  DateTime? fireSamuraiXpExpiresDate;

  Future<void> loadInfo() async {
    var info;
    try {
      info = await getSamuraiInfo();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (info != null) {
      lockedFireSamuraiBalance = info['locked_fire_samurai_balance'] * 1;
      fireSamuraiBalance = info['fire_samurai_balance'] * 1;
      fireSamuraiXp = info['fire_samurai_xp'] * 1.0;
      lockedWaterSamuraiBalance = info['locked_water_samurai_balance'] * 1;
      waterSamuraiBalance = info['water_samurai_balance'] * 1;
      waterSamuraiXp = info['water_samurai_xp'] * 1.0;
      waterSamuraiXpExpiresDate = DateTime.parse(info['water_samurai_unclaimed_xp_locked_date']);
      fireSamuraiXpExpiresDate = DateTime.parse(info['fire_samurai_unclaimed_xp_locked_date']);
      fireSamuraiUnclaimedXp = info['fire_samurai_unclaimed_xp'] * 1;
      waterSamuraiUnclaimedXp = info['water_samurai_unclaimed_xp'] * 1;
      fireSamuraiGenesisBalance = info['fire_samurai_genesis_balance'] * 1;
      waterSamuraiGenesisBalance = info['water_samurai_genesis_balance'] * 1;
      fireSamuraiInFight = info['battle_fire_samurai_balance'] * 1;
      waterSamuraiInFight = info['battle_water_samurai_balance'] * 1;
    }
  }

  Future<Map<String, dynamic>> getSamuraiInfo() async {
    return await Rest.getInfoSamurai();
  }
}

final samuraiStorage = SamuraiStorage();
