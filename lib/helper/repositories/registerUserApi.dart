import 'package:greenfield_seller/helper/utils/generalImports.dart';

Future<Map<String, dynamic>> getRegisterUserRepository(
    {required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiRegisterUser, params: params, isPost: true);



  return json.decode(response);
}
