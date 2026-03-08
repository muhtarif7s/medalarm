// 📍 services/notifications/channels.ts

import * as Notifications from 'expo-notifications';
import { Platform } from 'react-native';

const ANDROID_CHANNEL_ID = 'dose-reminders';

/**
 * 📱 إنشاء قنوات الإشعارات لنظام أندرويد
 * يجب استدعاء هذه الدالة قبل إرسال أي إشعار.
 */
export async function createNotificationChannels(): Promise<void> {
    if (Platform.OS === 'android') {
        try {
            await Notifications.setNotificationChannelAsync(ANDROID_CHANNEL_ID, {
                name: 'تذكير الجرعات', // اسم القناة الذي يظهر للمستخدم في الإعدادات
                importance: Notifications.AndroidImportance.MAX,
                vibrationPattern: [0, 250, 250, 250], // نمط الاهتزاز
                lightColor: '#FF231F7C', // لون ضوء LED
                sound: 'default', // استخدم الصوت الافتراضي
            });
            console.log(`✅ Notification channel [${ANDROID_CHANNEL_ID}] created or updated.`);
        } catch (error) {
            console.error('❌ Failed to create notification channel:', error);
        }
    }
}
