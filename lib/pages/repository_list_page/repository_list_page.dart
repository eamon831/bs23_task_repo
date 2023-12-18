import 'package:bs23_task/pages/repository_details_page/repository_details_page.dart';
import 'package:bs23_task/pages/repository_list_page/repository_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class RepositoryListPage extends StatelessWidget {
  const RepositoryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepositoryListController mvc = Get.put(RepositoryListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repository List Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await mvc.getRepositoryList();
                },
                child: Text("Fetch Repository List")),
            Obx(() => Text(mvc.repositoryList.length.toString())),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: mvc.repositoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(()=>RepositoryDetailsPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mvc.repositoryList[index].name ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,fontSize: 18),),
                            5.height,
                            Text(mvc.repositoryList[index].description ?? ""),
                          ],

                        ),
                      ),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }
}
