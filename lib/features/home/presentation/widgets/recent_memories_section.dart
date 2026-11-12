import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../domain/entities/home_summary.dart';
import 'recent_memory_card.dart';

class RecentMemoriesSection extends StatelessWidget {
  const RecentMemoriesSection({super.key, required this.memories});

  final List<HomeMemoryItem> memories;

  static const Color _titleColor = Color(0xFF38251F);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Memories',
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () => context.push(RouteConstants.memoriesPath),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: _primaryOrange,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _primaryOrange,
                        size: 12.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14.0),

        // Horizontal Gallery or Empty State
        if (memories.isEmpty)
          _buildEmptyState(context)
        else
          SizedBox(
            height: 204.0,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: memories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14.0),
              itemBuilder: (context, index) {
                final memory = memories[index];
                return RecentMemoryCard(
                  memory: memory,
                  onTap: () =>
                      context.push(RouteConstants.memoryDetailsUrl(memory.id)),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFEADBCE)),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_outlined,
                color: _primaryOrange,
                size: 26,
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Your memories will appear here.',
              style: TextStyle(
                color: _titleColor,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Capture moments with photos, dates, and locations.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF806A60), fontSize: 12.5),
            ),
            const SizedBox(height: 14.0),
            TextButton.icon(
              onPressed: () => context.push(RouteConstants.createMemoryPath),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Memory'),
              style: TextButton.styleFrom(
                foregroundColor: _primaryOrange,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
