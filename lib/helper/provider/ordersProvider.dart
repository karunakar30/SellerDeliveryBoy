import 'package:greenfield_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';

enum OrdersDetailState {
  initial,
  loading,
  loaded,
  error,
}

enum OrdersState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

enum OrderUpdateStatusState {
  initial,
  loading,
  updating,
  loaded,
  error,
}

enum DeliveryBoysState {
  initial,
  loading,
  loaded,
  updating,
  loadingMore,
  error,
}

class OrdersProvider extends ChangeNotifier {
  String message = '';
  OrdersState ordersState = OrdersState.initial;

  late SellerOrder sellerOrderData;
  List<SellerOrdersListItem> sellerOrdersList = [];

  late DeliveryBoyOrder deliveryBoyOrderData;
  List<DeliveryBoyOrdersListItem> deliveryBoyOrdersList = [];

  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedStatus = 0;

  getOrders({
    required String statusIndex,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      ordersState = OrdersState.loading;
      notifyListeners();
    } else {
      ordersState = OrdersState.loadingMore;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      params[ApiAndParams.status] = statusIndex;
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getOrdersRepository(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        if (Constant.session.isSeller() == true) {
          sellerOrderData = SellerOrder.fromJson(getData);
          totalData = getData[ApiAndParams.total];
          List<SellerOrdersListItem> tempOrders =
              sellerOrderData.data?.orders ?? [];

          sellerOrdersList.addAll(tempOrders);

          hasMoreData = totalData > sellerOrdersList.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
        } else {
          deliveryBoyOrderData = DeliveryBoyOrder.fromJson(getData);
          totalData = getData[ApiAndParams.total];
          List<DeliveryBoyOrdersListItem> tempOrders =
              deliveryBoyOrderData.data?.orders ?? [];

          deliveryBoyOrdersList.addAll(tempOrders);

          hasMoreData = totalData > deliveryBoyOrdersList.length;
          if (hasMoreData) {
            offset += Constant.defaultDataLoadLimitAtOnce;
          }
        }
      }

      ordersState = OrdersState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      ordersState = OrdersState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  Future orderListingDataUpdate(
      {required String index,
      String? activeStatus,
      String? deliveryBoyId,
      String? deliveryBoyName}) async {
    if (activeStatus != null) {
      sellerOrdersList[int.parse(index)].copyWith(activeStatus: activeStatus);
    } else if (deliveryBoyId != null && deliveryBoyName != null) {
      sellerOrdersList[int.parse(index)].copyWith(
          newDeliveryBoyId: deliveryBoyId, newDeliveryBoyName: deliveryBoyName);
    }
    notifyListeners();
  }

  Future<bool> changeOrderSelectedStatus(int index) async {
    if (selectedStatus.toString() != index.toString()) {
      selectedStatus = index;
      notifyListeners();
      offset = 0;
      sellerOrdersList = [];
      deliveryBoyOrdersList = [];
      return true;
    } else {
      return false;
    }
  }

  OrderUpdateStatusState ordersStatusState = OrderUpdateStatusState.initial;
  late OrderStatuses orderStatuses;
  List<OrderStatusesData> orderStatusesList = [];
  String selectedOrderStatus = "0";

  Future getOrdersStatuses({
    required BuildContext context,
  }) async {
    try {
      ordersStatusState = OrderUpdateStatusState.loading;
      notifyListeners();

      Map<String, dynamic> getStatusData =
          (await getOrderStatusesRepository(context: context));

      if (getStatusData[ApiAndParams.status].toString() == "1") {
        orderStatuses = OrderStatuses.fromJson(getStatusData);
        orderStatusesList = orderStatuses.data ?? [];
        ordersStatusState = OrderUpdateStatusState.loaded;
        notifyListeners();
      } else {
        ordersStatusState = OrderUpdateStatusState.loaded;
        GeneralMethods.showSnackBarMsg(
            context, getStatusData[ApiAndParams.message]);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ordersStatusState = OrderUpdateStatusState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  Future updateOrdersStatus({
    required Map<String, String> params,
    required BuildContext context,
    SellerOrdersListItem? order,
  }) async {
    try {
      ordersStatusState = OrderUpdateStatusState.updating;
      notifyListeners();

      Map<String, dynamic> getUpdatedOrderData =
          await updateOrderStatusRepository(params: params);

      if (getUpdatedOrderData[ApiAndParams.status].toString() == "1") {
        order?.copyWith(activeStatus: params[ApiAndParams.statusId]);
        ordersStatusState = OrderUpdateStatusState.loaded;
        notifyListeners();
      } else {
        ordersStatusState = OrderUpdateStatusState.error;
        GeneralMethods.showSnackBarMsg(
            context, getUpdatedOrderData[ApiAndParams.message]);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      ordersStatusState = OrderUpdateStatusState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  setSelectedStatus(String index) {
    selectedOrderStatus = (int.parse(index) + 1).toString();
    notifyListeners();
  }

  DeliveryBoysState deliveryBoysState = DeliveryBoysState.initial;
  late DeliveryBoys deliveryBoys;
  List<DeliveryBoysData> deliveryBoysList = [];
  bool hasMoreDataDeliveryBoy = false;
  int totalDataDeliveryBoy = 0;
  int offsetDeliveryBoy = 0;
  String selectedDeliveryBoy = "0";

  getDeliveryBoys({
    required int selectedDeliveryBoyIndex,
    required BuildContext context,
  }) async {
    if (offset == 0) {
      deliveryBoysState = DeliveryBoysState.loading;
      notifyListeners();
    } else {
      deliveryBoysState = DeliveryBoysState.loadingMore;
      notifyListeners();
    }

    try {
      Map<String, String> params = {};
      selectedDeliveryBoy = selectedDeliveryBoyIndex.toString();
      params[ApiAndParams.limit] =
          Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      Map<String, dynamic> getData =
          (await getDeliveryBoysRepository(params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        deliveryBoys = DeliveryBoys.fromJson(getData);
        totalData = getData[ApiAndParams.total];
        List<DeliveryBoysData> tempDeliveryBoys = deliveryBoys.data ?? [];

        deliveryBoysList.addAll(tempDeliveryBoys);
      }

      hasMoreData = totalData > deliveryBoysList.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }

      deliveryBoysState = DeliveryBoysState.loaded;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      deliveryBoysState = DeliveryBoysState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  Future updateOrdersDeliveryBoy({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    try {
      deliveryBoysState = DeliveryBoysState.updating;
      notifyListeners();

      Map<String, dynamic> getUpdatedOrderData =
          await updateOrdersDeliveryBoyRepository(params: params);
      if (getUpdatedOrderData[ApiAndParams.status].toString() == "1") {
        deliveryBoysState = DeliveryBoysState.loaded;
        notifyListeners();
        return true;
      } else {
        deliveryBoysState = DeliveryBoysState.error;
        GeneralMethods.showSnackBarMsg(
            context, getUpdatedOrderData[ApiAndParams.message]);
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      deliveryBoysState = DeliveryBoysState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return false;
    }
  }

  Future setSelectedIndex(String index) async {
    selectedDeliveryBoy = index;
    notifyListeners();
  }
}
