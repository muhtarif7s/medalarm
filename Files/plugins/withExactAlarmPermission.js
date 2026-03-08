// plugins/withExactAlarmPermission.js
const { withAndroidManifest } = require('@expo/config-plugins');

/**
 * Config Plugin لإضافة إذن SCHEDULE_EXACT_ALARM
 * يشتغل فقط وقت الـ prebuild على سيرفر EAS
 */
function withExactAlarmPermission(config) {
  return withAndroidManifest(config, (config) => {
    const permission = 'android.permission.SCHEDULE_EXACT_ALARM';

    if (!config.modResults.manifest['uses-permission']) {
      config.modResults.manifest['uses-permission'] = [];
    }

    const alreadyExists = config.modResults.manifest['uses-permission'].some(
      (p) => p.$['android:name'] === permission
    );

    if (!alreadyExists) {
      config.modResults.manifest['uses-permission'].push({
        $: { 'android:name': permission },
      });
      console.log(`✅ تم إضافة الإذن: ${permission}`);
    } else {
      console.log(`ℹ️ الإذن ${permission} موجود بالفعل`);
    }

    return config;
  });
}

module.exports = withExactAlarmPermission;