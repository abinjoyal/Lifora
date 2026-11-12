import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifora/features/home/domain/entities/home_summary.dart';
import '../providers/home_provider.dart';
import '../widgets/add_memory_banner.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_shortcuts.dart';
import '../widgets/memory_statistics_card.dart';
import '../widgets/recent_memories_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // A. Header (Fixed top)
            const HomeHeader(),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFF47B45),
                backgroundColor: Colors.white,
                onRefresh: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
                child: homeAsync.when(
                  data: (summary) => _buildDashboardContent(context, summary),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF47B45),
                      ),
                    ),
                  ),
                  error: (error, _) => _buildErrorState(context, ref, error),
                ),
              ),
            ),
          ],
        ),
      ),
      // G. Fixed Bottom Navigation Bar
      bottomNavigationBar: const HomeBottomNavigation(selectedIndex: 0),
    );
  }

  Widget _buildDashboardContent(BuildContext context, HomeSummary summary) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // B. Memory Showcase Banner
          const HomeHeroBanner(),
          const SizedBox(height: 18.0),

          // C. Quick Shortcuts
          const HomeShortcuts(),
          const SizedBox(height: 18.0),

          // D. Add New Memory CTA Banner
          const AddMemoryBanner(),
          const SizedBox(height: 24.0),

          // E. Recent Memories Section
          RecentMemoriesSection(memories: summary.recentMemories),
          const SizedBox(height: 24.0),

          // F. Memory Statistics Card
          MemoryStatisticsCard(
            totalMemories: summary.totalMemories,
            totalEvents: summary.totalEvents,
            totalTrips: summary.totalTrips,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load dashboard data',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF806A60), fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF47B45),
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  ref.read(homeNotifierProvider.notifier).loadHomeData(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
