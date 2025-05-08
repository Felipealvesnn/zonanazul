class RetornoPagamentoCartao {
  dynamic paymentId;
  dynamic sellerId;
  int? amount;
  dynamic currency;
  dynamic orderId;
  dynamic status;
  String? receivedAt;
  dynamic credito;
  String? message;
  dynamic name;
  int? statusCode;
  dynamic details;
  dynamic errorCode;
  dynamic brand;

  RetornoPagamentoCartao(
      {this.paymentId,
      this.sellerId,
      this.amount,
      this.currency,
      this.orderId,
      this.status,
      this.receivedAt,
      this.credito,
      this.message,
      this.name,
      this.statusCode,
      this.details,
      this.errorCode,
      this.brand});

  RetornoPagamentoCartao.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    sellerId = json['seller_id'];
    amount = json['amount'];
    currency = json['currency'];
    orderId = json['order_id'];
    status = json['status'];
    receivedAt = json['received_at'];
    credito = json['credito'];
    message = json['message'];
    name = json['name'];
    statusCode = json['status_code'];
    details = json['details'];
    errorCode = json['error_code'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['seller_id'] = sellerId;
    data['amount'] = amount;
    data['currency'] = currency;
    data['order_id'] = orderId;
    data['status'] = status;
    data['received_at'] = receivedAt;
    data['credito'] = credito;
    data['message'] = message;
    data['name'] = name;
    data['status_code'] = statusCode;
    data['details'] = details;
    data['error_code'] = errorCode;
    data['brand'] = brand;
    return data;
  }
}
