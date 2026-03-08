// الموقع: services/soundManager.ts

// هذا الملف يقوم بتعريف مسارات النغمات وجعلها متاحة للتطبيق
// require() هي التي تضمن أن الملفات سيتم تضمينها في الحزمة النهائية للتطبيق

export const soundAssets = {
  'calm.wav': require('@/assets/sounds/calm.wav'),
  'gentle.wav': require('@/assets/sounds/gentle.wav'),
  'urgent.wav': require('@/assets/sounds/urgent.wav'),
};
