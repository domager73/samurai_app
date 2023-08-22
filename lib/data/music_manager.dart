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
    loadingPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    menuSettingsSignWaterPlayer = AudioPlayer()
      ..setAsset(MusicAssets.menuSettingSignWater);

    modalTextExplainPlayer = AudioPlayer()
      ..setAsset(MusicAssets.modalTextExplain);

    numbersCodePlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    okCanselTransPlayer = AudioPlayer()..setAsset(MusicAssets.okCanselTrans);

    popupDownSybMenuPlayer = AudioPlayer()
      ..setAsset(MusicAssets.popupDownSubMenu);

    popupSubmenuPlayer = AudioPlayer()..setAsset(MusicAssets.popupSubMenu);

    screenChangePlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    smallKeyLightningPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    smallKeyRegAmountAllPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    smallKeyWeaponPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    swipeBackPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    swipeForwPlayer = AudioPlayer()..setAsset(MusicAssets.loading);

    zeroAmountNumberPlayer = AudioPlayer()..setAsset(MusicAssets.loading);
  }

  Future<void> disposeMusicAssets() async {
    await loadingPlayer.dispose();

    await menuSettingsSignWaterPlayer.dispose();

    await modalTextExplainPlayer.dispose();

    await numbersCodePlayer.dispose();

    await okCanselTransPlayer.dispose();

    await popupDownSybMenuPlayer.dispose();

    await popupSubmenuPlayer.dispose();

    await screenChangePlayer.dispose();

    await smallKeyLightningPlayer.dispose();

    await smallKeyRegAmountAllPlayer.dispose();

    await smallKeyWeaponPlayer.dispose();

    await swipeBackPlayer.dispose();

    await swipeForwPlayer.dispose();

    await zeroAmountNumberPlayer.dispose();
  }
}
