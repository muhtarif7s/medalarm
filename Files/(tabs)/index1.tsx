// الموقع: app/(tabs)/add-medicine/index.tsx (النسخة النهائية المتوافقة مع المنهجية الكاملة)

// --- 1. استيراد هوك الترجمة ---
import { useTranslation } from '@/context/TranslationContext';

// --- بقية الاستيرادات ---
import BasicInfoSection from '@/components2/BasicInfoSection';
import DoseScheduleSection from '@/components2/DoseScheduleSection';
import DurationSection from '@/components2/DurationSection';
import FrequencySection from '@/components2/FrequencySection';
import InventorySection from '@/components2/InventorySection';
import { useAppContext } from '@/context/AppContext';
import * as manager from '@/services/medicineManager';
import type { NewMedicine } from '@/types/medicine';
import DateTimePicker, { type DateTimePickerEvent } from '@react-native-community/datetimepicker';
import { useRouter } from 'expo-router';
import React, { useState } from 'react';
import { Alert, I18nManager, KeyboardAvoidingView, Platform, ScrollView, StyleSheet, View, type TextStyle } from 'react-native'; // <-- استيراد TextStyle
import { Appbar, Divider, TextInput, useTheme } from 'react-native-paper';

const normalizeArabicNumerals = (str: string): string => {
  if (!str) return '';
  return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d).toString());
};

