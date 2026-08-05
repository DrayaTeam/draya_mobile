import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:draya_mobile/core/widgets/app_card_container_info.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_list_tile_info.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherDashboardScreen extends StatelessWidget {
  TeacherDashboardScreen({super.key});

  final currentDate = DateTime.now();
  final String teacherName = "احمد";
  final int studentsCount = 142;
  final int pendingExamCount = 4;
  final int newMessages = 7;
  final List<(String, String, double)> studentsNeedHelp = [
    ("ياسمين خالد", "الجبر والهندسة", 38),
    ("عمر السيد", "الفيزياء الحديثة", 44),
    ("نور محمود", "الكيمياء العضوية", 51),
    ("كريم عبدالله", "الجبر والهندسة", 53),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "لوحة التحكم"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(DateFormat.yMMMMEEEEd("ar").format(currentDate)),
              Text(
                "مساء الخير أ. " + teacherName,
                style: context.textTheme.displaySmall,
              ),
              const Text("اليك ملخص نشاط اكاديميتك اليوم"),
              const SizedBox(height: AppSizes.s8),
              const Divider(),
              const SizedBox(height: AppSizes.s8),
              AppCardContainerInfo(
                icon: Icons.people_outline,
                title: studentsCount.toString(),
                subtitle: "طلاب نشطون",
              ),
              const SizedBox(height: AppSizes.s20),
              AppCardContainerInfo(
                icon: Icons.calendar_month_outlined,
                title: pendingExamCount.toString(),
                subtitle: "امتحانات بانتظار مراجعة",
              ),
              const SizedBox(height: AppSizes.s20),
              AppCardContainerInfo(
                icon: Icons.chat_bubble_outline,
                title: newMessages.toString(),
                subtitle: "رسائل جديدة",
              ),
              const SizedBox(height: AppSizes.s20),
              const Divider(),
              const SizedBox(height: AppSizes.s20),
              AppCardContainerEmpty(
                children: [
                  AppListTileInfo(
                    title: "انشاء امتحان",
                    icon: Icons.create_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSizes.s20),
                  AppListTileInfo(
                    title: "متابعة الطلبة",
                    icon: Icons.people_outline,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSizes.s20),
                  AppListTileInfo(
                    title: "التقارير",
                    icon: Icons.edit_document,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.s20),
              Container(
                padding: const EdgeInsets.all(AppSizes.s20),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppSizes.s20),
                  border: Border.all(
                    color: AppColors.primary200,
                    width: AppSizes.s1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "طلاب يحتاجون متابعة",
                              style: context.textTheme.labelLarge,
                            ),
                            const Text("اداء دون 55% فى اخر امتحان"),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: const Text("الكل"),
                          icon: const Icon(Icons.keyboard_arrow_left_rounded),
                          iconAlignment: IconAlignment.end,
                        ),
                      ],
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("الطالب"),
                        Text("الكورس"),
                        Text("الدرجة"),
                      ],
                    ),
                    ...studentsNeedHelp.map(
                      (student) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.s8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(student.$1),
                            Text(student.$2),
                            Text("${student.$3.toInt()}%"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
