// الموقع: components2/MissedDosesManager.tsx

import { useAppContext } from '@/context/AppContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { FAB } from 'react-native-paper';

// هذا المكون أصبح الآن أبسط بكثير. وظيفته الوحيدة هي إظهار زر يقوم بالتنقل.
export default function MissedDosesManager() {
  const { missedDoses } = useAppContext();
  const router = useRouter();

  // لا تقم بعرض أي شيء إذا لم تكن هناك جرعات فائتة.
  if (missedDoses.length === 0) {
    return null;
  }
  
  // عند الضغط على الزر، انتقل إلى الشاشة الجديدة
  const handlePress = () => {
    router.push('/missed-doses');
  };

  return (
    <View style={styles.fabContainer}>
      <FAB
        icon={() => <MaterialCommunityIcons name="bell-alert" size={24} color="white" />}
        label={`${missedDoses.length} فائتة`}
        style={styles.fab}
        color="white"
        onPress={handlePress}
        uppercase={false}
        variant='secondary'
      />
      {/* لم نعد بحاجة لشارة منفصلة لأن FAB يدعم عرض النص */}
    </View>
  );
}

const styles = StyleSheet.create({
  fabContainer: {
    position: 'absolute',
    left: 16,
    bottom: 80,
    alignItems: 'center',
  },
  fab: {
    backgroundColor: '#D32F2F',
  },
});
