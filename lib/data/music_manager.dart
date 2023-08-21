import 'package:just_audio/just_audio.dart';
import 'package:samurai_app/utils/enums.dart';

class MusicManager {
  AudioPlayer loadingPlayer = AudioPlayer();

  AudioPlayer menuSettingsSignWaterPlayer = AudioPlayer();

  AudioPlayer modalTextExplainPlayer = AudioPlayer();

  AudioPlayer numbersCodePlayer = AudioPlayer();

  AudioPlayer okCanselTransPlayer = AudioPlayer();

  AudioPlayer popupDownSybMenuPlayer = AudioPlayer();

  AudioPlayer popupSubmenuPlayer = AudioPlayer();

  AudioPlayer screenChangePlayer = AudioPlayer();

  AudioPlayer smallKeyLightningPlayer = AudioPlayer();

  AudioPlayer smallKeyRegAmountAllPlayer = AudioPlayer();

  AudioPlayer smallKeyWeaponPlayer = AudioPlayer();

  AudioPlayer swipeBackPlayer = AudioPlayer();

  AudioPlayer swipeForwPlayer = AudioPlayer();

  AudioPlayer zeroAmountNumberPlayer = AudioPlayer();



  Future<void> registerMusicAssets() async {
    await loadingPlayer.setAsset(MusicAssets.loading);

    await menuSettingsSignWaterPlayer.setAsset(MusicAssets.loading);

    await modalTextExplainPlayer.setAsset(MusicAssets.loading);

    await numbersCodePlayer.setAsset(MusicAssets.loading);

    await okCanselTransPlayer.setAsset(MusicAssets.loading);

    await popupDownSybMenuPlayer.setAsset(MusicAssets.loading);

    await popupSubmenuPlayer.setAsset(MusicAssets.loading);

    await screenChangePlayer.setAsset(MusicAssets.loading);

    await smallKeyLightningPlayer.setAsset(MusicAssets.loading);

    await smallKeyRegAmountAllPlayer.setAsset(MusicAssets.loading);

    await smallKeyWeaponPlayer.setAsset(MusicAssets.loading);

    await swipeBackPlayer.setAsset(MusicAssets.loading);

    await swipeForwPlayer.setAsset(MusicAssets.loading);

    await zeroAmountNumberPlayer.setAsset(MusicAssets.loading);
  }
}
