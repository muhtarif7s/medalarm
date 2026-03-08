// الموقع: app/services/medicineManager.ts

import * as db from '@/database/db';
import * as scheduler from '@/services/schedulingService';
// --- ✅ الخطوة 1: استيراد النوع الجديد الذي سنحتاجه ---
import type { Medicine, NewMedicine, UpcomingDose } from '@/types/medicine';

/**
 * يجلب كل البيانات اللازمة للتطبيق ويصنفها.
 * @returns كائن يحتوي على: الأدوية، الجرعات القادمة، الفائتة، وسجل الجرعات الكامل.
 */
export async function getDashboardData() {
  // 1. جلب البيانات الأساسية من قاعدة البيانات بالتوازي
  const [activeMedicines, doseHistory] = await Promise.all([
    db.getActiveMedicines(),
    db.getAllProcessedDoses(),
  ]);

  // 2. استخدام "المحرك" الذكي لتصنيف الجرعات
  const { upcoming, missed } = scheduler.processAndCategorizeDoses(
    activeMedicines,
    doseHistory // استخدام السجل الكامل للتصنيف
  );

  // --- ✅ الخطوة 2 (الإصلاح الجوهري): إضافة سجل الجرعات إلى البيانات المُعادة ---
  return {
    medicines: activeMedicines,
    upcomingDoses: upcoming,
    missedDoses: missed,
    doseHistory: doseHistory, // <-- هذه هي الإضافة الأهم
  };
}

/**
 * يعالج عملية أخذ الجرعة بالكامل (لا تغيير هنا).
 */
export async function handleTakeDose(dose: UpcomingDose): Promise<void> {
  await db.takeDoseAndUpdateInventory(
    dose.medicineId,
    dose.scheduledTime,
    dose.doseValue
  );
}

/**
 * يعالج عملية تخطي الجرعة (لا تغيير هنا).
 */
export async function handleSkipDose(dose: UpcomingDose): Promise<void> {
  await db.skipDose(dose.medicineId, dose.scheduledTime);
}

/**
 * يضيف دواءً جديدًا (لا تغيير هنا).
 */
export async function addNewMedicine(newMedicine: NewMedicine): Promise<void> {
  await db.addMedicine(newMedicine);
}

/**
 * يجلب دواءً محددًا (لا تغيير هنا).
 */
export async function getMedicineDetails(id: number): Promise<Medicine | null> {
    return await db.getMedicineById(id);
}

/**
 * يعدل دواءً موجودًا
 */
export async function updateExistingMedicine(id: number, updatedMedicine: Omit<NewMedicine, 'created_at'>): Promise<void> {
  await db.updateMedicine(id, updatedMedicine);
}

/**
 * يحذف دواءً موجودًا
 */
export async function deleteExistingMedicine(id: number): Promise<void> {
  await db.deleteMedicine(id);
}

