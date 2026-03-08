import { initializeDatabase } from '@/database/db';
import * as manager from '@/services/medicineManager';
import type { DoseHistory, Medicine, UpcomingDose } from '@/types/medicine';
import React, { ReactNode, createContext, useCallback, useContext, useEffect, useRef, useState } from 'react';

// --- 1. تعريف نوع Context (لا تغيير هنا) ---
interface AppContextType {
  medicines: Medicine[];
  upcomingDoses: UpcomingDose[];
  missedDoses: UpcomingDose[];
  doseHistory: DoseHistory[];
  startupLoading: boolean;
  refreshData: (isStartup?: boolean) => Promise<void>;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppContextProvider = ({ children }: { children: ReactNode }) => {
  const [medicines, setMedicines] = useState<Medicine[]>([]);
  const [upcomingDoses, setUpcomingDoses] = useState<UpcomingDose[]>([]);
  const [missedDoses, setMissedDoses] = useState<UpcomingDose[]>([]);
  const [doseHistory, setDoseHistory] = useState<DoseHistory[]>([]);
  const [startupLoading, setStartupLoading] = useState(true);
  const isRefreshingRef = useRef(false);

  // --- دالة تحديث البيانات (أصبحت الآن للواجهة فقط) ---
  const refreshData = useCallback(async (isStartup = false) => {
    if (isRefreshingRef.current && !isStartup) return;
    isRefreshingRef.current = true;
    
    if (isStartup) {
      setStartupLoading(true);
    }

    try {
      console.log('Fetching latest data for UI...');
      const data = await manager.getDashboardData();
      setMedicines(data.medicines);
      setUpcomingDoses(data.upcomingDoses); // للواجهة الرسومية
      setMissedDoses(data.missedDoses);
      setDoseHistory(data.doseHistory);
      
      console.log('UI Data updated successfully.');
      // ❌ لا توجد أي جدولة للإشعارات هنا بعد الآن
      
    } catch (error) {
      console.error("Error refreshing UI data:", error);
    } finally {
      if (isStartup) {
        setStartupLoading(false);
      }
      isRefreshingRef.current = false;
    }
  }, []);

  // --- المحرك الرئيسي للتطبيق ---
  useEffect(() => {
    const initializeApp = async () => {
      try {
        // سيتم نقل تسجيل العامل (Worker) إلى هنا لاحقاً
        
        await initializeDatabase();
        await refreshData(true); 
      } catch (e) {
        console.error("FATAL: Failed to initialize app.", e);
        setStartupLoading(false);
      }
    };

    initializeApp();

    const intervalId = setInterval(() => {
      console.log('Heartbeat: Refreshing UI data silently...');
      refreshData(false);
    }, 60000);

    return () => clearInterval(intervalId);
  }, [refreshData]);

  const value = { medicines, upcomingDoses, missedDoses, doseHistory, startupLoading, refreshData };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};

// --- Hook (لا تغيير هنا) ---
export const useAppContext = () => {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useAppContext must be used within an AppContextProvider');
  }
  return context;
};
