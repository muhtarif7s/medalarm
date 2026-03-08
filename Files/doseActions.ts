// الموقع: services/doseActions.ts
import type { UpcomingDose } from '@/types/medicine';
import { Alert } from 'react-native';
import * as manager from './medicineManager';

export const handleTakeDose = async (dose: UpcomingDose, refreshData: () => Promise<void>) => {
  Alert.alert(
    "تأكيد أخذ الجرعة",
    `هل أنت متأكد أنك أخذت جرعة (${dose.dosage}) من ${dose.medicineName}؟`,
    [
      { text: "إلغاء", style: "cancel" },
      {
        text: "نعم، تم أخذها",
        onPress: async () => {
          try {
            await manager.handleTakeDose(dose);
            await refreshData();
          } catch (e) {
            console.error(e);
            Alert.alert("خطأ", "لم يتم تسجيل الجرعة. يرجى المحاولة مرة أخرى.");
          }
        },
      },
    ]
  );
};

export const handleSkipDose = async (dose: UpcomingDose, refreshData: () => Promise<void>) => {
  Alert.alert(
    "تأكيد تخطي الجرعة",
    `هل أنت متأكد من تخطي هذه الجرعة من ${dose.medicineName}؟`,
    [
      { text: "إلغاء", style: "cancel" },
      {
        text: "نعم، تخطي",
        onPress: async () => {
          try {
            await manager.handleSkipDose(dose);
            await refreshData();
            Alert.alert("تم التخطي بنجاح");
          } catch (e) {
            console.error(e);
            Alert.alert("خطأ", "لم يتم تخطي الجرعة. يرجى المحاولة مرة أخرى.");
          }
        },
      },
    ]
  );
};
