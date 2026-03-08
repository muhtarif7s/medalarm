// الموقع: context/TranslationContext.tsx (النسخة النهائية مع ذاكرة دائمة)

import AsyncStorage from '@react-native-async-storage/async-storage'; // <-- 1. استيراد أداة التخزين
import * as Localization from 'expo-localization';
import React, { createContext, ReactNode, useCallback, useContext, useEffect, useState } from 'react';

// استيراد ملفات الترجمة
import arTranslations from '../locales/ar.json';
import enTranslations from '../locales/en.json';

const STORAGE_KEY = '@app_language'; // مفتاح التخزين

type Language = 'ar' | 'en';
const translations = { ar: arTranslations, en: enTranslations };

interface ITranslationContext {
  t: (key: string) => string;
  setLanguage: (language: Language) => void;
  language: Language;
  isLoaded: boolean; // حالة جديدة لمعرفة متى يتم تحميل اللغة
}

const TranslationContext = createContext<ITranslationContext | undefined>(undefined);

export const TranslationProvider = ({ children }: { children: ReactNode }) => {
  const [language, setLanguageState] = useState<Language>('ar'); // قيمة ابتدائية مؤقتة
  const [isLoaded, setIsLoaded] = useState(false);

  // --- 2. دالة التحميل من الذاكرة عند بدء التشغيل ---
  useEffect(() => {
    const loadLanguage = async () => {
      try {
        const storedLanguage = await AsyncStorage.getItem(STORAGE_KEY) as Language | null;
        if (storedLanguage) {
          setLanguageState(storedLanguage);
        } else {
          // إذا لم يجد لغة مخزنة، استخدم لغة الجهاز
          const deviceLanguage = Localization.getLocales()[0]?.languageCode;
          setLanguageState(deviceLanguage === 'ar' ? 'ar' : 'en');
        }
      } catch (e) {
        console.error("Failed to load language.", e);
        // في حالة الفشل، استخدم لغة الجهاز كحل بديل
        const deviceLanguage = Localization.getLocales()[0]?.languageCode;
        setLanguageState(deviceLanguage === 'ar' ? 'ar' : 'en');
      } finally {
        setIsLoaded(true); // تم التحميل بنجاح
      }
    };
    loadLanguage();
  }, []);

  // --- 3. الدالة الجديدة التي تحفظ في الذاكرة ---
  const setLanguage = useCallback(async (lang: Language) => {
    try {
      await AsyncStorage.setItem(STORAGE_KEY, lang);
      setLanguageState(lang); // تحديث الحالة بعد الحفظ
    } catch (e) {
      console.error("Failed to save language.", e);
    }
  }, []);
  
  const t = useCallback((key: string): string => {
    const keys = key.split('.');
    let result: any = translations[language];
    for (const k of keys) {
      if (result && typeof result === 'object' && k in result) {
        result = result[k];
      } else {
        return key;
      }
    }
    return String(result);
  }, [language]);

  return (
    <TranslationContext.Provider value={{ t, setLanguage, language, isLoaded }}>
      {isLoaded ? children : null}
      {/* عرض التطبيق فقط بعد تحميل اللغة لتجنب الوميض */}
    </TranslationContext.Provider>
  );
};

export const useTranslation = (): ITranslationContext => {
  const context = useContext(TranslationContext);
  if (!context) {
    throw new Error('useTranslation must be used within a TranslationProvider');
  }
  return context;
};
