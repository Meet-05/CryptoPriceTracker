import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  //old api 407D58D3-7C59-40F4-B7BF-BA56FBE5BF84
  String apikey = DotEnv().env['API_KEY'];
  String baseUrl = 'https://rest.coinapi.io/v1/exchangerate';
  var resultData = {};
  Future<dynamic> getCoinData(String currency) async {
    for (String crypto in cryptoList) {
      http.Response response =
          await http.get('$baseUrl/$crypto/$currency?apikey=$apikey');
      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);
        resultData[crypto] = data['rate'].toStringAsFixed(0);
      } else {
        print('invalid uri');
      }
    }
    print(resultData);
    return resultData;

    // http.Response response =
    //     await http.get('$baseUrl/BTC/$currency?apikey=$apikey');
    // if (response.statusCode == 200) {
    //   var data = convert.jsonDecode(response.body);
    //   return data['rate'];
    // }
  }
}
