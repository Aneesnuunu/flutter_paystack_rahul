import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutter/src/model/charge.dart';
import 'package:paystack_flutter/src/paystack.dart';
import 'package:paystack_flutter/src/utils/string_utils.dart';
import 'package:paystack_flutter/src/utils/utils.dart';

export 'package:paystack_flutter/src/model/card.dart';
export 'package:paystack_flutter/src/paystack.dart' hide Paystack;
export 'package:paystack_flutter/src/model/charge.dart';

class PaystackSdk {
  static bool _sdkInitialized;
  static String _publicKey;

  static _initialize(String publicKey, OnSdkInitialized onSdkInitialized) {
    //do all the init work here

    //check if initialize callback is set and sdk is actually intialized
    if (onSdkInitialized != null && sdkInitialized) {
      onSdkInitialized();
      return;
    }

    _publicKey = publicKey;
    _sdkInitialized = true;
    if (onSdkInitialized != null) {
      onSdkInitialized();
    }
  }

  PaystackSdk.initialize(
      {@required String publicKey, OnSdkInitialized onSdkInitialized}) {
    assert(
    publicKey != null && publicKey.isNotEmpty,
    'publicKey cannot be null or empty');
    _initialize(publicKey, onSdkInitialized);
  }

  static bool get sdkInitialized => _sdkInitialized;

  static String get publicKey {
    // Validate that the sdk has been initialized
    Utils.validateSdkInitialized();
    return _publicKey;
  }


  static void _performChecks() {
    //validate that sdk has been initialized
    Utils.validateSdkInitialized();

    //validate public keys
    Utils.hasPublicKey();
  }

  static chargeCard(BuildContext context, {Charge charge,
    TransactionCallback transactionCallback}) {
    assert(context != null, 'context must not be null');

    _performChecks();

    // Construct new paystack object
    Paystack paystack = Paystack.withPublicKey(publicKey);

    // Create token
    paystack.chargeCard(context, charge, transactionCallback);
  }

  static Future<String> get platformVersion async {
    final String version =
    await Utils.channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

/// Callback for when the SDK has been initialized
typedef void OnSdkInitialized();
