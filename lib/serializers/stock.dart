class Stock {
  final String quantity;
  final String infusions;
  final double percentageUsed;

  Stock(this.infusions, this.percentageUsed, this.quantity);

  Stock.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        infusions = json['infusions'],
        percentageUsed = json['percentageUsed'];

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'infusions': infusions,
        'percentageUsed': percentageUsed
      };
}
