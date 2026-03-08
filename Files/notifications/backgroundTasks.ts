// 📍 services/notifications/backgroundTasks.ts

import * as BackgroundFetch from 'expo-background-fetch';
import * as TaskManager from 'expo-task-manager';
import { getAllDoses } from '../storage/doseManager'; // ⚠️ !! افترض أن لديك هذه الدالة لجلب كل الجرعات
import { scheduleNext24HoursNotifications, cancelAllScheduledNotifications, getNotificationStats } from './scheduler';

const DOSE_CHECK_TASK = 'dose-check-background-task';

/**
 * 📝 تعريف المهمة الخلفية
 * هذه هي المهمة التي سيتم تنفيذها في الخلفية.
 */
TaskManager.defineTask(DOSE_CHECK_TASK, async () => {
    try {
        console.log(`⏰ [${new Date().toISOString()}] Running background task: ${DOSE_CHECK_TASK}`);

        // 1. جلب الجرعات من مصدر البيانات (مثلاً AsyncStorage أو قاعدة بيانات)
        // ⚠️ استبدل هذا بالمنطق الفعلي لجلب بيانات الأدوية والجرعات
        const allDoses = await getAllDoses();

        // 2. إلغاء الإشعارات القديمة وإعادة الجدولة للـ 24 ساعة القادمة
        await cancelAllScheduledNotifications();
        const scheduledCount = await scheduleNext24HoursNotifications(allDoses);

        console.log(`🔄 Background task: Rescheduled ${scheduledCount} notifications.`);
        await getNotificationStats(); // لطباعة الوضع الحالي

        // يجب أن تُرجع نتيجة متوافقة مع BackgroundFetchResult
        return scheduledCount > 0 ? BackgroundFetch.BackgroundFetchResult.NewData : BackgroundFetch.BackgroundFetchResult.NoData;
    } catch (error) {
        console.error(`❌ Error in background task: ${DOSE_CHECK_TASK}`, error);
        return BackgroundFetch.BackgroundFetchResult.Failed;
    }
});

/**
 * 🚀 تسجيل المهمة الخلفية لتعمل بشكل دوري
 */
export async function registerDoseBackgroundTask(): Promise<boolean> {
    try {
        await BackgroundFetch.registerTaskAsync(DOSE_CHECK_TASK, {
            minimumInterval: 15 * 60, // 15 دقيقة (أقل فترة ممكنة)
            stopOnTerminate: false,    // استمر في العمل حتى لو تم إنهاء التطبيق (Android)
            startOnBoot: true,         // ابدأ المهمة عند إعادة تشغيل الجهاز (Android)
        });
        console.log(`✅ Task [${DOSE_CHECK_TASK}] registered successfully.`);
        return true;
    } catch (error) {
        console.error(`❌ Failed to register background task [${DOSE_CHECK_TASK}]`, error);
        return false;
    }
}

/**
 * ⏹ إلغاء تسجيل المهمة الخلفية (عند تسجيل الخروج مثلاً)
 */
export async function unregisterDoseBackgroundTask(): Promise<void> {
    try {
        if (await TaskManager.isTaskRegisteredAsync(DOSE_CHECK_TASK)) {
            await BackgroundFetch.unregisterTaskAsync(DOSE_CHECK_TASK);
            console.log(`⏹ Task [${DOSE_CHECK_TASK}] unregistered successfully.`);
        }
    } catch (error) {
        console.error(`❌ Failed to unregister background task [${DOSE_CHECK_TASK}]`, error);
    }
}

/**
 * 📊 التحقق من حالة تسجيل المهمة الخلفية
 */
export async function getBackgroundTaskStatus(): Promise<string> {
    const isRegistered = await TaskManager.isTaskRegisteredAsync(DOSE_CHECK_TASK);
    if (!isRegistered) return "Not Registered";

    const status = await BackgroundFetch.getStatusAsync();
    switch (status) {
        case BackgroundFetch.BackgroundFetchStatus.Denied:
            return "Denied (check device settings)";
        case BackgroundFetch.BackgroundFetchStatus.Restricted:
            return "Restricted (check device settings)";
        case BackgroundFetch.BackgroundFetchStatus.Available:
            return "Available";
        default:
            return "Unknown";
    }
}
