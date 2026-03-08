// 📍 services/notifications/helpers.ts (مُصحح)

import * as Notifications from 'expo-notifications'; // ✅ إضافة الاستيراد المفقود
import { Platform } from 'react-native';

/**
 * تطبيع الأرقام العربية إلى إنجليزية
 */
export function normalizeArabicNumerals(str: string): string {
    if (!str) return '';
    return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d).toString());
}

/**
 * الحصول على ملف الصوت للإشعار
 */
export function getSoundForNotification(preferredSound: string): string | undefined {
    if (preferredSound === 'silent') return undefined;
    if (Platform.OS === 'android') return undefined; // النغمة تأتي من القناة
    return preferredSound === 'default' ? 'default' : preferredSound;
}

/**
 * تحليل وقت النص وتحويله إلى ساعات ودقائق
 */
export function parseTimeString(timeStr: string): { hours: number; minutes: number } | null {
    const normalizedTime = normalizeArabicNumerals(timeStr);
    const match = normalizedTime.match(/(\d+):(\d+)/);

    if (!match) return null;

    let hours = parseInt(match[1], 10);
    const minutes = parseInt(match[2], 10);
    const isPM = normalizedTime.includes('م') || normalizedTime.toLowerCase().includes('pm');

    // تحويل إلى صيغة 24 ساعة
    if (isPM && hours < 12) hours += 12;
    else if (!isPM && hours === 12) hours = 0;

    // التحقق من صحة القيم
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        return null;
    }

    return { hours, minutes };
}

/**
 * إنشاء معرف فريد للإشعار
 */
export function createNotificationIdentifier(medicineId: number, scheduledTime: Date): string {
    return `dose_${medicineId}_${scheduledTime.getTime()}`;
}

/**
 * إنشاء مفتاح لتتبع الإشعارات المجدولة
 */
export function createDoseKey(medicineId: number, scheduledTime: Date): string {
    return `${medicineId}-${scheduledTime.toISOString()}`;
}

/**
 * تنظيف الإشعارات المنتهية الصلاحية
 */
export async function cleanExpiredNotifications(): Promise<number> {
    try {
        const existingNotifications = await Notifications.getAllScheduledNotificationsAsync(); // ✅ مُصحح
        const now = new Date();
        let cleanedCount = 0;

        for (const notification of existingNotifications) {
            const trigger = notification.trigger as any;
            if (trigger.date && new Date(trigger.date) < now) {
                await Notifications.cancelScheduledNotificationAsync(notification.identifier); // ✅ مُصحح
                cleanedCount++;
            }
        }

        if (cleanedCount > 0) {
            console.log(`🧹 Cleaned ${cleanedCount} expired notifications`);
        }

        return cleanedCount;
    } catch (error) {
        console.error('❌ Error cleaning expired notifications:', error);
        return 0;
    }
}
