// الموقع: utils/time.ts

/**
 * دالة مساعدة لتضيف صفرًا قبل الأرقام الفردية (e.g., 7 -> "07")
 */
export const pad = (num: number): string => num.toString().padStart(2, '0');
