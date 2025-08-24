import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationResponse? notificationData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Simulate API call - replace with your actual API call
  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock API response - replace with your actual API call
    final mockResponse = {
      "notificationCount": 3,
      "recentNotifications": [
        {
          "id": 1274,
          "from": "vishal",
          "fromEmail": "vishal@company.com",
          "to": "Chudaraj paudyal",
          "toEmail": "chudaraj@company.com",
          "title": "Ticket Assigned",
          "content":
              "New ticket has been assigned to you. Please review and provide your feedback within 24 hours.",
          "mailDate": "yesterday",
          "hasAttachment": false,
          "starred": false,
          "viewed": false,
        },
        {
          "id": 1275,
          "from": "HR Department",
          "fromEmail": "hr@company.com",
          "to": "Chudaraj paudyal",
          "toEmail": "chudaraj@company.com",
          "title": "Leave Request Approved",
          "content":
              "Your leave request for Dec 25-27 has been approved by your manager.",
          "mailDate": "2 hours ago",
          "hasAttachment": false,
          "starred": true,
          "viewed": false,
        },
        {
          "id": 1276,
          "from": "Payroll Team",
          "fromEmail": "payroll@company.com",
          "to": "Chudaraj paudyal",
          "toEmail": "chudaraj@company.com",
          "title": "Salary Processed",
          "content":
              "Your salary for December 2024 has been processed and will be credited to your account soon.",
          "mailDate": "3 days ago",
          "hasAttachment": true,
          "starred": false,
          "viewed": true,
        },
      ],
    };

    setState(() {
      notificationData = NotificationResponse.fromJson(mockResponse);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(title: "Notification",automaticallyImplyLeading: true,
          actions: [
          if (notificationData != null && notificationData!.unreadCount > 0)
            TextButton(
              onPressed: (){
                // mark all as read
              },
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notificationData == null ||
        notificationData!.recentNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        if (notificationData!.unreadCount > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border(
                bottom: BorderSide(color: Colors.blue[100]!, width: 1),
              ),
            ),
            child: Text(
              '${notificationData!.unreadCount} new notification${notificationData!.unreadCount > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notificationData!.recentNotifications.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 72, endIndent: 16),
            itemBuilder: (context, index) {
              return _buildNotificationTile(
                notificationData!.recentNotifications[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Container(
      color: notification.viewed ? Colors.white : Colors.blue[25],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotificationColor(
                  notification.title,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.title),
                color: _getNotificationColor(notification.title),
                size: 24,
              ),
            ),
            if (notification.hasAttachment)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.attach_file,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.viewed
                      ? FontWeight.w500
                      : FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            if (notification.starred)
              Icon(Icons.star, size: 16, color: Colors.amber[600]),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'From: ${notification.from}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              notification.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              notification.mailDate,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        onTap: () {
          if (!notification.viewed) {
            // marked as read
          }
          _showNotificationDetail(notification);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('ticket')) {
      return Icons.support_agent;
    } else if (titleLower.contains('leave')) {
      return Icons.event_available;
    } else if (titleLower.contains('salary') ||
        titleLower.contains('payroll')) {
      return Icons.account_balance_wallet;
    } else if (titleLower.contains('performance') ||
        titleLower.contains('review')) {
      return Icons.trending_up;
    } else if (titleLower.contains('meeting')) {
      return Icons.schedule;
    } else if (titleLower.contains('announcement')) {
      return Icons.campaign;
    } else {
      return Icons.notifications;
    }
  }

  Color _getNotificationColor(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('ticket')) {
      return Colors.orange;
    } else if (titleLower.contains('leave')) {
      return Colors.green;
    } else if (titleLower.contains('salary') ||
        titleLower.contains('payroll')) {
      return Colors.purple;
    } else if (titleLower.contains('performance') ||
        titleLower.contains('review')) {
      return Colors.blue;
    } else if (titleLower.contains('meeting')) {
      return Colors.teal;
    } else if (titleLower.contains('announcement')) {
      return Colors.indigo;
    } else {
      return Colors.grey;
    }
  }







  void _showNotificationDetail(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'From: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(notification.from),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'To: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(notification.to),
                ],
              ),
              const SizedBox(height: 16),
              Text(notification.content),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (notification.hasAttachment)
                    Icon(Icons.attach_file, size: 16, color: Colors.grey[600]),
                  if (notification.starred)
                    Icon(Icons.star, size: 16, color: Colors.amber[600]),
                  const Spacer(),
                  Text(
                    notification.mailDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (notification.hasAttachment)
            ElevatedButton(
              onPressed: () {
                // TODO: Handle attachment download/view
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening attachment...')),
                );
              },
              child: const Text('View Attachment'),
            ),
        ],
      ),
    );
  }
}

class NotificationResponse {
  int notificationCount;
  List<NotificationItem> recentNotifications;

  NotificationResponse({
    required this.notificationCount,
    required this.recentNotifications,
  });

  int get unreadCount => recentNotifications.where((n) => !n.viewed).length;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notificationCount: json['notificationCount'] ?? 0,
      recentNotifications:
          (json['recentNotifications'] as List<dynamic>?)
              ?.map((item) => NotificationItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class NotificationItem {
  final int id;
  final String from;
  final String fromEmail;
  final String to;
  final String toEmail;
  final String title;
  final String content;
  final String mailDate;
  final bool hasAttachment;
  bool starred;
  bool viewed;

  NotificationItem({
    required this.id,
    required this.from,
    required this.fromEmail,
    required this.to,
    required this.toEmail,
    required this.title,
    required this.content,
    required this.mailDate,
    required this.hasAttachment,
    required this.starred,
    required this.viewed,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      from: json['from'] ?? '',
      fromEmail: json['fromEmail'] ?? '',
      to: json['to'] ?? '',
      toEmail: json['toEmail'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mailDate: json['mailDate'] ?? '',
      hasAttachment: json['hasAttachment'] ?? false,
      starred: json['starred'] ?? false,
      viewed: json['viewed'] ?? false,
    );
  }
}
