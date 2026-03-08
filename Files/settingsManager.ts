import AsyncStorage from '@react-native-async-storage/async-storage';

const NOTIFICATION_SOUND_KEY = 'notification_sound_preference';
const NOTIFICATION_DEBUG_KEY = 'notification_debug_enabled';

export type NotificationSound = 'default' | 'silent' | 'calm.wav' | 'gentle.wav' | 'urgent.wav';

// دالة لحفظ اختيار المستخدم
export const saveNotificationSound = async (sound: NotificationSound): Promise<void> => {
  try {
    await AsyncStorage.setItem(NOTIFICATION_SOUND_KEY, sound);
    console.log(`🔊 Notification sound saved: ${sound}`);
  } catch (e) {
    console.error('Failed to save notification sound preference.', e);
  }
};

// دالة لجلب اختيار المستخدم (مع قيمة افتراضية)
export const getNotificationSound = async (): Promise<NotificationSound> => {
  try {
    const sound = await AsyncStorage.getItem(NOTIFICATION_SOUND_KEY);
    return (sound as NotificationSound) || 'default';
  } catch (e) {
    console.error('Failed to fetch notification sound preference.', e);
    return 'default';
  }
};

// دوال جديدة للتشخيص
export const enableNotificationDebug = async (enabled: boolean): Promise<void> => {
  try {
    await AsyncStorage.setItem(NOTIFICATION_DEBUG_KEY, enabled.toString());
  } catch (e) {
    console.error('Failed to save debug preference.', e);
  }
};

export const isNotificationDebugEnabled = async (): Promise<boolean> => {
  try {
    const enabled = await AsyncStorage.getItem(NOTIFICATION_DEBUG_KEY);
    return enabled === 'true';
  } catch (e) {
    console.error('Failed to fetch debug preference.', e);
    return false;
  }
};
