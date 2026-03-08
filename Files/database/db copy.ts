// الموقع: database/db.ts
// هذا هو الحل الهندسي النهائي الذي يمنع تعطل قاعدة البيانات

import * as SQLite from 'expo-sqlite';

// --- تعريف الأنواع (لا تغيير) ---
export interface Medicine { id: number; name: string; notes?: string; icon_name?: string; color?: string; dosage_amount: number; dosage_unit: string; total_quantity?: number; refill_reminder_at?: number; frequency_type: 'daily' | 'specific_days' | 'interval'; dose_times: string; start_date: string; end_date?: string; }
export type NewMedicine = Omit<Medicine, 'id'>;
export interface DoseHistory { id: number; medicine_id: number; scheduled_time: string; taken_at?: string; status: 'taken' | 'skipped'; }

// --- "مدير قاعدة البيانات" الذكي (Singleton) ---
class DatabaseManager {
  private static instance: SQLite.SQLiteDatabase | null = null;
  private static readonly DB_NAME = 'dawaei-youmi.db';

  public static async getDb(): Promise<SQLite.SQLiteDatabase> {
    if (this.instance) {
      return this.instance;
    }
    this.instance = await SQLite.openDatabaseAsync(this.DB_NAME);
    await this.instance.execAsync(`
      PRAGMA journal_mode = WAL;
      CREATE TABLE IF NOT EXISTS medicines ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, notes TEXT, icon_name TEXT, color TEXT, dosage_amount REAL NOT NULL, dosage_unit TEXT NOT NULL, total_quantity REAL, refill_reminder_at REAL, frequency_type TEXT NOT NULL, dose_times TEXT NOT NULL, start_date DATETIME NOT NULL, end_date DATETIME, created_at DATETIME DEFAULT CURRENT_TIMESTAMP );
      CREATE TABLE IF NOT EXISTS dose_history ( id INTEGER PRIMARY KEY AUTOINCREMENT, medicine_id INTEGER NOT NULL, scheduled_time TEXT NOT NULL, taken_at DATETIME, status TEXT NOT NULL, FOREIGN KEY(medicine_id) REFERENCES medicines(id) ON DELETE CASCADE );
    `);
    console.log('✅ Database connection established and schema ensured.');
    return this.instance;
  }
}

// --- الآن، كل الدوال تستخدم "المدير" للحصول على الاتصال ---

export const initializeDatabase = () => DatabaseManager.getDb();

export async function getAllMedicines(): Promise<Medicine[]> {
  const db = await DatabaseManager.getDb();
  return await db.getAllAsync<Medicine>("SELECT * FROM medicines WHERE total_quantity IS NULL OR total_quantity > 0 ORDER BY created_at DESC");
}

export async function addMedicine(medicine: NewMedicine): Promise<void> {
  const db = await DatabaseManager.getDb();
  await db.runAsync(
    `INSERT INTO medicines (name, notes, dosage_amount, dosage_unit, total_quantity, frequency_type, dose_times, start_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    medicine.name, medicine.notes ?? null, medicine.dosage_amount,
    medicine.dosage_unit, medicine.total_quantity ?? null, medicine.frequency_type,
    medicine.dose_times, medicine.start_date
  );
}

export async function recordDoseTaken(medicineId: number, scheduledTime: Date): Promise<void> {
  const db = await DatabaseManager.getDb();
  await db.runAsync(
    'INSERT INTO dose_history (medicine_id, scheduled_time, taken_at, status) VALUES (?, ?, ?, ?)',
    medicineId, scheduledTime.toISOString(), new Date().toISOString(), 'taken'
  );
  await db.runAsync(
    'UPDATE medicines SET total_quantity = total_quantity - 1 WHERE id = ? AND total_quantity > 0',
    medicineId
  );
}

export async function getTakenDosesForToday(): Promise<DoseHistory[]> {
  const db = await DatabaseManager.getDb();
  // استخدام الاستعلام الأكثر دقة الذي كتبته أنت
  return await db.getAllAsync<DoseHistory>(
    "SELECT * FROM dose_history WHERE status = 'taken' AND date(taken_at) = date('now', 'localtime')"
  );
}
