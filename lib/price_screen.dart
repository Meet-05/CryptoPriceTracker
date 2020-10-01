import 'package:flutter/material.dart';
import 'package:CryptoPriceTracker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = 'AUD';
  CoinData coin = CoinData();
  String rate = '?';
  var coinValue = {};
  String btcPrice;
  String ethPrice;
  String ltcPrice;
  bool isWaiting = false;

  void getCoinDataa(String currency) async {
    try {
      isWaiting = true;
      var data = await coin.getCoinData(currency);
      // dynamic result = await coin.getCoinData(currency);
      isWaiting = false;
      setState(() {
        coinValue = data;
        // rate = result['rate'].toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int x = 0; x < currenciesList.length; x++) {
      items.add(DropdownMenuItem(
          child: Text(currenciesList[x]), value: currenciesList[x]));
    }
    return DropdownButton<String>(
        value: currency,
        items: items,
        onChanged: (val) {
          setState(() {
            currency = val;
            getCoinDataa(currency);
          });
        });
  }

  CupertinoPicker iosDropDown() {
    List<Widget> items = [];
    for (String item in currenciesList) {
      items.add(Text((item)));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (valueIndex) {
        setState(() {
          currency = currenciesList[valueIndex];
          getCoinDataa(currency);
        });
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();
    getCoinDataa(currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
              rate: isWaiting ? '?' : coinValue['BTC'],
              currency: currency,
              bitCoin: 'BTC'),
          CryptoCard(
              rate: isWaiting ? '?' : coinValue['ETH'],
              currency: currency,
              bitCoin: 'ETH'),
          CryptoCard(
              rate: isWaiting ? '?' : coinValue['LTC'],
              currency: currency,
              bitCoin: 'LTC'),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            //based on the plaform we draw diffient drop down
            child: iosDropDown(), //Platform.isIOS ?  androidDropDown():
          )
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({
    @required this.bitCoin,
    @required this.rate,
    @required this.currency,
  });

  final String bitCoin;
  final String rate;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $bitCoin = $rate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
