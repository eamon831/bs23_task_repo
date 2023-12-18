import 'package:bs23_task/api_provider/api_provider.dart';
import 'package:bs23_task/database/database_helper.dart';
import 'package:bs23_task/model/repository.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';


class RepositoryListController extends GetxController{
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  var repositoryList=<Repository>[].obs;

  @override
  void onInit() {
    getRepositoryList();

  }

  Future<void> getRepositoryList() async {
    toast("hello");
    await ApiProvider().fetchRepositoryList(query: "Flutter").then((value) async {
      if (value!=null && value){
        await databaseHelper.getAll(DatabaseHelper.table_repository).then((value) {
          repositoryList.value=value.map((e) => Repository.fromJson(e)).toList();
          update();
          notifyChildrens();
          repositoryList.refresh();
        });
      }
    });
  }



}