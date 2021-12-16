import 'package:flutter/cupertino.dart';

class DebitCardSave {
  int cardId;
  String cardName, cardNumber, cardExpiryMonth, cardExpiryYear, cardCvv;

  DebitCardSave(
      {this.cardId,
      @required this.cardName,
      @required this.cardNumber,
      @required this.cardExpiryMonth,
      @required this.cardExpiryYear,
      @required this.cardCvv});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["card_name"] = cardName;
    map["card_number"] = cardNumber;
    map["card_expirymon"] = cardExpiryMonth;
    map["card_expiryyear"] = cardExpiryYear;
    map["card_cvv"] = cardCvv;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["card_id"] = cardId;
    map["card_name"] = cardName;
    map["card_number"] = cardNumber;
    map["card_expirymon"] = cardExpiryMonth;
    map["card_expiryyear"] = cardExpiryYear;
    map["card_cvv"] = cardCvv;
    return map;
  }

  //to be used when converting the row into object
  factory DebitCardSave.fromMap(Map<String, dynamic> data) => new DebitCardSave(
      cardId: data['card_id'],
      cardName: data['card_name'],
      cardNumber: data['card_number'],
      cardExpiryMonth: data['card_expirymon'],
      cardExpiryYear: data['card_expiryyear'],
      cardCvv: data['card_cvv']);
}
