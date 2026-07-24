importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyA62Risb_LaDt4orGYmMXYdl-RGMYEJBHY",
  authDomain: "my-first-app-11715.firebaseapp.com",
  projectId: "my-first-app-11715",
  storageBucket: "my-first-app-11715.firebasestorage.app",
  messagingSenderId: "88015382345",
  appId: "1:88015382345:web:560508ace06ddd54e41c98"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Background message received:', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});