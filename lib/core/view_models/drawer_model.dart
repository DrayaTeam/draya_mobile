import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/view_models/drawer_item_view_model.dart";
import "package:flutter/material.dart";

class DrawerModel {
  final String title;
  final List<DrawerItemViewModel> items;

  DrawerModel({
    required this.title,
    required this.items,
  });
}

List<DrawerModel> getTeacherDrawerItemsList() {
  return [
    DrawerModel(
      title: "التدريس",
      items: [
        DrawerItemViewModel(
          icon: Icons.dashboard_outlined,
          title: "لوحة التحكم",
          route: AppRoutes.teacherDashboardPage,
        ),
        // DrawerItemViewModel(
        //   icon: Icons.school_outlined,
        //   title: "باقات",
        // ),
        // DrawerItemViewModel(
        //   title: "المواد الدراسية",
        //   icon: Icons.book_outlined,
        //   route: AppRoutes.subjectsPage,
        // ),
        DrawerItemViewModel(
          icon: Icons.menu_book_outlined,
          title: "الفصول",
          route: AppRoutes.classroomsPage,
        ),
      ],
    ),
    DrawerModel(
      title: "التقييم",
      items: [
        // DrawerItemViewModel(
        //   icon: Icons.people_outlined,
        //   title: "الطلبة",
        //   route: AppRoutes.studentsListPage,
        // ),
        DrawerItemViewModel(
          icon: Icons.assignment_outlined,
          title: "الامتحانات",
          route: AppRoutes.teacherExamsPage,
        ),
      ],
    ),
    DrawerModel(
      title: "التواصل",
      items: [
        // DrawerItemViewModel(
        //   icon: Icons.tv_outlined,
        //   title: "القناة",
        // ),
        DrawerItemViewModel(icon: Icons.chat_outlined, title: "التقييمات"),
      ],
    ),
    DrawerModel(
      title: "التحليل",
      items: [
        DrawerItemViewModel(
          icon: Icons.bar_chart_outlined,
          title: "التحليلات",
        ),
        DrawerItemViewModel(icon: Icons.list_alt_outlined, title: "التقارير"),
        DrawerItemViewModel(
          title: "عن حسابى",
          icon: Icons.person_outline,
          route: AppRoutes.teacherProfilePage,
        ),
      ],
    ),
  ];
}

List<DrawerModel> getStudentDrawerItemsList() {
  return [
    DrawerModel(
      title: "التدريس",
      items: [
        DrawerItemViewModel(
          icon: Icons.dashboard_outlined,
          title: "الرئيسية",
          route: AppRoutes.studentHomePage,
        ),
        DrawerItemViewModel(
          icon: Icons.school_outlined,
          title: "فصولى",
          route: AppRoutes.studentEnrolledClassroomsPage,
        ),
        DrawerItemViewModel(
          icon: Icons.people_outlined,
          title: "المعلمون",
          route: AppRoutes.browseTeachersPage,
        ),
        DrawerItemViewModel(
          icon: Icons.menu_book_outlined,
          title: "تفاصيل المحاضرات",
          route: AppRoutes.studentClassroomsMaterialsPage,
        ),
        // DrawerItemViewModel(
        //   icon: Icons.book_outlined,
        //   title: "الكتب",
        // ),
      ],
    ),
    DrawerModel(
      title: "التقييم",
      items: [
        DrawerItemViewModel(
          icon: Icons.auto_awesome_outlined,
          title: "نقاط الضعف والمراجعة",
          route: AppRoutes.studentWeakTopicsPage,
        ),
        // DrawerItemViewModel(
        //   icon: Icons.grading_outlined,
        //   title: "درجاتى",
        // ),
        DrawerItemViewModel(
          icon: Icons.assignment_outlined,
          title: "الامتحانات",
          route: AppRoutes.studentExamsPage,
        ),
      ],
    ),
    DrawerModel(
      title: "التواصل",
      items: [
        // DrawerItemViewModel(
        //   icon: Icons.tv_outlined,
        //   title: "القناة الرئيسية",
        // ),
        DrawerItemViewModel(
          title: "عن حسابى",
          icon: Icons.person_outline,
          route: AppRoutes.studentProfilePage,
        ),
      ],
    ),
  ];
}
