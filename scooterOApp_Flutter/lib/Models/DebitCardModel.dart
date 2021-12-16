
class DebitCard {
  int id;
  String name;
  String cvv;
  String cardno;
  String expirydate;
  DebitCard(this.id, this.name, this.cvv,this.cardno, this.expirydate);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'cvv': cvv,
      'name': cardno,
      'expirydate': expirydate,
    };
    return map;
  }

  DebitCard.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    cvv = map['cvv'];
    cardno = map['cardno'];
    expirydate = map['expirydate'];
  }
}