import BasicInfoSection from '@/components2/BasicInfoSection';
import DoseScheduleSection from '@/components2/DoseScheduleSection';
import DurationSection from '@/components2/DurationSection';
import FrequencySection from '@/components2/FrequencySection';
import InventorySection from '@/components2/InventorySection';
import { useAppContext } from '@/context/AppContext';
import { useTranslation } from '@/context/TranslationContext';
import * as manager from '@/services/medicineManager';
import type { Medicine, NewMedicine } from '@/types/medicine';
import DateTimePicker, { type DateTimePickerEvent } from '@react-native-community/datetimepicker';
import { router, useLocalSearchParams } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
  Alert,
  I18nManager,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  View,
  type TextStyle
} from 'react-native';
import { Appbar, Divider, TextInput, useTheme } from 'react-native-paper';

const normalizeArabicNumerals = (str: string): string => {
  if (!str) return '';
  return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d).toString());
};

export default function EditMedicineScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const theme = useTheme();
  const { refreshData } = useAppContext();
  const { t, language } = useTranslation();
  
  // حالة التحميل والأخطاء
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [medicine, setMedicine] = useState<Medicine | null>(null);
  
  // حالة النموذج - نفس الشكل كما في شاشة الإضافة
  const [name, setName] = useState('');
  const [dosageAmount, setDosageAmount] = useState('');
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
  
  // حالة DatePicker - نفس الشكل
  const [picker, setPicker] = useState<{
    visible: boolean;
    mode: 'date' | 'time';
    target: 'start' | 'end' | 'doseTime';
    value: Date;
  }>({ visible: false, mode: 'date', target: 'start', value: new Date() });

  // الأنماط الديناميكية
  const dynamicHeaderStyle: TextStyle = { fontFamily: language === 'ar' ? 'Cairo-Bold' : 'System' };
  const dynamicInputStyle: TextStyle = { textAlign: I18nManager.isRTL ? 'right' : 'left' };

  // تحميل بيانات الدواء
  useEffect(() => {
    loadMedicine();
  }, []);

  const loadMedicine = async () => {
    try {
      setLoading(true);
      const medicineData = await manager.getMedicineDetails(parseInt(id));
      if (!medicineData) {
        Alert.alert(t('alerts.error'), 'لم يتم العثور على الدواء');
        router.back();
        return;
      }
      
      setMedicine(medicineData);
      
      // تعبئة النموذج بالبيانات الحالية
      const doseTimes = JSON.parse(medicineData.dose_times || '[]');
      const specificDays = medicineData.specific_days ? JSON.parse(medicineData.specific_days) : [];
      
      setName(medicineData.name);
      setDosageAmount(medicineData.dosage_amount.toString());
      setDosageUnit(medicineData.dosage_unit);
      setDoseTimes(doseTimes);
      setStartDate(new Date(medicineData.start_date));
      setEndDate(medicineData.end_date ? new Date(medicineData.end_date) : undefined);
      setTotalQuantity(medicineData.total_quantity?.toString() || '');
      setRefillReminderAt(medicineData.refill_reminder_at?.toString() || '');
      setNotes(medicineData.notes || '');
      setFrequencyType(medicineData.frequency_type);
      setSpecificDays(specificDays);
      setIntervalValue(medicineData.interval_days?.toString() || '1');
    } catch (error) {
      console.error('Error loading medicine:', error);
      Alert.alert(t('alerts.error'), 'حدث خطأ في تحميل بيانات الدواء');
    } finally {
      setLoading(false);
    }
  };

  // دوال الواجهة - نفس المنطق من شاشة الإضافة
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
      const locale = language === 'ar' ? 'ar-EG' : 'en-US';
      const formattedTime = selectedDate.toLocaleTimeString(locale, { 
        hour: 'numeric', 
        minute: '2-digit', 
        hour12: true 
      });
      if (!doseTimes.includes(formattedTime)) {
        setDoseTimes([...doseTimes, formattedTime].sort());
      }
    }
  };

  const removeTime = (timeToRemove: string) => {
    setDoseTimes(doseTimes.filter(time => time !== timeToRemove));
  };

  const handleDayToggle = (day: string) => {
    setSpecificDays(prev => 
      prev.includes(day) 
        ? prev.filter(d => d !== day) 
        : [...prev, day]
    );
  };

  // حفظ التعديلات
  const handleSave = async () => {
    // التحقق من صحة البيانات
    if (!name.trim() || !dosageAmount.trim() || doseTimes.length === 0) {
      Alert.alert(t('alerts.requiredFields'), t('alerts.requiredFieldsMessage'));
      return;
    }

    if (frequencyType === 'specific_days' && specificDays.length === 0) {
      Alert.alert(t('alerts.error'), 'يرجى اختيار يوم واحد على الأقل');
      return;
    }

    try {
      setSaving(true);
      
      const updatedMedicine: Omit<NewMedicine, 'created_at'> = {
        name: name.trim(),
        notes: notes.trim() || undefined,
        icon_name: undefined,
        color: medicine?.color,
        dosage_amount: parseFloat(normalizeArabicNumerals(dosageAmount)) || 1,
        dosage_unit: dosageUnit.trim(),
        total_quantity: totalQuantity ? parseFloat(normalizeArabicNumerals(totalQuantity)) : undefined,
        remaining_quantity: medicine?.remaining_quantity,
        refill_reminder_at: refillReminderAt ? parseFloat(normalizeArabicNumerals(refillReminderAt)) : undefined,
        frequency_type: frequencyType,
        dose_times: JSON.stringify(doseTimes),
        specific_days: frequencyType === 'specific_days' ? JSON.stringify(specificDays) : undefined,
        interval_days: frequencyType === 'interval' ? parseInt(normalizeArabicNumerals(intervalValue), 10) : undefined,
        start_date: startDate.toISOString(),
        end_date: endDate?.toISOString(),
        skip_count: medicine?.skip_count || 0
      };

      await manager.updateExistingMedicine(parseInt(id), updatedMedicine);
      await refreshData();
      
      Alert.alert('تم', 'تم تحديث الدواء بنجاح', [
        { text: 'موافق', onPress: () => router.back() }
      ]);
    } catch (error) {
      console.error('Error updating medicine:', error);
      Alert.alert(t('alerts.error'), t('alerts.saveError'));
    } finally {
      setSaving(false);
    }
  };

  // حذف الدواء
  const handleDelete = () => {
    Alert.alert(
      'تأكيد الحذف',
      `هل أنت متأكد من حذف دواء "${medicine?.name}"؟\n\nسيتم حذف جميع البيانات المرتبطة به نهائياً.`,
      [
        { text: 'إلغاء', style: 'cancel' },
        {
          text: 'حذف',
          style: 'destructive',
          onPress: async () => {
            try {
              await manager.deleteExistingMedicine(parseInt(id));
              await refreshData();
              Alert.alert('تم', 'تم حذف الدواء بنجاح', [
                { text: 'موافق', onPress: () => router.back() }
              ]);
            } catch (error) {
              console.error('Error deleting medicine:', error);
              Alert.alert(t('alerts.error'), 'حدث خطأ أثناء حذف الدواء');
            }
          }
        }
      ]
    );
  };

  if (loading) {
    return (
      <View style={[styles.screen, { backgroundColor: theme.colors.background }]}>
        <Appbar.Header style={{ backgroundColor: theme.colors.surface }}>
          <Appbar.BackAction onPress={() => router.back()} />
          <Appbar.Content title="جار التحميل..." titleStyle={dynamicHeaderStyle} />
        </Appbar.Header>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView style={{ flex: 1 }} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <View style={[styles.screen, { backgroundColor: theme.colors.background }]}>
        <Appbar.Header style={{ backgroundColor: theme.colors.surface }}>
          <Appbar.BackAction onPress={() => router.back()} />
          <Appbar.Content
            title="تعديل الدواء"
            titleStyle={dynamicHeaderStyle}
          />
          <Appbar.Action 
            icon="check" 
            onPress={handleSave} 
            disabled={saving}
          />
          <Appbar.Action 
            icon="delete" 
            onPress={handleDelete}
            iconColor={theme.colors.error}
          />
        </Appbar.Header>
        
        <ScrollView contentContainerStyle={styles.container}>
          <BasicInfoSection 
            name={name} 
            onNameChange={setName} 
            dosageAmount={dosageAmount} 
            onDosageAmountChange={setDosageAmount} 
            dosageUnit={dosageUnit} 
            onDosageUnitChange={setDosageUnit} 
          />
          
          <Divider style={styles.divider} />
          
          <DoseScheduleSection 
            doseTimes={doseTimes} 
            onAddTime={() => showPicker('time', 'doseTime')} 
            onRemoveTime={removeTime} 
          />
          
          <Divider style={styles.divider} />
          
          <DurationSection 
            startDate={startDate} 
            endDate={endDate} 
            onShowPicker={showPicker} 
          />
          
          <Divider style={styles.divider} />
          
          <FrequencySection 
            frequencyType={frequencyType} 
            onFrequencyChange={setFrequencyType} 
            specificDays={specificDays} 
            onDayToggle={handleDayToggle} 
            intervalValue={intervalValue} 
            onIntervalChange={setIntervalValue} 
          />

          <Divider style={styles.divider} />
          
          <InventorySection 
            totalQuantity={totalQuantity} 
            onTotalQuantityChange={setTotalQuantity} 
            refillReminderAt={refillReminderAt} 
            onRefillReminderAtChange={setRefillReminderAt} 
          />
          
          <Divider style={styles.divider} />
          
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
        
        {picker.visible && (
          <DateTimePicker 
            value={picker.value} 
            mode={picker.mode} 
            display={Platform.OS === 'ios' ? 'spinner' : 'default'} 
            is24Hour={false} 
            onChange={handlePickerChange} 
          />
        )}
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  screen: { 
    flex: 1 
  },
  container: { 
    padding: 16, 
    paddingBottom: 100 
  },
  divider: { 
    marginVertical: 0, 
    height: 0 
  },
  notesInput: { 
    marginBottom: 20 
  },
});
