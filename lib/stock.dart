import 'dart:convert';

StockList stockListFromJson(String str) => StockList.fromJson(json.decode(str));
String stockListToJson(StockList data) => json.encode(data.toJson());

class StockList {
  List<Stock> data;

  StockList({
    required this.data,
  });

  factory StockList.fromJson(Map<String, dynamic> json) => StockList(
        data: List<Stock>.from(json["data"].map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Stock {
  dynamic open;
  dynamic high;
  dynamic low;
  dynamic last;
  dynamic close;
  dynamic volume;
  dynamic date;
  dynamic symbol;
  dynamic exchange;

  Stock({
    required this.open,
    required this.high,
    required this.low,
    required this.last,
    required this.close,
    required this.volume,
    required this.date,
    required this.symbol,
    required this.exchange,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        open: json["open"]?.toDouble(),
        high: json["high"]?.toDouble(),
        low: json["low"]?.toDouble(),
        last: json["last"]?.toDouble(),
        close: json["close"]?.toDouble(),
        volume: json["volume"],
        date: json["date"],
        symbol: json["symbol"],
        exchange: json["exchange"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "high": high,
        "low": low,
        "last": last,
        "close": close,
        "volume": volume,
        "date": date,
        "symbol": symbol,
        "exchange": exchange,
      };
}
