import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:dynamic_emr/features/notice/domain/entities/notice_entity.dart';
import 'package:dynamic_emr/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoticeBloc>().add(AllNoticesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DynamicEMRAppBar(
        title: "Notices",
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // Container(
          //   height: 60,
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   color: Colors.white,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     itemCount: 4,
          //     itemBuilder: (context, index) {
          //       final filter = filters[index];
          //       final isSelected = selectedFilter == filter;
          //       return Padding(
          //         padding: const EdgeInsets.only(right: 12),
          //         child: FilterChip(
          //           label: Text(
          //             filter,
          //             style: TextStyle(
          //               color: isSelected
          //                   ? Colors.white
          //                   : const Color(0xFF2C3E50),
          //               fontWeight: isSelected
          //                   ? FontWeight.w600
          //                   : FontWeight.w500,
          //             ),
          //           ),
          //           selected: isSelected,
          //           onSelected: (selected) {
          //             setState(() {
          //               selectedFilter = filter;
          //             });
          //           },
          //           backgroundColor: Colors.grey[100],
          //           selectedColor: const Color(0xFF3498DB),
          //           checkmarkColor: Colors.white,
          //           elevation: 0,
          //           pressElevation: 2,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<NoticeBloc>().add(AllNoticesEvent());
              },
              child: BlocBuilder<NoticeBloc, NoticeState>(
                builder: (context, state) {
                  if (state.status == NoticeStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.status == NoticeStatus.success) {
                    final notices = state.notices
                        .where((e) => e.isPublished == true)
                        .toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];
                        return _buildNoticeCard(context, notice, index);
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(
    BuildContext context,
    NoticeEntity notice,
    int index,
  ) {
    final isUrgent = notice.category == 'Urgent';
    final timeAgo = _getTimeAgo(notice.publishedTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: isUrgent ? Border.all(color: Colors.red[300]!, width: 1) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showNoticeDetail(context, notice),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(
                          notice.category,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(notice.category),
                            size: 14,
                            color: _getCategoryColor(notice.category),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notice.category,
                            style: TextStyle(
                              color: _getCategoryColor(notice.category),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  notice.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Excerpt
                Text(
                  notice.excerpt,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    if (notice.tags != null) ...[
                      Icon(
                        Icons.tag_outlined,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notice.tags!,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNoticeDetail(BuildContext context, NoticeEntity notice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category and Date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                notice.category,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(notice.category),
                                  size: 14,
                                  color: _getCategoryColor(notice.category),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  notice.category,
                                  style: TextStyle(
                                    color: _getCategoryColor(notice.category),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (notice.publishedTime != null)
                            Text(
                              DateFormat(
                                'MMM dd, yyyy • hh:mm a',
                              ).format(notice.publishedTime!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        notice.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Content
                      Text(
                        notice.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF34495E),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Tags
                      if (notice.tags != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tag_outlined,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tags: ${notice.tags}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime? publishedTime) {
    if (publishedTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(publishedTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(publishedTime);
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'notice':
        return const Color(0xFF3498DB);
      case 'announcement':
        return const Color(0xFF9B59B6);
      case 'news':
        return const Color(0xFF2ECC71);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'urgent':
        return Icons.warning_outlined;
      case 'Notice':
        return Icons.info_outlined;
      case 'announcement':
        return Icons.campaign_outlined;
      case 'News':
        return Icons.event_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
