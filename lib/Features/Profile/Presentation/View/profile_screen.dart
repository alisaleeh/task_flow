import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_local_data_source.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';

import 'Widgets/profile_header.dart';
import 'Widgets/task_statistics_card.dart';
import 'Widgets/account_settings_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TaskSummaryEntity? _cachedSummary;

  @override
  void initState() {
    super.initState();
    _loadSummaryFromDisk();
  }

  Future<void> _loadSummaryFromDisk() async {
    final s = await getIt<HomeLocalDataSource>().getCachedTaskSummary();
    if (!mounted) return;
    setState(() => _cachedSummary = s);
  }

  bool _profileBodyBuildWhen(TaskState previous, TaskState current) {
    if (current is TaskSuccess) return true;
    if (current is TaskFailure) return true;
    if (current is TaskInitial) return true;
    if (current is TaskLoading && previous is TaskSuccess) return false;
    if (current is DeleteTaskSuccess ||
        current is DeleteTaskError ||
        current is UpdateTaskError) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appThemeColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.appThemeColors.textDark,
              size: 28.sp,
            ),
            onPressed: () {
              // TODO: Open bottom sheet or menu
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listenWhen: (previous, current) =>
            current is TaskSuccess && current.taskSummaryEntity != null,
        listener: (context, state) {
          final summary = (state as TaskSuccess).taskSummaryEntity;
          if (summary != null) {
            setState(() => _cachedSummary = summary);
          }
        },
        buildWhen: _profileBodyBuildWhen,
        builder: (context, state) {
          final fromCubit =
              state is TaskSuccess ? state.taskSummaryEntity : null;
          final effectiveSummary = fromCubit ?? _cachedSummary;

          return SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: AppSpacing.gapV24),
                const SliverToBoxAdapter(child: ProfileHeader()),
                SliverToBoxAdapter(child: AppSpacing.gapV32),
                SliverToBoxAdapter(
                  child: TaskStatisticsCard(summary: effectiveSummary),
                ),
                SliverToBoxAdapter(child: AppSpacing.gapV32),
                const SliverToBoxAdapter(child: AccountSettingsSection()),
                SliverToBoxAdapter(child: SizedBox(height: 120.h)),
              ],
            ),
          );
        },
      ),
    );
  }
}
