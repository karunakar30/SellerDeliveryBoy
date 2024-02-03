import 'package:greenfield_seller/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getDeliveryBoysRepository(
    {required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiDeliveryBoys, params: params, isPost: false);

  return json.decode(response);
}
