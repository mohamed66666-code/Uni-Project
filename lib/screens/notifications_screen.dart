import 'package:flutter/material.dart';
import '../services/app_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0; // 0: الكل, 1: غير مقروءة

  void _handleNotificationTap(AppNotification item) {
    AppState.instance.markNotificationAsRead(item.id);

    if (item.targetRoute != null && item.targetRoute!.isNotEmpty) {
      Navigator.pushNamed(context, item.targetRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final appState = AppState.instance;
        final allNotifications = appState.notifications;
        final unreadCount = appState.unreadNotificationsCount;

        final filteredNotifications = _selectedFilterIndex == 1
            ? allNotifications.where((n) => !n.isRead).toList()
            : allNotifications;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('مركز التنبيهات والإشعارات'),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (unreadCount > 0)
                TextButton.icon(
                  onPressed: () {
                    appState.markAllNotificationsAsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.done_all_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('تم تعيين جميع الإشعارات كمقروءة'),
                          ],
                        ),
                        backgroundColor: Color(0xFF4F46E5),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.done_all_rounded, size: 16),
                  label: const Text('قراءة الكل', style: TextStyle(fontSize: 13)),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Filters & Summary Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('الكل (${allNotifications.length})'),
                      selected: _selectedFilterIndex == 0,
                      onSelected: (_) => setState(() => _selectedFilterIndex = 0),
                      selectedColor: const Color(0xFF3730A3),
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: _selectedFilterIndex == 0 ? Colors.white : const Color(0xFF475569),
                        fontSize: 12,
                        fontWeight: _selectedFilterIndex == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('غير مقروءة'),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: _selectedFilterIndex == 1
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: _selectedFilterIndex == 1,
                      onSelected: (_) => setState(() => _selectedFilterIndex = 1),
                      selectedColor: const Color(0xFF3730A3),
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: _selectedFilterIndex == 1 ? Colors.white : const Color(0xFF475569),
                        fontSize: 12,
                        fontWeight: _selectedFilterIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                    const Spacer(),
                    Text(
                      'اضغط على الإشعار للانتقال',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Notification List
              Expanded(
                child: filteredNotifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.notifications_off_outlined,
                                size: 40,
                                color: Color(0xFF4338CA),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFilterIndex == 1
                                  ? 'لا توجد إشعارات غير مقروءة'
                                  : 'لا توجد إشعارات جديدة حالياً',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'سيتم إعلامك فور صدور أي جداول أو نتائج أو تنبيهات',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        itemCount: filteredNotifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filteredNotifications[index];
                          return _buildNotificationCard(item);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(AppNotification item) {
    final hasTarget = item.targetRoute != null && item.targetRoute!.isNotEmpty;

    return InkWell(
      onTap: () => _handleNotificationTap(item),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF5F8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead ? const Color(0xFFE2E8F0) : const Color(0xFF818CF8),
            width: item.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: item.isRead
                  ? Colors.black.withValues(alpha: 0.02)
                  : const Color(0xFF4F46E5).withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon with soft badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                if (!item.isRead)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: item.isRead ? FontWeight.bold : FontWeight.w900,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),

                  // Destination Tab Pill if available
                  if (hasTarget) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC7D2FE)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app_rounded, size: 14, color: Color(0xFF4338CA)),
                          const SizedBox(width: 5),
                          Text(
                            'انتقال إلى: ${item.routeLabel ?? "الصفحة الموجه إليها"}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3730A3),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_back_ios_new_rounded, size: 10, color: Color(0xFF4338CA)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
