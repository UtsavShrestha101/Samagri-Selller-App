// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrderRequestProduct {
            final Timestamp requestedOn;
            final String batchId;
  final String requestUserId;
  final String requestId;
  final String productId;
            final double price;
            final int quantity;
            final String productImage;
  final bool ispicked;
  final String productName;

  MyOrderRequestProduct(
    this.requestedOn,
    this.batchId,
    this.requestUserId,
    this.requestId,
    this.productId,
    this.price,
    this.quantity,
    this.productImage,
    this.ispicked,
    this.productName,
  );

  MyOrderRequestProduct copyWith({
    Timestamp? requestedOn,
    String? batchId,
    String? requestUserId,
    String? requestId,
    String? productId,
    double? price,
    int? quantity,
    String? productImage,
    bool? ispicked,
    String? productName,
  }) {
    return MyOrderRequestProduct(
      requestedOn ?? this.requestedOn,
      batchId ?? this.batchId,
      requestUserId ?? this.requestUserId,
      requestId ?? this.requestId,
      productId ?? this.productId,
      price ?? this.price,
      quantity ?? this.quantity,
      productImage ?? this.productImage,
      ispicked ?? this.ispicked,
      productName ?? this.productName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestedOn': requestedOn,
      'batchId': batchId,
      'requestUserId': requestUserId,
      'requestId': requestId,
      'productId': productId,
      'price': price,
      'quantity': quantity,
      'productImage': productImage,
      'ispicked': ispicked,
      'productName': productName,
    };
  }

  factory MyOrderRequestProduct.fromMap(DocumentSnapshot map) {
    return MyOrderRequestProduct(
      map['requestedOn'] as Timestamp,
      map['batchId'] as String,
      map['requestUserId'] as String,
      map['requestId'] as String,
      map['productId'] as String,
      map['price'] as double,
      map['quantity'] as int,
      map['productImage'] as String,
      map['ispicked'] as bool,
      map['productName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MyOrderRequestProduct(requestedOn: $requestedOn, batchId: $batchId, requestUserId: $requestUserId, requestId: $requestId, productId: $productId, price: $price, quantity: $quantity, productImage: $productImage, ispicked: $ispicked, productName: $productName)';
  }

  @override
  bool operator ==(covariant MyOrderRequestProduct other) {
    if (identical(this, other)) return true;

    return other.requestedOn == requestedOn &&
        other.batchId == batchId &&
        other.requestUserId == requestUserId &&
        other.requestId == requestId &&
        other.productId == productId &&
        other.price == price &&
        other.quantity == quantity &&
        other.productImage == productImage &&
        other.ispicked == ispicked &&
        other.productName == productName;
  }

  @override
  int get hashCode {
    return requestedOn.hashCode ^
        batchId.hashCode ^
        requestUserId.hashCode ^
        requestId.hashCode ^
        productId.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        productImage.hashCode ^
        ispicked.hashCode ^
        productName.hashCode;
  }
}
