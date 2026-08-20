import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_card_container_empty.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:flutter/material.dart";

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final List<
    ({
      String studentName,
      String classroom,
      double averageGrade,
    })
  >
  _students = [
    (
      studentName: "أحمد محمد علي",
      classroom: "الثالث ث - أ",
      averageGrade: 87,
    ),
    (
      studentName: "فاطمة إبراهيم",
      classroom: "الثالث ث - أ",
      averageGrade: 92,
    ),
    (
      studentName: "محمد السيد",
      classroom: "الثالث ث - ب",
      averageGrade: 61,
    ),
    (
      studentName: "ريم عادل",
      classroom: "الثالث ث - أ",
      averageGrade: 78,
    ),
    (
      studentName: "عمر خالد",
      classroom: "الثالث ث - ب",
      averageGrade: 45,
    ),
  ];

  late List<
    ({
      String studentName,
      String classroom,
      double averageGrade,
    })
  >
  _filteredStudents;

  late final TextEditingController _textEditingControllerSearch;

  @override
  void initState() {
    super.initState();
    _textEditingControllerSearch = TextEditingController();
    _filteredStudents = List.from(_students);
    _textEditingControllerSearch.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _textEditingControllerSearch.removeListener(_filterStudents);
    _textEditingControllerSearch.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final String query = _textEditingControllerSearch.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_students);
      } else {
        _filteredStudents = _students.where((student) {
          return student.studentName.toLowerCase().contains(query) ||
              student.classroom.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "ادارة الطلاب",
      ),
      drawer: AppDrawer(
        drawerItemsList: getTeacherDrawerItemsList(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            spacing: AppSizes.s20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "قائمة الطلاب",
                style: context.textTheme.headlineMedium,
              ),
              AppCardContainerEmpty(
                children: [
                  AppTextFormField(
                    controller: _textEditingControllerSearch,
                    hintText: "بحث باسم الطالب او الفصل الدراسى",
                    prefixIcon: Icons.search,
                  ),
                ],
              ),
              AppCardContainerEmpty(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "الطالب",
                          style: context.textTheme.labelLarge,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          "الفصل الدراسى",
                          style: context.textTheme.labelLarge,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          "متوسط الدرجات",
                          style: context.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _filteredStudents.isEmpty
                  ? Text(
                      "لا يوجد طلاب مطابقون للبحث",
                      style: context.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];

                        return AppCardContainerEmpty(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(student.studentName),
                                Text(student.classroom),
                                Text("${student.averageGrade.toInt()}%"),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: AppSizes.s8,
                        );
                      },
                      itemCount: _filteredStudents.length,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
