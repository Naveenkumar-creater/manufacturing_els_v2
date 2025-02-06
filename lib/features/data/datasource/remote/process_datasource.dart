// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prominous/features/data/model/process_model.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../core/process_client.dart';

abstract class ProcessDatasource {
  Future<ProcessModel> getProcessList(String token,int deptid, int orgid);
}

class ProcessDatasourceImpl implements ProcessDatasource {
  ProcessClient processClient;
  ProcessDatasourceImpl(
    this.processClient,
  );
  @override
  Future<ProcessModel> getProcessList(String token,int deptid, int orgid) async {


    final response = await processClient.getProcessList(token,deptid, orgid);

    final result = ProcessModel.fromJson(response);

    return result;
    
  }
}
