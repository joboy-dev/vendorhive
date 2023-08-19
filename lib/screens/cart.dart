class Cart{
  int id = 0;
  String name = "";
  double amount = 1;
  int quantity = 1;
  String imagename = "";
  String prodid = "";
  String adminemail = "";
  double deliveryprice = 0;
  String location = "";
  Cart({required this.id,
    required this.name,
    required this.amount,
    required this.quantity,
    required this.imagename,
    required this.prodid,
    required this.adminemail,
    required this.deliveryprice,
    required this.location});
}

List<Cart> cartitems = [
  // Cart(id: 032432423, name: "Hand Fan", amount: 3500, quantity: 1, imagename: "assets/handfan.png"),
  // Cart(id: 1, name: "Hand Fan", amount: 3500, quantity: 1,imagename: "assets/handfan.png"),
  // Cart(id: 2, name: "Hand Fan", amount: 3500, quantity: 1,imagename: "assets/handfan.png"),
];