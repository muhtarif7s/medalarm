// 📍 services/notifications/scheduler.ts

import { Dose } from '@/context/DoseContext'; // ⚠️ افترض أن هذا هو نوع الجرعة لديك
import * as Notifications from 'expo-notifications';
import { addDays, differenceInSeconds, isAfter } from 'date-fns';

const NOTIFICATION_LIMIT = 60; // الحد الأقصى للإشعارات المجدولة لتجنب الأخطاء

/**
 * 📅 جدولة الإشعارات للـ 24 ساعة القادمة
 * @param doses - مصفوفة من كائنات الجرعات التي تحتوي على مواعيد وأسماء الأدوية
 */
export async function scheduleNext24HoursNotifications(doses: Dose[]): Promise<number> {
    console.log('⏳ Preparing to schedule notifications for the next 24 hours...');

    const now = new Date();
    const in24Hours = addDays(now, 1);
    let scheduledCount = 0;

    // 1. تصفية الجرعات لتشمل فقط ما هو قادم في الـ 24 ساعة القادمة
    const upcomingDoses = doses.filter(dose =>
        isAfter(dose.scheduledTime, now) && differenceInSeconds(dose.scheduledTime, now) > 0
    );

    console.log(`🔍 Found ${upcomingDoses.length} upcoming doses to schedule.`);

    // 2. جدولة الإشعارات
    for (const dose of upcomingDoses) {
        if (scheduledCount >= NOTIFICATION_LIMIT) {
            console.warn(`⚠️ Reached notification limit of ${NOTIFICATION_LIMIT}. Stopping further scheduling.`);
            break;
        }

        try {
            const trigger = new Date(dose.scheduledTime);

            await Notifications.scheduleNotificationAsync({
                content: {
                    title: '💊 موعد جرعتك!',
                    body: `حان الآن وقت تناول دواء ${dose.medicineName}`,
                    sound: 'default', // استخدم الصوت الافتراضي أو صوتًا مخصصًا
                    data: { doseId: dose.id, medicineId: dose.medicineId }, // بيانات إضافية
                    priority: Notifications.AndroidNotificationPriority.HIGH,
                },
                trigger, // جدولة في الوقت المحدد للجرعة
            });
            scheduledCount++;
        } catch (error) {
            console.error(`❌ Failed to schedule notification for dose ${dose.id}:`, error);
        }
    }

    console.log(`✅ Scheduled ${scheduledCount} new notifications.`);
    return scheduledCount;
}

/**
 * 🗑️ إلغاء كل الإشعارات المجدولة
 */
export async function cancelAllScheduledNotifications(): Promise<void> {
    await Notifications.cancelAllScheduledNotificationsAsync();
}

/**
 * 📊 جلب وطباعة إحصائيات الإشعارات الحالية
 */
export async function getNotificationStats(): Promise<void> {
    try {
        const scheduledNotifications = await Notifications.getAllScheduledNotificationsAsync();
        console.log(`📅 Total scheduled notifications: ${scheduledNotifications.length}`);

        if (scheduledNotifications.length > 0) {
            const nextNotifications = scheduledNotifications
                .slice(0, 3)
                .map((n, i) =>
                    `${i + 1}. ID: ${n.identifier}, Trigger: ${new Date(n.trigger.value).toLocaleString()}`
                )
                .join('\n');
            console.log(`📋 Next 3 upcoming notifications:\n${nextNotifications}`);
        }
    } catch (error) {
        console.error('❌ Failed to get notification stats:', error);
    }
}
