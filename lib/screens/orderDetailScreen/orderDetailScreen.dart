import 'package:greenfield_seller/helper/provider/ordersProvider.dart';
import 'package:greenfield_seller/helper/utils/generalImports.dart';
import 'package:greenfield_seller/models/orderDetail.dart';
import 'package:greenfield_seller/screens/orderDetailScreen/widget/actionButtonWidget.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List lblOrderStatusDisplayNames = [];

  @override
  void initState() {
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) {
      lblOrderStatusDisplayNames = [
        getTranslatedValue(context, "order_status_display_names_awaiting"),
        getTranslatedValue(context, "order_status_display_names_received"),
        getTranslatedValue(context, "order_status_display_names_processed"),
        getTranslatedValue(context, "order_status_display_names_shipped"),
        getTranslatedValue(
            context, "order_status_display_names_out_for_delivery"),
        getTranslatedValue(context, "order_status_display_names_delivered"),
        getTranslatedValue(context, "order_status_display_names_cancelled"),
        getTranslatedValue(context, "order_status_display_names_returned"),
      ];

      context
          .read<OrderDetailProvider>()
          .getOrderDetail(context: context, orderId: widget.orderId);
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          "${getTranslatedValue(context, "title_order")} #${widget.orderId}",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Consumer<OrderDetailProvider>(
        builder: (context, orderDetailProvider, child) {
          if (orderDetailProvider.orderDetailState == OrderDetailState.loaded) {
            Order? order = orderDetailProvider.orderDetail.data?.order;
            List<OrderItems>? orderItems =
                orderDetailProvider.orderDetail.data?.orderItems;

            String customerAddress = "";
            if ((order?.customerAddress ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}" + (order?.customerAddress ?? "");
            }
            if ((order?.customerLandmark ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerLandmark ?? "");
            }
            if ((order?.customerArea ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerArea ?? "");
            }

            if ((order?.customerCity ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerCity ?? "");
            }
            if ((order?.customerState ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerState ?? "");
            }
            if ((order?.customerPincode ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerPincode ?? "");
            }
            if ((order?.customerCountry ?? "").isNotEmpty) {
              customerAddress =
                  "${customerAddress}, " + (order?.customerCountry ?? "");
            }
            return setRefreshIndicator(
              refreshCallback: () {
                return orderDetailProvider.getOrderDetail(
                    context: context, orderId: widget.orderId);
              },
              child: Padding(
                padding: EdgeInsetsDirectional.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            getTranslatedValue(context, "order_details"),
                            style: TextStyle(
                                color: ColorsRes.appColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          Widgets.getSizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(Constant.paddingOrMargin10),
                            margin: EdgeInsetsDirectional.only(
                              bottom: Constant.paddingOrMargin10,
                            ),
                            decoration: DesignConfig.boxDecoration(
                              Theme.of(context).cardColor,
                              10,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "user_name"),
                                      value: order?.userName ?? ""),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "user_email"),
                                      value: order?.userEmail ?? ""),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "user_mobile"),
                                      value: order?.mobile ?? ""),
                                  if (order!.orderNote!.isNotEmpty)
                                    Widgets.getSizedBox(
                                      height: 10,
                                    ),
                                  if (order.orderNote!.isNotEmpty)
                                    getOrderDetailContainer(
                                        title: getTranslatedValue(
                                            context, "order_note"),
                                        value: order.orderNote ?? ""),
                                ]),
                          ),
                          Text(
                            getTranslatedValue(context, "billing_details"),
                            style: TextStyle(
                                color: ColorsRes.appColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          Widgets.getSizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(Constant.paddingOrMargin10),
                            margin: EdgeInsetsDirectional.only(
                              bottom: Constant.paddingOrMargin10,
                            ),
                            decoration: DesignConfig.boxDecoration(
                              Theme.of(context).cardColor,
                              10,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getOrderDetailContainer(
                                    title: getTranslatedValue(
                                        context, "order_date"),
                                    value: GeneralMethods.formatDate(
                                      DateTime.parse(order.createdAt ??
                                          "2023-05-16T07:38:36.000000Z"),
                                    ),
                                  ),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "delivery_time"),
                                      value: order.deliveryTime ?? ""),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "address"),
                                      value: customerAddress),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                    title: getTranslatedValue(
                                        context, "delivery_charge"),
                                    value: GeneralMethods.getCurrencyFormat(
                                        double.parse(
                                            order.deliveryCharge ?? "0.0")),
                                  ),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                    title: getTranslatedValue(
                                        context, "total_items_amount"),
                                    value: GeneralMethods.getCurrencyFormat(
                                        double.parse(order.total ?? "0.0")),
                                  ),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                    title: getTranslatedValue(
                                        context, "payable_amount"),
                                    value: GeneralMethods.getCurrencyFormat(
                                        double.parse(
                                            order.finalTotal ?? "0.0")),
                                  ),
                                  Widgets.getSizedBox(
                                    height: 10,
                                  ),
                                  getOrderDetailContainer(
                                      title: getTranslatedValue(
                                          context, "payment_method"),
                                      value: order.paymentMethod ?? ""),
                                ]),
                          ),
                          Text(
                            getTranslatedValue(context, "list_of_order_items"),
                            style: TextStyle(
                                color: ColorsRes.appColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          Widgets.getSizedBox(
                            height: 10,
                          ),
                          Column(
                            children:
                                List.generate(orderItems?.length ?? 0, (index) {
                              return getOrderItemDetailsContainer(
                                  context: context,
                                  orderItem: orderItems?[index]);
                            }),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (Constant.session.isSeller())
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: DesignConfig.setRoundedBorderSpecific(
                                      20,
                                      istop: true),
                                  builder: (BuildContext context) {
                                    return ChangeNotifierProvider(
                                      create: (context) =>
                                          DeliveryBoysProvider(),
                                      child: Wrap(
                                        children: [
                                          BottomSheetDeliveryBoysContainer(
                                            orderId: order.orderId.toString(),
                                            deliveryBoyId:
                                                "${order.deliveryBoyId == null ? "0" : order.deliveryBoyId.toString()}",
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                margin: EdgeInsetsDirectional.only(end: 5),
                                padding: EdgeInsetsDirectional.all(
                                    Constant.paddingOrMargin5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border?.all(
                                      color: ColorsRes.appColor, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslatedValue(
                                                context, "delivery_boy"),
                                            style: TextStyle(
                                                color: ColorsRes.grey),
                                            softWrap: true,
                                          ),
                                          Widgets.getSizedBox(height: 2),
                                          Text(
                                            "${(order.deliveryBoyName == null || order.deliveryBoyName == "null") ? getTranslatedValue(context, "not_assign") : order.deliveryBoyName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              if(!Constant.session.isSeller())
                              Row(
                                children: [
                                  Expanded(
                                    child: ActionButtonWidget(
                                      buttonName: getTranslatedValue(
                                          context, "call_to_customer"),
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10, end: 5),
                                      voidCallback: () {
                                        launchUrlAction(
                                            "tel://${order.userMobile}");
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ActionButtonWidget(
                                      buttonName: getTranslatedValue(
                                          context, "get_customer_direction"),
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10, start: 5),
                                      voidCallback: () {
                                        launchUrlAction(
                                            "https://www.google.com/maps/dir/?api=1&destination=${order.customerLatitude},${order.customerLongitude}");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if(!Constant.session.isSeller())
                              Row(
                                children: [
                                  Expanded(
                                    child: ActionButtonWidget(
                                      buttonName: getTranslatedValue(
                                          context, "call_to_seller"),
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10, end: 5),
                                      voidCallback: () {
                                        launchUrlAction(
                                            "tel://${order.sellerMobile}");
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ActionButtonWidget(
                                      buttonName: getTranslatedValue(
                                          context, "get_seller_direction"),
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10, start: 5),
                                      voidCallback: () {
                                        launchUrlAction(
                                            "https://www.google.com/maps/dir/?api=1&destination=${order.sellerLatitude},${order.sellerLongitude}");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape:
                                        DesignConfig.setRoundedBorderSpecific(
                                            20,
                                            istop: true),
                                    builder: (BuildContext context) {
                                      return ChangeNotifierProvider(
                                        create: (context) =>
                                            OrdersProvider(),
                                        child: Wrap(
                                          children: [
                                            BottomSheetStatusContainer(
                                              orderId: order.orderId.toString(),
                                              statusId:
                                                  "${order.activeStatus ?? 0}",
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  padding: EdgeInsetsDirectional.all(
                                      Constant.paddingOrMargin5),
                                  margin: EdgeInsetsDirectional.only(
                                    start: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    border: Border?.all(
                                      color: ColorsRes.appColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslatedValue(
                                                  context, "status"),
                                              style: TextStyle(
                                                  color: ColorsRes.grey),
                                              softWrap: true,
                                            ),
                                            Widgets.getSizedBox(height: 2),
                                            Text(
                                              lblOrderStatusDisplayNames[
                                                      int.parse(
                                                          order.activeStatus ??
                                                              "0")-1]
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else if (orderDetailProvider.orderDetailState ==
              OrderDetailState.loading) {
            return ListView(
              padding: EdgeInsetsDirectional.all(10),
              children: [
                Text(
                  getTranslatedValue(context, "order_details"),
                  style: TextStyle(
                      color: ColorsRes.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                CustomShimmer(
                  height: 90,
                  width: double.maxFinite,
                  borderRadius: 10,
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                Text(
                  getTranslatedValue(context, "billing_details"),
                  style: TextStyle(
                      color: ColorsRes.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                CustomShimmer(
                  height: 220,
                  width: double.maxFinite,
                  borderRadius: 10,
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                Text(
                  getTranslatedValue(context, "list_of_order_items"),
                  style: TextStyle(
                      color: ColorsRes.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Widgets.getSizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(
                    10,
                    (index) => CustomShimmer(
                      height: 160,
                      width: double.maxFinite,
                      borderRadius: 10,
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  launchUrlAction(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      GeneralMethods.showSnackBarMsg(
          context, '${getTranslatedValue(context, "could_not_launch")} $url');
      throw '${getTranslatedValue(context, "could_not_launch")} $url';
    }
  }
}
