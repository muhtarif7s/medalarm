// الموقع: app/OnboardingScreen.tsx
// هذا هو الهيكل المطور الذي يدعم الرسوم المتحركة (Lottie)

import LottieView from 'lottie-react-native'; // <-- استيراد مكتبة Lottie
import React from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';

// الحصول على أبعاد الشاشة لتصميم متجاوب
const { width, height } = Dimensions.get('window');

// هذا هو المحتوى المطور، الآن يستخدم مسارات لملفات Lottie
const onboardingSlides = [
    {
        key: '1',
        title: 'أهلاً بك في رفيقك الصحي',
        description: 'نحن هنا لنجعل رحلتك مع الدواء أسهل وأكثر أمانًا والتزامًا.',
        animation: require('../assets/animations/slide1.json'), // <-- مسار ملف Lottie
    },
    {
        key: '2',
        title: 'لا تفوّت جرعة بعد اليوم',
        description: 'احصل على تذكيرات ذكية ودقيقة في الوقت المثالي لتناول دوائك.',
        animation: require('../assets/animations/slide2.json'), // <-- مسار ملف Lottie
    },
    {
        key: '3',
        title: 'تابع تقدمك بسهولة',
        description: 'احصل على تقارير وإحصائيات مفصلة تساعدك على فهم التزامك بشكل أفضل.',
        animation: require('../assets/animations/slide3.json'), // <-- مسار ملف Lottie
    },
    {
        key: '4',
        title: 'إدارة المخزون بذكاء',
        description: 'سنقوم بتنبيهك قبل نفاد دوائك بوقت كافٍ لتعيد تعبئته.',
        animation: require('../assets/animations/slide4.json'), // <-- مسار ملف Lottie
    },
    {
        key: '5',
        title: 'أنت الآن جاهز للبدء!',
        description: 'اضغط على زر البدء لتبدأ رحلتك نحو صحة أفضل والتزام مثالي.',
        animation: require('../assets/animations/slide5.json'), // <-- مسار ملف Lottie
    },
];

export default function OnboardingScreen() {
    const { colors } = useTheme();

    // في الخطوات التالية، سنقوم ببناء الواجهة هنا
    // باستخدام LottieView لعرض الرسوم المتحركة

    return (
        <View style={[styles.container, { backgroundColor: colors.background }]}>
            {/* مثال بسيط لعرض أول حركة */}
            <LottieView
                source={onboardingSlides[0].animation}
                autoPlay
                loop
                style={styles.lottie}
            />
            <Text style={{ color: 'white', fontSize: 24, fontWeight: 'bold' }}>
                {onboardingSlides[0].title}
            </Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    lottie: {
        width: width * 0.8,
        height: width * 0.8,
    },
});