export default function AddMedicineScreen() {
  const router = useRouter();
  const theme = useTheme();
  const { refreshData } = useAppContext();
  // --- 2. استخدام هوك الترجمة للحصول على الدالة واللغة ---
  const { t, language } = useTranslation();

  // --- 3. تعريف الأنماط الديناميكية مع تجنب خطأ TypeScript ---
  const dynamicHeaderStyle: TextStyle = { fontFamily: language === 'ar' ? 'Cairo-Bold' : 'System' };
  const dynamicInputStyle: TextStyle = { textAlign: I18nManager.isRTL ? 'right' : 'left' };

  // (States)
  const [name, setName] = useState('');
  const [dosageAmount, setDosageAmount] = useState('');
  // --- 4. استخدام مفتاح الترجمة للقيمة الافتراضية ---
  const [dosageUnit, setDosageUnit] = useState(t('addMedicine.defaultUnit'));
  const [doseTimes, setDoseTimes] = useState<string[]>([]);
  const [startDate, setStartDate] = useState(new Date());
  const [endDate, setEndDate] = useState<Date | undefined>(undefined);
  const [totalQuantity, setTotalQuantity] = useState('');
  const [refillReminderAt, setRefillReminderAt] = useState('');
  const [notes, setNotes] = useState('');
  const [frequencyType, setFrequencyType] = useState<'daily' | 'specific_days' | 'interval'>('daily');
  const [specificDays, setSpecificDays] = useState<string[]>([]);
  const [intervalValue, setIntervalValue] = useState('1');
  const [picker, setPicker] = useState<{ visible: boolean; mode: 'date' | 'time'; target: 'start' | 'end' | 'doseTime'; value: Date; }>({ visible: false, mode: 'date', target: 'start', value: new Date() });

  // (دوال الواجهة)
  const showPicker = (mode: 'date' | 'time', target: 'start' | 'end' | 'doseTime') => {
    let value = new Date();
    if (target === 'start') value = startDate;
    if (target === 'end') value = endDate || new Date();
    setPicker({ visible: true, mode, target, value });
  };

  const handlePickerChange = (event: DateTimePickerEvent, selectedDate?: Date) => {
    setPicker({ ...picker, visible: false });
    if (event.type === 'dismissed' || !selectedDate) return;

    if (picker.target === 'start') setStartDate(selectedDate);
    else if (picker.target === 'end') setEndDate(selectedDate);
    else if (picker.target === 'doseTime') {
      // --- 5. جعل لغة الوقت ديناميكية بناءً على لغة التطبيق ---
      const locale = language === 'ar' ? 'ar-EG' : 'en-US';
      const formattedTime = selectedDate.toLocaleTimeString(locale, { hour: 'numeric', minute: '2-digit', hour12: true });
      if (!doseTimes.includes(formattedTime)) setDoseTimes([...doseTimes, formattedTime].sort());
    }
  };

  const removeTime = (timeToRemove: string) => setDoseTimes(doseTimes.filter(time => time !== timeToRemove));
  const handleDayToggle = (day: string) => setSpecificDays(prev => prev.includes(day) ? prev.filter(d => d !== day) : [...prev, day]);

  // --- 6. دالة الحفظ مع استخدام مفاتيح الترجمة للرسائل ---
  const handleSave = async () => {
    if (!name.trim() || !dosageAmount.trim() || doseTimes.length === 0) {
      Alert.alert(t('alerts.requiredFields'), t('alerts.requiredFieldsMessage'));
      return;
    }
    const newMedicine: NewMedicine = { name: name.trim(), notes: notes.trim(), dosage_amount: parseFloat(normalizeArabicNumerals(dosageAmount)) || 1, dosage_unit: dosageUnit.trim(), total_quantity: totalQuantity ? parseFloat(normalizeArabicNumerals(totalQuantity)) : undefined, refill_reminder_at: refillReminderAt ? parseFloat(normalizeArabicNumerals(refillReminderAt)) : undefined, frequency_type: frequencyType, dose_times: JSON.stringify(doseTimes), start_date: startDate.toISOString(), end_date: endDate?.toISOString(), specific_days: frequencyType === 'specific_days' ? JSON.stringify(specificDays) : undefined, interval_days: frequencyType === 'interval' ? parseInt(normalizeArabicNumerals(intervalValue), 10) : undefined, skip_count: 0, };
    try {
      await manager.addNewMedicine(newMedicine);
      await refreshData();
      router.back();
    } catch (error) {
      console.error("Failed to save medicine via manager:", error);
      Alert.alert(t('alerts.error'), t('alerts.saveError'));
    }
  };

  return (
    <KeyboardAvoidingView style={{ flex: 1 }} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <View style={[styles.screen, { backgroundColor: theme.colors.background }]}>
        {/* --- 7. تطبيق لون الثيم على الـ Appbar --- */}
        <Appbar.Header style={{ backgroundColor: theme.colors.surface }}>
          <Appbar.BackAction onPress={() => router.back()} />
          <Appbar.Content
            title={t('addMedicine.screenTitle')}
            titleStyle={dynamicHeaderStyle}
          />
          <Appbar.Action icon="check" onPress={handleSave} />
        </Appbar.Header>
        <ScrollView contentContainerStyle={styles.container}>
          <BasicInfoSection name={name} onNameChange={setName} dosageAmount={dosageAmount} onDosageAmountChange={setDosageAmount} dosageUnit={dosageUnit} onDosageUnitChange={setDosageUnit} />
          <Divider style={styles.divider} />
          <DoseScheduleSection doseTimes={doseTimes} onAddTime={() => showPicker('time', 'doseTime')} onRemoveTime={removeTime} />
          <Divider style={styles.divider} />
          <DurationSection startDate={startDate} endDate={endDate} onShowPicker={showPicker} />
          <Divider style={styles.divider} />
          <FrequencySection frequencyType={frequencyType} onFrequencyChange={setFrequencyType} specificDays={specificDays} onDayToggle={handleDayToggle} intervalValue={intervalValue} onIntervalChange={setIntervalValue} />

          <Divider style={styles.divider} />
          <InventorySection totalQuantity={totalQuantity} onTotalQuantityChange={setTotalQuantity} refillReminderAt={refillReminderAt} onRefillReminderAtChange={setRefillReminderAt} />
          <Divider style={styles.divider} />
          {/* --- 8. تطبيق الترجمة والمحاذاة الديناميكية على حقل الملاحظات --- */}
          <TextInput
            label={t('addMedicine.notesLabel')}
            value={notes}
            onChangeText={setNotes}
            mode="outlined"
            multiline
            numberOfLines={3}
            style={[styles.notesInput, dynamicInputStyle]}
            theme={{ roundness: 15 }}
          />
        </ScrollView>
        {picker.visible && (<DateTimePicker value={picker.value} mode={picker.mode} display={Platform.OS === 'ios' ? 'spinner' : 'default'} is24Hour={false} onChange={handlePickerChange} />)}
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  container: { padding: 16, paddingBottom: 100 },
  divider: { marginVertical: 0, height: 0 },
  notesInput: { marginBottom: 20 },
});

