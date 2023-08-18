import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:convert' show jsonDecode;

import 'package:samurai_app/components/storage.dart';
import 'package:samurai_app/utils/enums.dart';

//const SERVER_IP = 'http://192.168.1.5:820'; //net
const serverIp = 'https://api.samurai-versus.io'; //work

class Rest {
  static final dio = buildDio();

  static Dio buildDio() {
    Dio dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90));
    }
    return dio;
  }

  static Future<Map<String, dynamic>> restHandler(String body) async {
    final data = jsonDecode(body) as Map<String, dynamic>;
    if (data['status'] == null || data['status'] == 1) {

      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  static void sendCode(String email) async {
    final data = await dio.post(
      '$serverIp/api/auth/login',
      data: {'email': email},
      options: Options(
        headers: {
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> checkCode(String email, String code) async {
    final data = await dio.post(
      '$serverIp/api/auth/verify',
      data: {'email': email, 'time_code': code},
      options: Options(
        headers: {
          'Content-Type': "application/json",
        },
      ),
    );
    return data.data;
  }

  static Future<void> updateWalletAddress(String walletAddress) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/update/wallet',
      data: {'wallet_address': walletAddress},
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>?> getUser() async {
    String? jwt = AppStorage().read('jwt');
    if (kDebugMode) {
      print(jwt);
    }
    try {
      final data = await dio.get(
        '$serverIp/api/users/self',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': "application/json",
          },
        ),
      );
      return data.data;
    } catch (e) {
      if (kDebugMode) {
        print('/api/users/self');
        print(e);
      }
      return null;
    }
  }

  static Future<bool> sendTFACode(String email) async {
    String? jwt = AppStorage().read('jwt');
    try {
      final data = await dio.post(
        '$serverIp/api/auth/sendTFACode',
        data: {"email": email},
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': "application/json",
          },
        ),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('/api/auth/sendTFACode');
        print(e);
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>> check2faCode(String tfacode) async {
    String? jwt = AppStorage().read('jwt');
    final data = await dio.get(
      '$serverIp/api/users/self',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'tfa-code': tfacode,
          'Content-Type': "application/json",
        },
      ),
    );
    return data.data;
  }

  //token FIRE_SAMURAI_BSC|WATER_SAMURAI_BSC или FIRE_SAMURAI_GENESIS_BSC|WATER_SAMURAI_GENESIS_BSC
  static Future<void> transfer(int chain, double amount, String token, String toAddress) async {
    String? jwt = AppStorage().read('jwt');
    String? tfacode = AppStorage().read('tfacode');

    final data = await dio.post(
      '$serverIp/api/web3/transfer',
      data: {
        'chain': chain,
        'amount': amount,
        'token': token,
        'toAddress': toAddress,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'tfa-code': tfacode,
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> getInfoSamurai() async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.get(
      '$serverIp/api/users/samurai/info',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    if (kDebugMode) {
      print('/api/users/samurai/info');
    }
    return data.data;
  }

  static Future<Map<String, dynamic>> getInfoHero() async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.get(
      '$serverIp/api/users/hero/info',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    if (kDebugMode) {
      print('/api/users/hero/info');
    }
    return data.data;
  }

  //TOKEN_TYPE "FIRE_SAMURAI_MATIC" или "WATER_SAMURAI_MATIC"
  static Future<void> transferSamuraiToFree(int amount, String tokenType) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/samurai/$tokenType/transfer/free',
      data: {
        'amount': amount,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  //TOKEN_TYPE "FIRE_SAMURAI_MATIC" или "WATER_SAMURAI_MATIC"
  static Future<void> transferSamuraiToArmy(int amount, String tokenType) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/samurai/$tokenType/transfer/army',
      data: {
        'health': 100,
        'amount': amount,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static void changeEmail(String email) async {
    String? jwt = AppStorage().read('jwt');

    final data = await dio.post(
      '$serverIp/api/users/update/email/send',
      data: {'newEmail': email},
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
  }

  static Future<bool?> checkNewEmailCode(String email, String code, String newcode) async {
    String? jwt = AppStorage().read('jwt');
    final data = await dio.post(
      '$serverIp/api/users/update/email/verify',
      data: {'newEmail': email, 'authCodeNewEmail': int.parse(newcode), 'authCodeOldEmail': int.parse(code)},
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    return true;
  }

  static Future<Map<String, dynamic>?> sendClameSamurai(String type) async {
    String? jwt = AppStorage().read('jwt');
    if (kDebugMode) {
      print('/api/users/samurai/bank/xp/claim/$type');
    }

    try {
      final data = await dio.post(
        '$serverIp/api/users/samurai/bank/xp/claim/$type',
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': "application/json",
          },
        ),
      );
      return data.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        //print(e.response?.headers);
        //print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.requestOptions);
        print(e.message);
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> sendClameHero(String type) async {
    String? jwt = AppStorage().read('jwt');
    try {
      final data = await dio.post(
        '$serverIp/api/users/hero/bank/dp/claim/$type/HATAMOTO',
        data: {},
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': "application/json",
          },
        ),
      );
      return data.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        //print(e.response?.headers);
        //print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.requestOptions);
        print(e.message);
      }
    }
    return null;
  }

  static Future<bool?> checkUpdateUserUseTfa(bool tfa) async {
    String? jwt = AppStorage().read('jwt');
    final data = await dio.post(
      '$serverIp/api/users/update',
      data: {'tfa': tfa},
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': "application/json",
        },
      ),
    );
    return true;
  }

  static Future<Map<String, dynamic>?> sendMintSamurai(int amount, String type) async {
    String? jwt = AppStorage().read('jwt');
    try {
      final data = await dio.post(
        '$serverIp/api/users/samurai/mint',
        data: {'samurai_type': type, 'amount': amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': "application/json",
          },
        ),
      );
      return data.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        //print(e.response?.headers);
        //print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.requestOptions);
        print(e.message);
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>> mintUserHero(String heroType, String samuraiType) async {
    // add user hero method

    String URL = "$serverIp/api/users/hero/mint";
    final String? jwtToken = AppStorage().read('jwt');

    Map<String, dynamic> reqHeader = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': "application/json",
    };

    Map<String, dynamic> reqBody = {
      'hero_type': heroType,
      'class_type': samuraiType,
    };

    try {
      final response = await dio.post(URL, data: reqBody, options: Options(headers: reqHeader));
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw (response.statusMessage.toString());
    } catch (ex) {
      print(ex);
      throw (ex);
    }
  }

  static Future<Map<String, dynamic>> placeHeroToStake(int heroId) async {
    // replace hero to a stake state

    String URL = "$serverIp/api/users/hero/transfer/staking";
    final jwtToken = AppStorage().read('jwt');

    Map<String, dynamic> reqHeader = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': "application/json",
    };

    Map<String, dynamic> reqBody = {'heroId': heroId};

    try {
      final response = await dio.post(URL, data: reqBody, options: Options(headers: reqHeader));

      if (response.statusCode == 200) {
        return response.data;
      }

      throw response.statusMessage.toString();
    } catch (ex) {
      throw ex;
    }
  }


  static Future<Map<String, dynamic>> removeHeroFromStake(int heroId) async {
    // removes hero from a stake state

    String URL = "$serverIp/api/users/hero/transfer/free";
    final jwtToken = AppStorage().read('jwt');

    Map<String, dynamic> reqHeader = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': "application/json",
    };

    Map<String, dynamic> reqBody = {'heroId': heroId};

    try {
      final response = await dio.post(URL, data: reqBody, options: Options(headers: reqHeader));

      if (response.statusCode == 200) {
        return response.data;
      }

      throw response.statusMessage.toString();
    } catch (ex) {
      throw ex;
    }
  }
}

/**
 *
 * На текущий момент сделаны и обновлены следующие маршруты API:
    --------------------------------------------------------------
    Request: POST /api/users/samurai/:samurai_type/transfer/army
    Example: POST /api/users/samurai/FIRE_SAMURAI_MATIC/transfer/army
    Body: {
    "amount": <Количество самураев, которое мы отправляем в армию>,
    "health": <Рандомное значение, оно является заглушкой, число от 50 до 100>
    }
    Response: {
    "unlockTime": "2023-06-07T23:15:51.235Z" - время по гринвичу GMT +0, когда будет доступен CLAIM XP,
    "summaryHealth": 50 - ненужное значение является заглушкой,
    "summaryLocked": 100 - сколько было залочено самураев всего
    }
    --------------------------------------------------------------
    Request: POST /api/users/samurai/:samurai_type/transfer/free
    Example: POST /api/users/samurai/FIRE_SAMURAI_MATIC/transfer/free
    Body: {
    "amount": 100
    }
    Response: ничего не возвращает, если 200, иначе вернет ошибку
    --------------------------------------------------------------

    Request: GET /api/users/samurai/info
    Example: GET /api/users/samurai/info
    Body: -
    Response: {
    "id": 1,
    "fire_samurai_balance": 100,
    "fire_samurai_xp": 39.4,
    "fire_samurai_unclaimed_xp": 0,
    "fire_samurai_unclaimed_xp_locked_date": "2023-06-08T20:59:00.000Z",
    "fire_samurai_unclaimed_xp_expires_date": "1970-01-20T12:21:28.575Z",
    "locked_fire_samurai_balance": 0,
    "fire_samurai_unlock_date": "2023-06-07T22:45:24.806Z",
    "water_samurai_balance": 0,
    "locked_water_samurai_balance": 0,
    "water_samurai_unlock_date": "2023-05-12T17:36:29.924Z",
    "water_samurai_xp": 0,
    "water_samurai_unclaimed_xp": 0,
    "water_samurai_unclaimed_xp_locked_date": "2023-06-07T14:59:17.000Z",
    "water_samurai_unclaimed_xp_expires_date": "2023-06-07T14:59:17.000Z",
    "userId": 1,
    "createdAt": "2023-05-12T17:36:29.924Z",
    "updatedAt": "2023-06-07T22:45:24.807Z"
    }, если 200, иначе вернет ошибку
    --------------------------------------------------------------
    Request: POST /api/users/samurai/bank/xp/claim/:samurai_type
    Example: POST /api/users/samurai/bank/xp/claim/FIRE_SAMURAI_MATIC
    Body: -
    Response: {
    "fire_samurai_xp": 59.4,
    "fire_samurai_unclaimed_xp": 0
    }, если 200, иначе вернет ошибку


    /api/users/hero/bank/dp/claim/FIRE_HERO_MATIC/HATAMOTO

    api/users/hero/info

    api/users/hero/FIRE_HERO_MATIC/HATAMOTO/transfer/free

    api/users/hero/FIRE_HERO_MATIC/HATAMOTO/transfer/staking
 */
