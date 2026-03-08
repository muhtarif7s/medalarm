// الموقع: app/settings/reminders.tsx

// --- ✅ 1. استيراد كل الأدوات الجديدة ---
import { getNotificationSound, saveNotificationSound, type NotificationSound } from '@/services/settingsManager';
import { soundAssets } from '@/services/soundManager';
import { Audio } from 'expo-av';
import { useFocusEffect } from 'expo-router';
import React, { useCallback, useState } from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { RadioButton, Text, useTheme } from 'react-native-paper';
import { SettingsRow } from '../../settings/_components/SettingsRow';

export default function RemindersScreen() {
  const theme = useTheme();
  const styles = createStyles(theme);

  const [selectedSound, setSelectedSound] = useState<NotificationSound>('default');
  // --- ✅ 2. حالة لتخزين كائن الصوت الحالي لمنع التداخل ---
  const [soundObject, setSoundObject] = useState<Audio.Sound | null>(null);

  // دالة لتفريغ الصوت من الذاكرة (مهم جدًا)
  async function unloadCurrentSound() {
    if (soundObject) {
      await soundObject.unloadAsync();
      setSoundObject(null);
    }
  }

  // جلب الإعدادات عند فتح الشاشة، وتفريغ أي صوت عند مغادرتها
  useFocusEffect(
    useCallback(() => {
      const loadSettings = async () => {
        const sound = await getNotificationSound();
        setSelectedSound(sound);
      };
      loadSettings();
      
      return () => {
        unloadCurrentSound(); // تفريغ الصوت عند الخروج من الشاشة
      };
    }, [])
  );

  // --- ✅ 3. الدالة الجديدة والمحسنة لمعالجة الاختيار وتشغيل الصوت ---
  const handleSelectSound = async (sound: NotificationSound) => {
    setSelectedSound(sound);
    saveNotificationSound(sound);
    
    // إيقاف وتفريغ أي صوت يعمل حاليًا
    await unloadCurrentSound();

    // إذا لم يكن الاختيار صامتًا أو افتراضيًا، قم بتشغيل المعاينة
    if (sound !== 'silent' && sound !== 'default') {
      try {
        const { sound: newSoundObject } = await Audio.Sound.createAsync(
          soundAssets[sound as keyof typeof soundAssets] // جلب المسار الصحيح
        );
        setSoundObject(newSoundObject);
        await newSoundObject.playAsync();
      } catch (error) {
        console.error("Error playing sound preview:", error);
      }
    }
  };
  
  const soundOptions = [
    { label: 'الصوت الافتراضي للنظام', value: 'default' },
    { label: 'إشعارات صامتة', value: 'silent' },
    { label: 'نغمة هادئة', value: 'calm.wav' },
    { label: 'نغمة لطيفة', value: 'gentle.wav' },
    { label: 'نغمة تنبيه', value: 'urgent.wav' },
  ];

  return (
    <ScrollView style={styles.screen}>
      <View style={styles.section}>
        <Text style={styles.header}>إعدادات الصوت</Text>
        <SettingsRow
          icon="bell-ring-outline"
          title="صوت إشعارات الجرعات"
          subtitle="اختر النغمة التي تفضلها لتذكيرك بمواعيد الدواء."
        />
        <RadioButton.Group onValueChange={value => handleSelectSound(value as NotificationSound)} value={selectedSound}>
          {soundOptions.map(option => (
            <RadioButton.Item 
              key={option.value} 
              label={option.label} 
              value={option.value}
              style={styles.radioItem}
              labelStyle={styles.radioLabel}
              position="leading"
            />
          ))}
        </RadioButton.Group>
      </View>
    </ScrollView>
  );
}

// (الأنماط لا تحتاج إلى أي تعديل)
const createStyles = (theme: any) => StyleSheet.create({
  screen: { flex: 1, backgroundColor: theme.colors.background },
  section: { marginTop: 20, paddingHorizontal: 16 },
  header: { fontFamily: 'Cairo-Bold', paddingTop: 30, fontSize: 22, color: theme.colors.primary, marginBottom: 8, textAlign: 'auto' },
  radioItem: { backgroundColor: theme.colors.surface, marginBottom: 2, flexDirection: 'row-reverse' },
  radioLabel: { textAlign: 'auto', fontFamily: 'Cairo-SemiBold' },
});
