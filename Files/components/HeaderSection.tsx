// الموقع: app/(tabs)/home/components/HeaderSection.tsx

import { getUserProfile, type UserProfile } from '@/services/profileManager';
import { differenceInYears } from 'date-fns'; // ✅ 1. استيراد دالة حساب العمر
import { BlurView } from 'expo-blur';
import { LinearGradient } from 'expo-linear-gradient';
import { Link, useFocusEffect } from 'expo-router';
import React, { useCallback, useState } from 'react';
import { StatusBar, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from 'react-native-paper';

export default function HeaderSection() {
  const theme = useTheme();
  
  // --- ✅ 2. إضافة حالة لتخزين بيانات الملف الشخصي ---
  const [profile, setProfile] = useState<UserProfile | null>(null);

  // --- ✅ 3. جلب البيانات تلقائيًا في كل مرة تظهر فيها الشاشة ---
  useFocusEffect(
    useCallback(() => {
      const loadProfile = async () => {
        const userProfile = await getUserProfile();
        setProfile(userProfile);
      };
      loadProfile();
    }, [])
  );

  // --- ✅ 4. حساب البيانات الديناميكية ---
  const today = new Date();
  const dateString = today.toLocaleDateString('ar-EG', {
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
  });

  // حساب اسم المستخدم مع قيمة افتراضية
  const userName = profile?.firstName || 'مستخدم';
  
  // حساب الحرف الأول من الاسم
  const profileInitial = userName.charAt(0).toUpperCase();

  // حساب العمر
  const age = profile?.birthDate && profile.birthDate !== 'لم يتم التعيين'
    ? differenceInYears(today, new Date(profile.birthDate))
    : null;

  return (
    <>
      <LinearGradient colors={['#FFFFFF', '#00695C']} style={styles.statusBarGradient}>
        <StatusBar translucent backgroundColor="transparent" barStyle="dark-content" />
      </LinearGradient>

      <LinearGradient colors={['#00695C', '#004D40']} style={styles.gradient}>
        <BlurView intensity={0} tint="dark" style={styles.blurBackground}>
          <View style={styles.container}>
            <View>
              {/* --- ✅ 5. عرض البيانات الحقيقية --- */}
              <Text style={styles.greeting}>مساء الخير، {userName}</Text>
              <Text style={styles.date}>
                {dateString} {age && ` (العمر: ${age} عامًا)`}
              </Text>
            </View>
            
            {/* --- ✅ 6. إصلاح الرابط وتخصيص الحرف الأول --- */}
            <Link href="/settings/profile" asChild>
              <TouchableOpacity>
                <View style={[styles.profileCircle, { backgroundColor: theme.colors.primary }]}>
                  <Text style={styles.profileInitial}>{profileInitial}</Text>
                </View>
              </TouchableOpacity>
            </Link>
          </View>
        </BlurView>
      </LinearGradient>
    </>
  );
}

// (الأنماط لا تحتاج إلى أي تعديل، فهي متوافقة بالفعل)
const styles = StyleSheet.create({
  statusBarGradient: {
    height: StatusBar.currentHeight || 24,
  },
  gradient: {
    paddingTop: 20,
    paddingBottom: 20,
    paddingHorizontal: 20,
    borderBottomLeftRadius: 25,
    borderBottomRightRadius: 25,
    overflow: 'hidden',
  },
  blurBackground: {
    flex: 1,
    borderBottomLeftRadius: 25,
    borderBottomRightRadius: 25,
    overflow: 'hidden'
  },
  container: {
    flexDirection: 'row-reverse',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginStart: 10,
  },
  greeting: {
    fontFamily: 'Cairo-Bold',
    fontSize: 24,
    color: 'white',
    textAlign: 'auto',
  },
  date: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    color: '#B2DFDB',
    textAlign: 'auto',
  },
  profileCircle: {
    width: 50,
    height: 50,
    borderRadius: 25,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000000ff',
    shadowOpacity: 0.2,
    shadowRadius: 4,
    shadowOffset: { width: 0, height: 2 },
    elevation: 5,
  },
  profileInitial: {
    color: 'white',
    fontSize: 24,
    fontFamily: 'Cairo-Bold',
  },
});
