// الموقع: app/settings/profile.tsx

// --- ✅ 1. استيراد الأدوات اللازمة ---
import { getUserProfile, saveUserProfile } from '@/services/profileManager';
import DateTimePicker, { type DateTimePickerEvent } from '@react-native-community/datetimepicker';
import React, { useEffect, useState } from 'react';
import { Alert, ScrollView, StyleSheet, TouchableOpacity, View } from 'react-native';
import { Avatar, Button, Surface, Text, TextInput, useTheme } from 'react-native-paper';

export default function ProfileScreen() {
  const theme = useTheme();
  const styles = createStyles(theme);

  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  
  // --- ✅ 2. فصل حالة التاريخ إلى جزأين: كائن التاريخ للعجلة، والنص للعرض ---
  const [dateObject, setDateObject] = useState(new Date());
  const [birthDateString, setBirthDateString] = useState('لم يتم التعيين');
  
  // حالة للتحكم في ظهور وإخفاء منتقي التاريخ
  const [showPicker, setShowPicker] = useState(false);

  // دالة مساعدة لتحويل التاريخ إلى نص للعرض والحفظ
  const formatDateForDisplay = (d: Date) => {
    const year = d.getFullYear();
    const month = (d.getMonth() + 1).toString().padStart(2, '0');
    const day = d.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // جلب البيانات عند فتح الشاشة
  useEffect(() => {
    const loadProfile = async () => {
      const profile = await getUserProfile();
      if (profile) {
        setFirstName(profile.firstName || '');
        setLastName(profile.lastName || '');
        if (profile.birthDate && profile.birthDate !== 'لم يتم التعيين') {
          // تأكد من أن التاريخ القادم من قاعدة البيانات يتم تحويله إلى كائن تاريخ صحيح
          const loadedDate = new Date(profile.birthDate);
          setDateObject(loadedDate);
          setBirthDateString(formatDateForDisplay(loadedDate));
        }
      }
    };
    loadProfile();
  }, []);

  // --- ✅ 3. دالة معالجة اختيار التاريخ ---
  const handleDateChange = (event: DateTimePickerEvent, selectedDate?: Date) => {
    setShowPicker(false); // إخفاء المنتقي أولاً
    if (event.type === 'set' && selectedDate) {
      setDateObject(selectedDate);
      setBirthDateString(formatDateForDisplay(selectedDate));
    }
  };
  
  const handleSave = async () => {
    try {
      // نستخدم النص المنسق للحفظ في قاعدة البيانات
      await saveUserProfile({ firstName, lastName, birthDate: birthDateString });
      Alert.alert('نجاح', 'تم حفظ بيانات الملف الشخصي بنجاح.');
    } catch (error) {
      console.error(error);
      Alert.alert('خطأ', 'حدث خطأ أثناء حفظ البيانات.');
    }
  };

  return (
    <View style={{ flex: 1 }}>
      <ScrollView style={styles.screen} contentContainerStyle={styles.container}>
        {/* ... (قسم الصورة الرمزية لا يتغير) ... */}
        <View style={styles.avatarContainer}>
            <Avatar.Icon size={120} icon="account-circle-outline" style={{ backgroundColor: theme.colors.primaryContainer }} />
            <Text variant="headlineSmall" style={styles.userName}>{`${firstName} ${lastName}`.trim() || 'اسم المستخدم'}</Text>
        </View>

        <Surface style={styles.formSection} elevation={2}>
          <Text style={styles.sectionTitle}>المعلومات الأساسية</Text>
          <View style={styles.row}>
            {/* ... (حقول الاسم لا تتغير) ... */}
            <TextInput label="الاسم الأول" value={firstName} onChangeText={setFirstName} mode="outlined" style={styles.input} left={<TextInput.Icon icon="account" />} />
            <TextInput label="الاسم الأخير" value={lastName} onChangeText={setLastName} mode="outlined" style={styles.input} left={<TextInput.Icon icon="account-outline" />} />
          </View>
          <View style={styles.row}>
            {/* --- ✅ 4. جعل حقل الإدخال قابلاً للضغط --- */}
            <TouchableOpacity onPress={() => setShowPicker(true)} style={{ flex: 1 }}>
              {/* نستخدم View مع pointerEvents لمنع الكتابة وعرض لوحة المفاتيح */}
              <View pointerEvents="none">
                <TextInput
                  label="تاريخ الميلاد"
                  value={birthDateString}
                  editable={false}
                  mode="outlined"
                  style={styles.input}
                  left={<TextInput.Icon icon="calendar" />}
                />
              </View>
            </TouchableOpacity>
          </View>
        </Surface>
        
        <Button mode="contained" onPress={handleSave} style={styles.saveButton} labelStyle={styles.saveButtonText} icon="check-circle">
          حفظ التغييرات
        </Button>
      </ScrollView>

      {/* --- ✅ 5. عرض منتقي التاريخ بشكل شرطي --- */}
      {showPicker && (
        <DateTimePicker
          value={dateObject}
          mode={'date'}
          display="spinner" // هذا يعطي شكل العجلة الجميل على كل الأنظمة
          onChange={handleDateChange}
          maximumDate={new Date()} // لمنع اختيار تواريخ مستقبلية
        />
      )}
    </View>
  );
}

// الأنماط لا تحتاج إلى أي تعديل
const createStyles = (theme: any) => StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  container: {
    padding: 20,
    paddingBottom: 50, // مسافة إضافية في الأسفل
    paddingTop: 70,
  },
  avatarContainer: {
    alignItems: 'center',
    marginBottom: 30,
  },
  userName: {
    marginTop: 16,
    fontFamily: 'Cairo-Bold',
    color: theme.colors.onSurface,
  },
  formSection: {
    padding: 16,
    borderRadius: 12,
    backgroundColor: theme.colors.surface,
    marginBottom: 24,
  },
  sectionTitle: {
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.primary,
    marginBottom: 16,
    textAlign: 'auto',
  },
  row: {
    flexDirection: 'row-reverse',
    gap: 12,
    marginBottom: 8,
  },
  input: {
    flex: 1,
    textAlign: 'auto',
  },
  saveButton: {
    paddingVertical: 8,
    borderRadius: 12,
    marginHorizontal: 20,
  },
  saveButtonText: {
    fontFamily: 'Cairo-Bold',
    fontSize: 16,
  },
});
