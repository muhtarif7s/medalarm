// 📍 services/notifications/index.ts (النسخة النهائية المُصححة)

import * as Notifications from 'expo-notifications';
import { Platform } from 'react-native';
import { getBackgroundTaskStatus, registerDoseBackgroundTask } from './backgroundTasks';
import { createNotificationChannels } from './channels';
import { ensurePermissionsAsync } from './permissions';
import { cancelAllScheduledNotifications, getNotificationStats, scheduleNext24HoursNotifications } from './scheduler';

// 🛠 إعداد Notification Handler
Notifications.setNotificationHandler({
    handleNotification: async () => ({
        shouldShowAlert: true, // Correct property for showing a banner
        shouldPlaySound: true,
        shouldSetBadge: true,
    }),
});

/**
 * 🚀 تهيئة نظام الإشعارات الكامل
 */
export async function initializeNotificationSystem(): Promise<{
    success: boolean;
    permissionsGranted: boolean;
    backgroundTaskRegistered: boolean;
    notificationsScheduled: number;
}> {
    console.log('🚀 Initializing Notification System...');

    // 1. إنشاء القنوات (حيوي لـ Android)
    if (Platform.OS === 'android') {
        await createNotificationChannels();
        console.log('✅ Notification channels created/verified.');
    }

    // 2. طلب الأذونات
    const permissionsGranted = await ensurePermissionsAsync();
    if (!permissionsGranted) {
        console.warn('⚠️ Notification permissions not granted. System will not function.');
        return {
            success: false,
            permissionsGranted: false,
            backgroundTaskRegistered: false,
            notificationsScheduled: 0,
        };
    }
    console.log('✅ Notification permissions granted.');

    // 3. إلغاء أي إشعارات قديمة لضمان بداية نظيفة
    await cancelAllScheduledNotifications();
    console.log('🧹 Cancelled all previously scheduled notifications.');

    // 4. جدولة فورية للـ 24 ساعة القادمة
    const upcomingDoses = []; // This should be replaced with your actual dose fetching logic
    const scheduledCount = await scheduleNext24HoursNotifications(upcomingDoses);
    console.log(`✅ Initially scheduled ${scheduledCount} notifications for the next 24 hours.`);

    // 5. تسجيل المهمة الخلفية
    const backgroundTaskRegistered = await registerDoseBackgroundTask();
    if (backgroundTaskRegistered) {
        console.log('✅ Background task registered successfully.');
    } else {
        console.warn('⚠️ Background task registration failed.');
    }

    // 6. طباعة الإحصائيات النهائية
    await getNotificationStats();
    const backgroundStatus = await getBackgroundTaskStatus();
    console.log(`📊 Background Task Status: ${backgroundStatus}`);

    return {
        success: true,
        permissionsGranted,
        backgroundTaskRegistered,
        notificationsScheduled: scheduledCount,
    };
}

/**
 * 🔄 إعادة مزامنة وجدولة الإشعارات عند تغيير البيانات
 * يُستدعى هذا عند إضافة/تعديل/حذف دواء
 */
export async function resyncNotifications(doses: any[]): Promise<void> {
    console.log('🔄 Resyncing notifications due to data change...');
    await cancelAllScheduledNotifications();
    const count = await scheduleNext24HoursNotifications(doses);
    console.log(`🔄 Resynced and scheduled ${count} new notifications.`);
    await getNotificationStats();
}
