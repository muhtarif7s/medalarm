// الموقع: database/db.ts

import type { DoseHistory, Medicine, NewMedicine } from '@/types/medicine';
import * as SQLite from 'expo-sqlite';

// --- ✅ 1. قمنا بتصدير الكلاس ليتم استخدامه في الملفات الأخرى ---
export class DatabaseManager {
  private static instance: SQLite.SQLiteDatabase | null = null;
  private static readonly DB_NAME = 'doctordaily.db';

  public static async getDb(): Promise<SQLite.SQLiteDatabase> {
    if (this.instance) return this.instance;

    this.instance = await SQLite.openDatabaseAsync(this.DB_NAME);
    
    // --- ✅ 2. تم نقل كل أوامر إنشاء الجداول إلى هذا المكان المركزي ---
    await this.instance.execAsync(`
      PRAGMA journal_mode = WAL;

      CREATE TABLE IF NOT EXISTS medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        notes TEXT,
        icon_name TEXT,
        color TEXT,
        dosage_amount REAL NOT NULL,
        dosage_unit TEXT NOT NULL,
        total_quantity REAL,
        remaining_quantity REAL,
        refill_reminder_at REAL,
        frequency_type TEXT NOT NULL,
        dose_times TEXT NOT NULL,
        specific_days TEXT,
        interval_days INTEGER,
        start_date TEXT NOT NULL,
        end_date TEXT,
        skip_count INTEGER DEFAULT 0 NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS dose_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER NOT NULL,
        scheduled_time TEXT NOT NULL,
        taken_at TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY(medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
      );

      CREATE TABLE IF NOT EXISTS profile (
        id INTEGER PRIMARY KEY NOT NULL, 
        firstName TEXT, 
        lastName TEXT, 
        birthDate TEXT
      );
    `);
    console.log('Database connection established and all schemas ensured.');
    return this.instance;
  }
}

// هذه الدالة لا تزال تعمل كما هي، ولكن الآن `getDb` أقوى
export const initializeDatabase = () => DatabaseManager.getDb();

// --- ✅ الإصلاح الجوهري والنهائي هنا ---
export async function addMedicine(medicine: NewMedicine): Promise<void> {
  const db = await DatabaseManager.getDb();
  // تم تعديل أمر الإضافة ليشمل `skip_count` بشكل صريح
  await db.runAsync(
    `INSERT INTO medicines (name, notes, dosage_amount, dosage_unit, total_quantity, remaining_quantity, frequency_type, dose_times, specific_days, interval_days, start_date, end_date, skip_count)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, // يجب أن يكون هناك 13 علامة استفهام
    [
      medicine.name,
      medicine.notes ?? null,
      medicine.dosage_amount,
      medicine.dosage_unit,
      medicine.total_quantity ?? null,
      medicine.total_quantity ?? null, // الكمية المتبقية هي نفسها الإجمالية
      medicine.frequency_type,
      medicine.dose_times,
      medicine.specific_days ?? null,
      medicine.interval_days ?? null,
      medicine.start_date,
      medicine.end_date ?? null,
      medicine.skip_count, // إضافة القيمة الجديدة التي كانت مفقودة
    ]
  );
}

// دالة جلب الأدوية النشطة
export async function getActiveMedicines(): Promise<Medicine[]> {
  const db = await DatabaseManager.getDb();
  return await db.getAllAsync<Medicine>(
    "SELECT * FROM medicines WHERE (remaining_quantity IS NULL OR remaining_quantity > 0) AND (end_date IS NULL OR date(end_date) >= date('now', 'start of day')) ORDER BY created_at DESC"
  );
}

// دالة تخطي الجرعة
export async function skipDose(medicineId: number, scheduledTime: Date): Promise<void> {
  const db = await DatabaseManager.getDb();
  await db.withTransactionAsync(async () => {
    await db.runAsync(
      'INSERT INTO dose_history (medicine_id, scheduled_time, status) VALUES (?, ?, ?)',
      [medicineId, scheduledTime.toISOString(), 'skipped']
    );
    await db.runAsync(
      'UPDATE medicines SET skip_count = skip_count + 1 WHERE id = ?',
      [medicineId]
    );
  });
  console.log(`Dose SKIPPED for medID: ${medicineId}. Skip count incremented.`);
}

// دالة أخذ الجرعة
export async function takeDoseAndUpdateInventory(medicineId: number, scheduledTime: Date, doseValue: number): Promise<void> {
    const db = await DatabaseManager.getDb();
    await db.withTransactionAsync(async () => {
        await db.runAsync(
            'INSERT INTO dose_history (medicine_id, scheduled_time, taken_at, status) VALUES (?, ?, ?, ?)',
            [medicineId, scheduledTime.toISOString(), new Date().toISOString(), 'taken']
        );
        await db.runAsync(
            'UPDATE medicines SET remaining_quantity = remaining_quantity - ? WHERE id = ? AND (remaining_quantity IS NULL OR remaining_quantity >= ?)',
            [doseValue, medicineId, doseValue]
        );
    });
    console.log(`Dose taken for medID: ${medicineId}. Deducted ${doseValue} from inventory.`);
}

// دالة جلب كل الجرعات التي تمت معالجتها
export async function getAllProcessedDoses(): Promise<DoseHistory[]> {
  const db = await DatabaseManager.getDb();
  return await db.getAllAsync<DoseHistory>(
    "SELECT * FROM dose_history WHERE status = 'taken' OR status = 'skipped'"
  );
}

// دالة جلب دواء معين
export async function getMedicineById(id: number): Promise<Medicine | null> {
    const db = await DatabaseManager.getDb();
    return await db.getFirstAsync<Medicine>("SELECT * FROM medicines WHERE id = ?", [id]);
}

// دالة تعديل الدواء
export async function updateMedicine(id: number, updatedMedicine: Omit<NewMedicine, 'created_at'>): Promise<void> {
  const db = await DatabaseManager.getDb();
  await db.runAsync(
    `UPDATE medicines SET 
     name = ?, notes = ?, dosage_amount = ?, dosage_unit = ?, 
     total_quantity = ?, remaining_quantity = ?, frequency_type = ?, 
     dose_times = ?, specific_days = ?, interval_days = ?, 
     start_date = ?, end_date = ?, skip_count = ?
     WHERE id = ?`,
    [
      updatedMedicine.name,
      updatedMedicine.notes ?? null,
      updatedMedicine.dosage_amount,
      updatedMedicine.dosage_unit,
      updatedMedicine.total_quantity ?? null,
      updatedMedicine.remaining_quantity ?? null,
      updatedMedicine.frequency_type,
      updatedMedicine.dose_times,
      updatedMedicine.specific_days ?? null,
      updatedMedicine.interval_days ?? null,
      updatedMedicine.start_date,
      updatedMedicine.end_date ?? null,
      updatedMedicine.skip_count,
      id
    ]
  );
}

// دالة حذف الدواء
export async function deleteMedicine(id: number): Promise<void> {
  const db = await DatabaseManager.getDb();
  await db.runAsync('DELETE FROM medicines WHERE id = ?', [id]);
}

