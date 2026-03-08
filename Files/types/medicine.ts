// الموقع: app/types/medicine.ts

// 1. النوع الأساسي للدواء كما هو مخزن في قاعدة البيانات
export interface Medicine {
  [x: string]: any;
  id: number;
  name: string;
  notes?: string;
  icon_name?: string;
  color?: string;
  dosage_amount: number;
  dosage_unit: string;
  total_quantity?: number;
  remaining_quantity?: number;
  refill_reminder_at?: number;
  frequency_type: 'daily' | 'specific_days' | 'interval';
  dose_times: string;       // مخزن كـ JSON string
  specific_days?: string;   // مخزن كـ JSON string
  interval_days?: number;
  start_date: string;       // مخزن كـ ISO string
  end_date?: string;         // مخزن كـ ISO string
  skip_count: number;
  // --- ✅ الإضافة الحاسمة التي تصلح كل شيء ---
  // لقد نسينا إضافة هذا الحقل إلى المخطط الرئيسي، مما تسبب في الخطأ
  created_at: string;       // مخزن كـ ISO string
}

// 2. النوع المستخدم عند إضافة دواء جديد (يجب تحديثه أيضًا)
// الآن يجب أن يشمل كل خصائص Medicine ما عدا id
export type NewMedicine = Omit<Medicine, 'id' | 'created_at'> & {
    created_at?: string; // جعله اختياريًا هنا لأن قاعدة البيانات ستضيفه تلقائيًا
    skip_count: number; // التأكد من أنه مطلوب عند الإنشاء
};


// 3. النوع الذي يمثل جرعة في سجل الجرعات (لا تغيير هنا)
export interface DoseHistory {
  id: number;
  medicine_id: number;
  scheduled_time: string; // مخزن كـ ISO string
  taken_at?: string;       // مخزن كـ ISO string
  status: 'taken' | 'skipped';
}

// 4. النوع الذي يمثل الجرعة (سواء قادمة أو فائتة)
export interface UpcomingDose {
  medicineId: number;
  medicineName: string;
  dosage: string;
  color: string;
  scheduledTime: Date;
  doseValue: number;
}
