// 📍 services/notifications/permissions.ts

import * as Notifications from 'expo-notifications';
import { Platform } from 'react-native';

/**
 * 🔐 التأكد من وجود صلاحيات الإشعارات وطلبها إذا لزم الأمر
 */
export async function ensurePermissionsAsync(): Promise<boolean> {
    const { status: existingStatus } = await Notifications.getPermissionsAsync();
    let finalStatus = existingStatus;

    // إذا لم يتم منح الصلاحية، اطلبها من المستخدم
    if (existingStatus !== 'granted') {
        const { status } = await Notifications.requestPermissionsAsync({
            ios: {
                allowAlert: true,
                allowBadge: true,
                allowSound: true,
                allowAnnouncements: true,
            },
        });
        finalStatus = status;
    }

    // على أندرويد، لا يتطلب الأمر أي إجراء إضافي إذا تم الرفض

    if (finalStatus !== 'granted') {
        console.warn('Notification permissions were not granted.');
        return false;
    }

    return true;
}
