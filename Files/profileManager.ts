// الموقع: services/profileManager.ts

// ✅ 1. نستورد الكلاس الذي قمنا بتصديره، وليس متغيرًا وهميًا
import { DatabaseManager } from '@/database/db';

export interface UserProfile {
  id: number;
  firstName: string;
  lastName: string;
  birthDate: string;
}

// ✅ 2. لم نعد بحاجة لدالة setupProfileTable لأنها تتم مركزيًا

// دالة لحفظ أو تحديث الملف الشخصي
export const saveUserProfile = async (profile: Omit<UserProfile, 'id'>) => {
  const db = await DatabaseManager.getDb();
  // ✅ 3. نستخدم runAsync الحديثة بدلاً من db.transaction القديمة
  await db.runAsync(
    `INSERT OR REPLACE INTO profile (id, firstName, lastName, birthDate) VALUES (1, ?, ?, ?);`,
    profile.firstName,
    profile.lastName,
    profile.birthDate
  );
};

// دالة لجلب الملف الشخصي
export const getUserProfile = async (): Promise<UserProfile | null> => {
  const db = await DatabaseManager.getDb();
  // ✅ 4. نستخدم getFirstAsync لجلب صف واحد فقط، وهي مثالية هنا
  const result = await db.getFirstAsync<UserProfile>(
    'SELECT * FROM profile WHERE id = 1;'
  );
  return result; // ستعيد هذه الدالة الكائن مباشرة أو null إذا لم تجده
};
